
 
 
    $NewDIR = "C:\SoftwaresDump"
    $SoftwareWebLink = "http://artifacts.g7crm4l.org/Softwares/node-v6.9.2-x64.msi"
    $SoftwarePath = "C:\SoftwaresDump\node-v6.9.2-x64.msi"

    Write-Output 'Preparing temp directory ...'
    New-Item "C:\SoftwaresDump" -ItemType Directory -Force | Out-Null

    Write-Output 'Downloading pre-requisite files ...'
    (New-Object System.Net.WebClient).DownloadFile("$SoftwareWebLink", "$SoftwarePath")
   

    Write-Output 'Installing ...'
    Start-Process "C:\SoftwaresDump\node-v6.9.2-x64.msi" -ArgumentList '/q' -Wait 

    

    Write-Output 'Done!'
