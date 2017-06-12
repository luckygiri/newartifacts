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


Write-Host "Installing SSMS.."
Start-Process -FilePath "$setupFolder\SSMS-Setup-ENU.exe" -ArgumentList '/install','/passive' -Wait

Write-Host "Installing SSDT.."
Start-Process -FilePath "$setupFolder\SSDTSetup.exe" -ArgumentList '/INSTALLALL=1', '/passive', '/promptrestart' -Wait




Write-Host 'Installation completed.'
