# Linux training labs

This repository contains lab environments to accompany the [Linux training](https://github.com/HoGentTIN/linux-training-hogent) study material.

## Getting started

In order to use these labs, you need to have a working installation:

- [Git](https://www.git-scm.com/), a revision control system
- [VirtualBox](https://www.virtualbox.org/), a desktop virtualization tool
- [Vagrant](https://www.vagrantup.com/), a command line tool for managing reproducible virtual machine environments

If your physical system is a recent version Windows, install these from an Administrator command prompt:

```shell
> winget install Git.Git
> winget install Oracle.VirtualBox
> winget install HashiCorp.Vagrant
```

On Linux, use your package manager to install these tools.

## Usage

To work on these lab assignments, it is not recommended to clone this repository directly. Instead, either create a fork under your own account, or download the code as a .zip file (and initialize a Git repository in the unpacked directory).

You can launch lab environments from each subdirectory that has a `Vagrantfile` by running:

```shell
$ vagrant up
```

The exercise assignment should be in the `README.md` file in the same directory, or in the relevant book chapter of the Linux training course material.

The lab environments are based on [bertvv/vagrant-shell-skeleton](https://github.com/bertvv/vagrant-shell-skeleton) that contains some scaffolding code to get you started with Vagrant without having to learn Ruby or how to write Vagrantfiles.
