
# - vagrant up waits for cloud init to complete: must accept "disabled" status?

# - I don't think it ran cloud-init parts b/c it is disabled by what looks to be the original ubuntu installer when bento make box
#   my script file is not there: yup /tmp/cloud-init-output.txt # does not exist, NOR does foobar user in add-user.yaml



# user-data ISO
# - vbox => storage => iso (54KB w/o IIAC cloud init file)
lsblk # =>   sr0 "rom" type for that ISO
sudo mkdir /mnt/testsr0
sudo mount /dev/sr0 /mnt/testsr0/
ls # yup, meta-data and user-data
#   user-data had all of my parts! (multi part)
mkdir /vagrant/sr0
cp * /vagrant/sr0
# *** TLDR vagrant does properly setup user-data, just need to change the VM to clean/re-run cloud init or otherwise to trigger it all in one go... or manually hook stuff up from vagrant except that I want to just see how it all integrates in vagrant (obviously I can run cloud-init manually too)



# status
$ cloud-init status --long
status: disabled
boot_status_code: disabled-by-marker-file
detail:
Cloud-init disabled by /etc/cloud/cloud-init.disabled

$ cat /etc/cloud/cloud-init.disabled
Disabled by Ubuntu live installer after first boot.
To re-enable cloud-init on this image run:
  sudo cloud-init clean --machine-id



