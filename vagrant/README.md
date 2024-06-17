# reproducible virtual environments with Vagrant

The Vagrant environment in this directory provides you with some basic VMs for several different Linux distributions. You can use them to try out commands and experiment with the CLI.

You can get an overview by running `vagrant status` from a terminal in this directory:

```console
> vagrant status
Current machine states:

el                        not created (virtualbox)
fedora                    not created (virtualbox)
debian                    not created (virtualbox)
ubuntu                    not created (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

To start a VM, use `vagrant up <name>` and then log in with `vagrant ssh <name>`.

The VMs are based on the [Bento project by Chef](https://github.com/chef/bento). They provide high quality Vagrant base boxes for all kinds of different operating systems.

You can easily add boxes by adding an entry to the file [vagrant-hosts.yml](vagrant-hosts.yml). For more info on how this works, check the Github repo [bertvv/vagrant-shell-skeleton](https://github.com/bertvv/vagrant-shell-skeleton) that is the basis for this environment.

For example, one existing entry looks like this:

```yaml
- name: el
  box: bento/almalinux-9
  ip: 192.168.56.11
```

It defines a VM named `el` (short for Enterprise Linux), running AlmaLinux 9, with the IP address 192.168.56.11. You can add more entries like this to the file to create more VMs. It's also possible to change the specifications of the existing VMs. The comments in the file explain the possible options. For example, to limit the memory assigned to a VM (2048MB is the default), you might want to add a line like this:

```yaml
- name: el
  box: bento/almalinux-9
  ip: 192.168.56.11
  memory: 1024
```

If you break something and the VM becomes unusable, you can always destroy it with `vagrant destroy <name>` and then recreate it with `vagrant up <name>`.

If you want to make persistent changes to a VM (that will be reproduced after destroying and recreating it), create a shell script in the directory `provisioning/<name>.sh` (with the name of the VM). As an example, two scripts are already provided for the `el` and `debian` boxes. For now, these scripts add a user named `student` with password `student` to the VMs, and ensure that his user can execute `sudo`. It also installs `bash-completion`. You can add more packages to install and add commands to customize the VMs to your liking. Just remember that scripts are executed with root privileges and that they should not be interactive. If your script requires user input, it will fail, so you should modify it to work without it.
