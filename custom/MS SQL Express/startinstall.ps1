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
   # Create temp directory
New-Item "C:\softwaredump" -ItemType Directory -ErrorAction SilentlyContinue

# Download
(New-Object System.Net.WebClient).DownloadFile("http://download.microsoft.com/download/B/F/2/BF2EDBB8-004D-47F3-AA2B-FEA897591599/SQLServer2016-SSEI-Expr.exe", "C:\softwaredump\SQLServer2016-SSEI-Expr.exe")
(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/yashg7cr/newartifacts/master/ConfigurationFile.ini", "C:\softwaredump\ConfigurationFile.ini")

Write-Output 'Installing ...'

Start-Process -FilePath "C:\softwaredump\SQLServer2016-SSEI-Expr.exe" -ArgumentList '/ConfigurationFile="C:\softwaredump\ConfigurationFile.ini"', '/MediaPath="c:\softwaredump"', '/IAcceptSqlServerLicenseTerms', '/ENU', '/QS'  -Wait
    

   Write-Output 'Done!'
}
finally
{
    popd
}
