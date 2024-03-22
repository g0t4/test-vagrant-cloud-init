### *** ubuntu/noble64 testing w/ cloud-init

# vagrant up => at very end, reported:
#   cloud-init status --wait' failed on guest 'default'
# ssh in =>
cloud-init status # done
echo $? # 2 (recoverable error, cloud-init completed with errors)
# - https://cloudinit.readthedocs.io/en/latest/explanation/return_codes.html
# - https://cloudinit.readthedocs.io/en/latest/explanation/failure_states.html#error-codes
# promising enen though it failed!
# - detailed stage level errors
cloud-init status --format json
cat /var/lib/cloud/data/status.json # similar to status --format json
# FYI instance-id and previous-instance-id are the SAME (indicates first time cloud init has run)
# /var/lib/cloud/instance/scripts/part-002 # present (my script)
#  copy out files: (on  host, pwsh)
#   vagrant ssh-config > sshconfig
#   scp -F .\sshconfig default:/var/lib/cloud/instances/i-449867c3b8b243bc842d080e62ca7c73/user-data.txt  .

cloud-init status --long # => has!   detail: DataSourceNoCloud [seed=/dev/sr0][dsmode=net]
#   that is the user-data ISO from vagrant!
#   one issue => add-user.yaml has extra yaml docs (empty with comments)
#      recoverable errors ()
#  hooray my script part worked!!! =>
#     cat /tmp/cloud-init-output.txt
#     hello cloud-init world
# let's recreate things and fix the add-user.yaml
#    YUP fixed!

# **** boot 2 noble64 (Hung IIGC b/c i added new user w/o pass or ssh keys?)... maybe it hung like a prompt to input them! no idea but when i  commented that out in vagrantfile to not include add-user.yaml then it booted just fine

# *** boot 3 - no add-user.yaml and it all worked, thus my script worked too
cloud-init status  # => done, RC=0
# FYI don't forget to check this spot now that my parts are running
sudo cat /var/log/cloud-init-output.log

# *** boot 4 - add-user back w/ import ssh keys
cat /etc/passwd | grep foo # w00h00 there she is
sudo cat /home/foobar/.ssh/authorized_keys  # yaya had both keys

# *** boot 5 - drop import and see if still hanging or if that was fluke






### *** BELOW IS FOR bento/ubuntu-2304 that I tested
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

# /var/lib/cloud
#  instance => instances/iid-datasource-none
#  scripts => none, just empty dirs for: vendor, per-boot, per-instance, per-once
#  data
#    instance-id => iid-datasource-none
#    previous-instance-id => NO_PREVIOUS_INSTANCE_ID
#    previous-datasource => DataSourceNone: DataSourceNone
#    result.json => 
#      {
#      "v1": {
#        "datasource": "DataSourceNone",
#        "errors": []
#      }
#      }
#    status => TLDR v1 => no errors anywhere, start/stop times for init, init-local, modules-config, modules-final
#                           BUT no start/stop for modules-init
#                           stage null (not set)
#  cat sem/config_scripts_per_once.once => 1564: 1682478562.7571
#  instances => iid-datasource-none  (rest of files in here)
#      sudo cat cloud-config.txt => partially matches https://github.com/chef/bento/blob/main/packer_templates/http/ubuntu/user-data#L7 ... which is bento's user-data... also a mix of disabling cloud-init by writing the file... /etc/cloud/cloud-init.disabled
#         no vendor-data to speak of so just gonna be auto install first run from bento packer template


