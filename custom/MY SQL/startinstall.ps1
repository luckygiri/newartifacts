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
    $SoftwareWebLink = "http://dl1.filehippo.com/b273a1b9e976427c834340ccdd2fa269/mysql-5.6.36-win32.msi?ttl=1496934475&token=b55ab79135371d569b4cf43c80688e19"
    $SoftwarePath = "C:\SoftwaresDump\mysql-5.6.36-win32.msi"

    Write-Output 'Preparing temp directory ...'
    New-Item "C:\SoftwaresDump" -ItemType Directory -Force | Out-Null

    Write-Output 'Downloading pre-requisite files ...'
    (New-Object System.Net.WebClient).DownloadFile("$SoftwareWebLink", "$SoftwarePath")
   

 Write-Output 'Installing ...'
Start-Process "C:\SoftwaresDump\mysql-5.6.36-win32.msi" -ArgumentList '/q' -Wait 

    

    Write-Output 'Done!'
}
finally
{
    popd
}


