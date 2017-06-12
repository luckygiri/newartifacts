# Before running the script, set the execution policy
#Set-ExecutionPolicy RemoteSigned
#

#Helper Functions
function Create-Folder {
    Param ([string]$path)
    if ((Test-Path $path) -eq $false) 
    {
        Write-Host "$path doesn't exist. Creating now.."
        New-Item -ItemType "directory" -Path $path
    }
}

function Download-File{
    Param ([string]$src, [string] $dst)

    (New-Object System.Net.WebClient).DownloadFile($src,$dst)
    #Invoke-WebRequest $src -OutFile $dst
}

function WaitForFile($File) {
  while(!(Test-Path $File)) {    
    Start-Sleep -s 10;   
  }  
} 


#Setup Folders

$setupFolder = "c:\SoftwaresDump"
Create-Folder "$setupFolder"

Create-Folder "$setupFolder\sql"
$setupFolder = "$setupFolder\sql"

Create-Folder "$setupFolder\sqlbi"
Create-Folder "$setupFolder\sqlbi\datasets"
Create-Folder "$setupFolder\sqlbi\installations"
$setupFolder = "$setupFolder\sqlbi\installations"

$os_type = (Get-WmiObject -Class Win32_ComputerSystem).SystemType -match ‘(x64)’

# SQL Server Installation 
if((Test-Path "$setupFolder\SoftwaresDump") -eq $false)
{
    Write-Host "Downloading SQL Server installation file.."
    if ($os_type -eq "True"){
        Download-File "http://download.microsoft.com/download/B/F/2/BF2EDBB8-004D-47F3-AA2B-FEA897591599/SQLServer2016-SSEI-Expr.exe" "$setupFolder\SQLServer2016-SSEI-Expr.exe"
    }else {
        Write-Host "32 Bit system is not supported"
    }    
}

# Prepare Configuration file
Write-Host "Preparing configuration file.."
if((Test-Path "$setupFolder\ConfigurationFile.ini") -eq $false)
{
    Write-Host "Downloading SQL Server installation file.."
    if ($os_type -eq "True"){
        Download-File "https://raw.githubusercontent.com/luckygiri/newartifacts/master/ConfigurationFile.ini" "$setupFolder\ConfigurationFile.ini"
    }else {
        Write-Host "32 Bit system is not supported"
    }    
}

# SSMS Installation 
if((Test-Path "$setupFolder\SSMS-Setup-ENU.exe") -eq $false)
{
    Write-Host "Downloading SSMS installation file.."
    if ($os_type -eq "True"){
        Download-File "https://download.microsoft.com/download/3/1/D/31D734E0-BFE8-4C33-A9DE-2392808ADEE6/SSMS-Setup-ENU.exe" "$setupFolder\SSMS-Setup-ENU.exe"
    }else {
        Write-Host "32 Bit system is not supported"
    }    
}

# SSDT Installation 
if((Test-Path "$setupFolder\SSDTSetup.exe") -eq $false)
{
    Write-Host "Downloading SSDT installation file.."
    if ($os_type -eq "True"){
        Download-File "https://download.microsoft.com/download/9/C/7/9C749FF7-7AD2-409A-BF75-69238295A668/Dev14/EN/SSDTSetup.exe" "$setupFolder\SSDTSetup.exe"
    }else {
        Write-Host "32 Bit system is not supported"
    }    
}



(Get-Content $setupFolder\ConfigurationFile.ini).replace('USERNAMETBR', "$env:computername\$env:username") | Set-Content $setupFolder\ConfigurationFile_local.ini

Write-Host "Installing SQL Server.."
Start-Process -FilePath "$setupFolder\SQLServer2016-SSEI-Expr.exe" -ArgumentList '/ConfigurationFile="c:\SoftwaresDump\sql\sqlbi\installations\ConfigurationFile_local.ini"', '/MediaPath="c:\SoftwaresDump\sql\sqlbi\installations"', '/IAcceptSqlServerLicenseTerms', '/ENU', '/QS'  -Wait




Write-Host 'Installation completed.'
