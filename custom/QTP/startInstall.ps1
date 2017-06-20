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
 
 
    $NewDIR = "C:\SoftwaresDump\QTP12.5"
    $SoftwareWebLink = "http://artifacts.g7crm4l.org/Softwares/QTP12.5/QTP%2012%20-%20HP%20UFT%2012.54.zip"
    $SoftwarePath = "C:\SoftwaresDump\QTP12.5\QTP 12 - HP UFT 12.54.zip"

    Write-Output 'Preparing temp directory ...'
    New-Item "C:\SoftwaresDump\QTP12.5" -ItemType Directory -Force | Out-Null

    Write-Output 'Downloading pre-requisite files ...'
    (New-Object System.Net.WebClient).DownloadFile("$SoftwareWebLink", "$SoftwarePath")  
       
    Write-Output 'Extracting QTP ...'
    $shell = New-Object -ComObject shell.application
    $zip = $shell.NameSpace("$SOftwarePath")
    foreach ($item in $zip.items()) {
    $shell.Namespace("$NewDIR").CopyHere($item)
}




Write-Output 'Installing prerequesties ...'
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\dotnet35_sp1\dotnetfx35_sp1.exe" -ArgumentList '/q' -Wait 
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\dotnet45\dotnetfx45_full_x86_x64.exe" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\msade2010\AccessDatabaseEngine.exe" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\vc2008_sp1_redist_V9030729\vcredist_x86.exe" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\vc2010_redist\vcredist_x86.exe" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\vc2010_X64_redist\vcredist_x64.exe" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\vc2012_redist_x64\vcredist_x64.exe" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\vc2012_redist_x86\vcredist_x86.exe" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\vs2008_shell_sp1_isolated_redist\vs_shell_isolated.enu.exe" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\wse20sp3\MicrosoftWSE2.0SP3Runtime.msi" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\wse30\MicrosoftWSE3.0Runtime.msi" -ArgumentList '/q' -Wait


Write-Output 'Installing QTP ...'
Start-Process "C:\SoftwaresDump\QTP12.5\Unified Functional Testing\EN\setup.exe" -ArgumentList '/q'  -Wait  
   
    Write-Output 'Done!'
}
finally
{
    popd
}
