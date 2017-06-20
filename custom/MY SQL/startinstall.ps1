
    $NewDIR = "C:\SoftwaresDump"
    $SoftwareWebLink = "http://artifacts.g7crm4l.org/Softwares/mysql-installer-community-5.7.16.0.msi"
    $SoftwarePath = "C:\SoftwaresDump\mysql-installer-community-5.7.16.0.msi"

    Write-Output 'Preparing temp directory ...'
    New-Item "C:\SoftwaresDump" -ItemType Directory -Force | Out-Null

    Write-Output 'Downloading pre-requisite files ...'
    (New-Object System.Net.WebClient).DownloadFile("$SoftwareWebLink", "$SoftwarePath")
   

     Write-Output 'Installing ...'
    Start-Process "C:\SoftwaresDump\mysql-installer-community-5.7.16.0.msi" -ArgumentList '/q' -Wait 

    

    Write-Output 'Done!'
