# practice: raid

Practice setup for Linux Software RAID, as described in <https://hogenttin.github.io/linux-training-hogent/opslinux/storage_raid/#practice-raid>.

Currently, there is one VM named `raidsrv` with three extra empty and unpartitioned 5GB disks attached. See the [vagrant-hosts.yml](vagrant-hosts.yml) file for the VM configuration. Edit the file to add more disks if you want to experiment with larger RAID arrays.

Run `vagrant up raidsrv` to start and set up the VM. After installation, log in with `vagrant ssh raidsrv`. The disks are `/dev/sdb`, `/dev/sdc` and `/dev/sdd`. The tool `mdadm` is already installed on the VM.
