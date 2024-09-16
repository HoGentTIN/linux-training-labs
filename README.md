# Linux training labs

This repository contains lab environments to accompany the [Linux training](https://github.com/HoGentTIN/linux-training-hogent) study material.

## Prerequisites

In order to use these lab environments, you need to have a working installation of the following software on your physical system:

- [Git](https://www.git-scm.com/), a revision control system
- [VirtualBox](https://www.virtualbox.org/), a desktop virtualization tool
- [Vagrant](https://www.vagrantup.com/), a command line tool for managing reproducible virtual machine environments

If you run a recent version Windows, install these from an Administrator command prompt:

```shell
> winget install Git.Git
> winget install Oracle.VirtualBox
> winget install HashiCorp.Vagrant
```

Otherwise, download and install the applications from their respective home pages.

On Linux, use your package manager to install these tools.

## Usage

To work on these lab assignments, it is not recommended to clone this repository directly. Instead, either create a fork under your own account, or download the code as a .zip file (and initialize a Git repository in the unpacked directory). That way, you can commit your own changes and lab notes and keep them in your own repository.

You can launch lab environments from each subdirectory that has a `Vagrantfile` by running:

```shell
$ vagrant up
```

The exercise assignment should be in the `README.md` file in the same directory, or in the relevant book chapter of the Linux training course material.

The lab environments are based on [bertvv/vagrant-shell-skeleton](https://github.com/bertvv/vagrant-shell-skeleton) that contains some scaffolding code to get you started with Vagrant without having to learn Ruby or how to write Vagrantfiles.

## Contents

Labs are shown in alphabetical order, but the [vagrant/](vagrant/) directory is the best place to start.

- [dns-bind](dns-bind/): the BIND DNS server
    - <https://hogenttin.github.io/linux-training-hogent/opslinux/dns-bind/>
- [troubleshooting/](troubleshooting/): troubleshooting network services.
    - <https://hogenttin.github.io/linux-training-hogent/opslinux/troubleshooting/>
- [vagrant/](vagrant/): reproducible virtual environments with Vagrant. **Ideal to get started!**
    - <https://hogenttin.github.io/linux-training-hogent/opslinux/vagrant/>
