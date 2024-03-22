

# FYI
# winget install Microsoft.WindowsADK # for oscdimg

# usage:
#   . .\env.ps1
#   ls env: # confirm env vars

$ENV:PATH += ";C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\AMD64\Oscdimg\"

$ENV:VAGRANT_EXPERIMENTAL = "cloud_init,disks"

# vagrant up

