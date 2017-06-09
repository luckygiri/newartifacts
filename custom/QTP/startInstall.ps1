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
    $SoftwareWebLink = "http://h30537.www3.hpe.com/prdownloads/UFT1400_DVD.zip?downloadid=Wu6ezJnM633sYkwgWfU8lTaFcDNYpqzL9L3-Kq6nB4E0VkoTjOvG7q9bBg6L-q3_NJS0cpG0ySDOo8VWqTIagwwgzAJcYe8oZXk32s_GIzgV7S3UChkKlZsFQfNOd1IO&merchantId=PRONQ_TRY&dlm=ON&rnid=1.0&bpid=SGBU&egid=F&__dlk__=1497078000_10c3639cd725bd45717f50557c1c45d8"
    $SoftwarePath = "C:\SoftwaresDump\QTP12.5\UFT1400_DVD.zip"
    
    #Extracting
$shell = New-Object -ComObject shell.application
$zip = $shell.NameSpace("$SOftwarePath")
foreach ($item in $zip.items()) {
  $shell.Namespace("$NewDIR").CopyHere($item)
}


    Write-Output 'Preparing temp directory ...'
    New-Item "C:\SoftwaresDump\QTP12.5" -ItemType Directory -Force | Out-Null

    Write-Output 'Downloading pre-requisite files ...'
(New-Object System.Net.WebClient).DownloadFile("$SoftwareWebLink", "$SoftwarePath")





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
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\pdm\ScriptDebugging_x64.msi" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\pdm\ScriptDebugging_x86.msi" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\vc2015_redist_x64\vcredist_x64.exe" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\vc2015_redist_x86\VC2015Prerequisite.exe" -ArgumentList '/q' -Wait
Start-Process "C:\SoftwaresDump\QTP12.5\prerequisites\vc2015_redist_x86\vcredist_x86.exe" -ArgumentList '/q' -Wait






Write-Output 'Installing UFT.....'

Start-Process "C:\SoftwaresDump\QTP12.5\Unified Functional Testing\EN\setup.exe" -ArgumentList '/q' -Wait  
 


    

    Write-Output 'Done!'
}
finally
{
    popd
}
