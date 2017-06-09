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
    $SoftwarePath = "C:\SoftwaresDump\QTP12.5\Unified Functional Testing\EN\setup.exe"

    Write-Output 'Preparing temp directory ...'
    New-Item "C:\SoftwaresDump\QTP12.5\Unified Functional Testing\EN" -ItemType Directory -Force | Out-Null

   

Write-Output 'Installing UFT.....'

Start-Process "C:\SoftwaresDump\QTP12.5\Unified Functional Testing\EN\setup.exe" -ArgumentList '/s'  -Wait  

    Write-Output 'Done!'
}
finally
{
    popd
}
