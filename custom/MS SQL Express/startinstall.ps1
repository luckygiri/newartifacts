[CmdletBinding()]
param(
)

###################################################################################################

#
# PowerShell configurations
#

# NOTE: Because the $ErrorActionPreference is "Stop", this script will stop on first failure.
#       This is necessary to ensure we capture errors inside the try-catch-finally block.
$ErrorActionPreference = "Stop"

# Ensure we set the working directory to that of the script.
pushd $PSScriptRoot

###################################################################################################

#
# Functions used in this script.
#

function Handle-LastError
{
    [CmdletBinding()]
    param(
    )

    $message = $error[0].Exception.Message
    if ($message)
    {
        Write-Host -Object "ERROR: $message" -ForegroundColor Red
    }
    
    # IMPORTANT NOTE: Throwing a terminating error (using $ErrorActionPreference = "Stop") still
    # returns exit code zero from the PowerShell script when using -File. The workaround is to
    # NOT use -File when calling this script and leverage the try-catch-finally block and return
    # a non-zero exit code from the catch block.
    exit -1
}

function Test-OsType
{
    $os_type = (Get-WmiObject -Class Win32_ComputerSystem).SystemType -match '(x64)'
    if ($os_type -ne "True")
    {
        throw '32-bit system is not supported'
    } 
}

function Create-Folder
{
    [CmdletBinding()]
    param(
        [string] $Path
    )

    New-Item -ItemType "directory" -Path $Path -Force
}

function Download-File
{
    [CmdletBinding()]
    param(
        [string] $Src,
        [string] $Dst
    )

    (New-Object System.Net.WebClient).DownloadFile($Src, $Dst)
}

function WaitForFile
{
    [CmdletBinding()]
    param (
        [string] $File
    )

    while(!(Test-Path $File))
    { 
        Start-Sleep -s 10; 
    } 
}

function Get-SetupFolder
{
    #Setup Folders
    $setupFolder = "c:\SoftwaresDump"
    Create-Folder "$setupFolder"
    Create-Folder "$setupFolder\sql"

    $setupFolder = "$setupFolder\sql"
    Create-Folder "$setupFolder\sqlbi"
    Create-Folder "$setupFolder\sqlbi\datasets"
    Create-Folder "$setupFolder\sqlbi\installations"

    return "$setupFolder\sqlbi\installations"
}

function Download-Components
{
    [CmdletBinding()]
    param(
        [string] $DestFolder
    )

    # SQL Server Installation 
    if (-not (Test-Path "$DestFolder\SQLServer2016-SSEI-Expr.exe"))
    {
        Write-Host "Downloading SQL Server installation file."
        Download-File 'http://download.microsoft.com/download/B/F/2/BF2EDBB8-004D-47F3-AA2B-FEA897591599/SQLServer2016-SSEI-Expr.exe" "$DestFolder\SQLServer2016-SSEI-Expr.exe'
    }

    # Prepare Configuration file
    Write-Host "Preparing configuration file.."
    if(-not (Test-Path "$DestFolder\ConfigurationFile.ini"))
    {
        Write-Host "Downloading SQL Server installation file.."
        Download-File "https://raw.githubusercontent.com/luckygiri/newartifacts/master/ConfigurationFile.ini" "$DestFolder\ConfigurationFile.ini"
    }

    # SSMS Installation 
    if(-not (Test-Path "$DestFolder\SSMS-Setup-ENU.exe"))
    {
        Write-Host "Downloading SSMS installation file."
        Download-File "https://download.microsoft.com/download/3/1/D/31D734E0-BFE8-4C33-A9DE-2392808ADEE6/SSMS-Setup-ENU.exe" "$DestFolder\SSMS-Setup-ENU.exe"
    }

    # SSDT Installation 
    if (-not (Test-Path "$DestFolder\SSDTSetup.exe"))
    {
        Write-Host "Downloading SSDT installation file.."
        Download-File "https://download.microsoft.com/download/9/C/7/9C749FF7-7AD2-409A-BF75-69238295A668/Dev14/EN/SSDTSetup.exe" "$DestFolder\SSDTSetup.exe"
    }
}

###################################################################################################

#
# Handle all errors in this script.
#

trap
{
    # NOTE: This trap will handle all errors. There should be no need to use a catch below in this
    #       script, unless you want to ignore a specific error.
    Handle-LastError
}

###################################################################################################

#
# Main execution block.
#

try
{
    Test-OsType

    $setupFolder = Get-SetupFolder
    Download-Components -DestFolder $setupFolder
    
    (Get-Content $setupFolder\ConfigurationFile.ini).replace('USERNAMETBR', "$env:computername\$env:username") | Set-Content $setupFolder\ConfigurationFile_local.ini

    Write-Host "Installing SQL Server.."
    Start-Process -FilePath "$setupFolder\SQLServer2016-SSEI-Expr.exe" -ArgumentList '/ConfigurationFile="c:\SoftwaresDump\sql\sqlbi\installations\ConfigurationFile_local.ini"', '/MediaPath="c:\SoftwaresDump\sql\sqlbi\installations"', '/IAcceptSqlServerLicenseTerms', '/ENU', '/QS' -Wait

    Write-Host "Installing SSMS.."
    Start-Process -FilePath "$setupFolder\SSMS-Setup-ENU.exe" -ArgumentList '/install','/passive' -Wait

    Write-Host "Installing SSDT.."
    Start-Process -FilePath "$setupFolder\SSDTSetup.exe" -ArgumentList '/INSTALLALL=1', '/passive', '/promptrestart' -Wait

    Write-Host 'Installation completed.'
}
finally
{
    popd
}
