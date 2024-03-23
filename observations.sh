### *** misc

```bash

sudo systemctl list-dependencies  | grep cloud
●   ├─cloud-init.target
●   │ ├─cloud-config.service
●   │ ├─cloud-final.service
●   │ ├─cloud-init-hotplugd.socket
●   │ ├─cloud-init-local.service
●   │ └─cloud-init.service

sudo systemctl status cloud-*

sudo systemctl cat cloud* | grep ExecStart
ExecStart=/usr/bin/cloud-init init --local
ExecStart=/usr/bin/cloud-init modules --mode=final
ExecStart=/usr/bin/cloud-init modules --mode=config
ExecStart=/usr/bin/cloud-init init
...

```

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
#  worked fine so must've been a fluke on previous boot hanging twice?!

# also useful: detailed steps:
sudo batcat /var/log/cloud-init.log
# boot X => cloudy hostname and packages worked!

# *** rebooted w/ changed add-user.yaml
#  vagrant gave hints that it was running cloud-inits again (IIGC b/c always stuff needs to run agin)
#  sudo cat /var/lib/cloud/instances/i-2048c7f60c2847edbcb450ba9cf152f5/user-data.txt
#    - user-data was updated!
#    - but as would be logical, it does not appear my parts were run (gecos change not in /etc/passwd)...
#       IIAC I need to run that part or set it to always before it would
#       sudo cat /var/log/cloud-init-output.log  | grep HELLO 
#         AND yup my HELLO WORLD is only in output once (unless perhaps the output is cleared on each reboot?) 
#            and double checked, yup my modified script change HELLOWORLDFOOBP2 didn't show up
# *** force re-run script
#   reboot has script changes in part-004 (good deal)
# now force re-run: (module (name) == scripts-user)
sudo cloud-init single --name scripts-user --frequency always  # w00h00
#     # w00h00 I get the HELLO WORLD OUTPUT
sudo cloud-init single --name scripts-user
#     no HELLO WORLD b/c it is already run and not providing frequency here
# modules:
#   scripts-user https://cloudinit.readthedocs.io/en/latest/reference/modules.html#scripts-user
#   various config content is mapped to modules, modules are the part that do the work...
#      i.e. if I have "hostname: foo" in my cloud-conf... the "set_hostname" modules does the work
#             set_hostname: https://cloudinit.readthedocs.io/en/latest/reference/modules.html#set-hostname
#         so
#         sudo hostname changed
#         #logout/in to see prompt change
#         sudo cloud-init single --name set_hostname  --frequency always
#         #logout/in and its BACK!
#   see modules listing: https://cloudinit.readthedocs.io/en/latest/reference/modules.html
#
# *** users-and-groups
#    https://cloudinit.readthedocs.io/en/latest/reference/modules.html#users-and-groups
#    FYI - and _ are interchangeable in module name passing




#  *** misc
sudo cloud-init query -l # list
sudo cloud-init query userdata



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


