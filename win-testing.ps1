

winget install Microsoft.WindowsADK

#   find oscdimg:
#     open Deploy shell to find paths
powershell -Command "gcm oscdimg | fl"

# add to path:
$ENV:PATH += ";C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\AMD64\Oscdimg\"
# toggle cloud_init (virtualbox support)
$ENV:VAGRANT_EXPERIMENTAL="cloud_init,disks"
vagrant up
