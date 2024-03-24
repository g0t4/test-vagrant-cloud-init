## reimport trixie env starting point
wsl --unregister deb2
trash ~\backups\deb2
mkdir ~\backups\deb2
cp ~\backups\debian-trixie-backup-only.vhdx ~\backups\deb2\deb2.vhdx
wsl --import-in-place deb2 ~\backups\deb2\deb2.vhdx
# put in place 2 files on host (below) ~\.wslconfig ~\.cloud-init\deb2.user-data
wsl -d deb2 # it's up! next jump down to disable networking config and installing cloud-init package




## end to end install, configure, reboot and run intialize

# show comands dont work
jq
batcat
grc ip a s

# FILES:

# %USERPROFILE%/.wslconfig
[wsl2]
kernelCommandLine = ds=wsl
# must wsl --shutdown (wait 5 seconds before restart, confirm off wsls)...
# cat /proc/cmdline # confirm ds=wsl

# %USERPROFILE%/.cloud-init/deb2.user-data
#cloud-config
packages:
- bat
- grc
- jq





# cloud init generates (if network config enabled):
/etc/network
└── interfaces.d
    └── 50-cloud-init
# rm /etc/network/interfaces.d/50-cloud-init
# this causes a timeout with `sudo systemctl status networking.service` unit after 5 minutes and then after that cloud-init will run stages but that is annoying to wait and not needed... thus tell it to disable networking:

# tell cloud-init to disable networking (BEFORE reboot too):
echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
# FYI theoretically you can set this in kernel command line args too but I didn't get that to work so I am going with /etc/cloud/cloud.cfg.d/ instead

sudo apt install -y cloud-init
sudo cloud-init status --long # not started, good!
sudo systemctl status # --running


# reboot
exit
wsl --shutdown
wsls # confirm shutdown
wsl -d deb2 # bring back up






ls /etc/network/interfaces.d
# s/b empty!


# find in logs?
cat /var/log/cloud-init.log | grep 50-
 Writing to /etc/network/interfaces.d/50-cloud-init - wb: [644] 419 bytes

# PENDING did the above actually disable creating 50-cloud-init? did not from kernel command line arg unfortunately 


sudo systemctl status  # running?
sudo cloud-init status --long # done? degraded yes b/c ssh-keygen failure is fine


## they all work:
jq
grc ip a s
batcat 


## misc
cat /var/log/cloud-init-output.log
cat /var/log/cloud-init.log
ls /var/lib/cloud/...
ls /run/cloud/... # further spelunking

## PRN ssh
generate host keys fails b/c no ssh-keygen command... so install that package to avoid that issue!

