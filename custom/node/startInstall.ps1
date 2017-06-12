# Create temp directory
New-Item "C:\SoftwaresDump\QTP12.5" -ItemType Directory -ErrorAction SilentlyContinue

# Download
(New-Object System.Net.WebClient).DownloadFile("http://artifacts.mphasism4l.cloud/softwares/node-v6.9.2-x64.msi", "C:\SoftwaresDump\QTP12.5\node-v6.9.2-x64.msi")



# Install


Start-Process "C:\SoftwaresDump\QTP12.5\node-v6.9.2-x64.msi" /qn -Wait
