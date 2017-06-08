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
    $NewDIR = "C:\SoftwaresDump"
    $SoftwareWebLink = "https://www.visualstudio.com/thank-you-downloading-visual-studio/?sku=BuildTools&rel=15#/vs_buildtools__1231979381.1490945123"
    $SoftwarePath = "C:\SoftwaresDump\vs_buildtools__667437884.1496052054.exe"

    Write-Output 'Preparing temp directory ...'
    New-Item "C:\SoftwaresDump\vs_buildtools__667437884.1496052054.exe" -ItemType Directory -Force | Out-Null

    Write-Output 'Downloading pre-requisite files ...'
    (New-Object System.Net.WebClient).DownloadFile("$SoftwareWebLink", "$SoftwarePath")
   

 Write-Output 'Installing ...'
Start-Process "C:\SoftwaresDump\vs_buildtools__667437884.1496052054.exe" -ArgumentList '/s' -Wait    

    Write-Output 'Done!'



}
finally
{
    popd
}


