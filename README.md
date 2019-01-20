
# Fedora Devbox

This repository contains a fedora based development environment.

The source is licenced under GPL3.

# Prerequisities

## Vagrant

Download and install vagrant from [https://www.vagrantup.com](https://www.vagrantup.com/downloads.html). 

## SSH Keys (optional)

If you want to use git it is recommended that you copy or create a set of RSA keys.

- You can either copy your usual ssh keys under `/keys`, or generate a set of new keys. 

## NFS Client on the host

### OSX Host

OSX support NFS out of the box. 

1. Press CMD+k in Finder.
1. Provide your host's private IP address, for example `nfs://<192.168.33.33>`

### Linux

- Fedore documentation is here: [https://docs.fedoraproject.org/en-US/Fedora/14/html/Storage_Administration_Guide/s1-nfs-client-config.html](https://docs.fedoraproject.org/en-US/Fedora/14/html/Storage_Administration_Guide/s1-nfs-client-config.html)

- Fedora guide is here: [https://fedoraproject.org/wiki/Administration_Guide_Draft/NFS#NFS_Clients](https://fedoraproject.org/wiki/Administration_Guide_Draft/NFS#NFS_Clients)

- Ubuntu guide is here: [https://help.ubuntu.com/lts/serverguide/network-file-system.html.en](https://help.ubuntu.com/lts/serverguide/network-file-system.html.en)

### Windows

Windows supports NFS. It needs to be enabled. Follow the guide here:

[Windows `mount` command](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc754046(v=ws.11))


# Setup

## 1. Clone this repository

## 1. Personalizing the VM configuration (mandatory)

```
# -----------------------------------------------------------
# dev user config
# -----------------------------------------------------------

export DEVUSER_NAME="dev"
export DEVUSER_EMAIL="my.email@gmail.com"
export DEVUSER_FULLNAME="My Full Name"
export DEVUSER_PASSWORD="vagrant"
export DEVUSER_GID=20       # MAKE SURE THIS MATCHES WITH YOUR HOST USERS GID
export DEVUSER_UID=501      # MAKE SURE THIS MATCHES WITH YOUR HOST USERS UID
```

    NOTE: Make sure `DEVUSER_GID` and `DEVUSER_UID` is matching with your group and user id on the host system. This required when you edit files via NFS, it will be created with the VM's dev user's credentials.
    You can check your GID and UID using the `id` command on *nix and osx.

    NOTE 2: When you use the devbox with a linux host, there is a chance that your `UID` is `1000` (default for many linux systems). That will collide with the VM's existing `vagrant` user. In this case, please set `DEVUSER_NAME` user name to `vagrant`. This will prevent a new user to be created.

## 1. Personalizing the VM configuration (optional)

### Modules
    
Enable/disable modules by uncommenting/commenting lines in `PROVISIONER_ENABLED_MODULES`

Module name | Description
-|-
general | A couple basic packages, like telnet, wget, and timezone settings
repo_epel | Install and enable [EPEL](https://fedoraproject.org/wiki/EPEL) repository
repo_rpmfusion | Install and enable [rpm fusion](https://rpmfusion.org/) repository
nfs | Create an Network Filesystem share to allow remote filesystem access 
devtools | Basic devtools, like git, gcc, make 
devuser | Create and configure `DEVUSER`
python | Install `python2` and `python3` and all packages defined in `PYTHON_PACKAGES`. 
nodejs | Install `nvm`, `nodejs` and `npm`.
docker | Install `docker`
aws | Install Amazon Web Services command line tool and configure access keys
gae | Install Google App Engine environment and Google Cloud command line tool `gcloud`, kubernetes command line tool `kubectl`
devproject | Clone and run custom command for a git repository.


### Custom packages

Install additional RPM packages by adding them to the `SYSTEM_PACKAGES` array.

### Timezone

Set the `SYSTEM_TIMEZONE` to the desired timezone. Defaults to UTC.


## 1. Start and provision the VM

From shell issue `vagrant up` to bring up the VM.


### Errors during startup

It might complain about IP addresses and network interfaces. Please check the following lines in the Vagrantfile:

```
config.vm.network "private_network", ip: "192.168.33.33"
config.vm.network "public_network", bridge: 'en4: Thunderbolt Ethernet'
```

### Provisioning process

The `vagrant up` command will:

1. Create a brand new fedora based on the minimalistic fedora 28 cloud base image. It will download about 300MB in the first run.

2. Provision the virtual machine, installing and configuring all required packages. It will download another 300MB. It will do this every time you re-create the VM.

### Re-run the provisioner

In case something fails, you can always do:

`vagrant reload --provision` to re-run the whole vm setup.

You can also run parts of the process:

# Usage

## SSH Access

1. Use vagrant's default `vagrant ssh`. This will connect using the `vagrant` user.

1. Use the `make ssh` command to use the `dev` user to connect.

1. Use `make portforwards` to connect and create portforwards for default common ports used for development
    - `80` 
    - `8000` 
    - `8081` 
    - `4200`


## Mounting the root filesystem

Use your platforms way of connecting to the NFS share provided by the VM. Please check the NFS section of the prerequisities.





