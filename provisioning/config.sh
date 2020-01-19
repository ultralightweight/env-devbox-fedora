#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: provisioner configuration
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# provisioner config
# -----------------------------------------------------------

#
# Enabled modules 
#
export PROVISIONER_ENABLED_MODULES=(
    general
    # repo_epel
    repo_rpmfusion
    nfs
    devtools
    devuser
    # samba
    python
    nodejs
    docker
    aws
    gae
    # devproject
)


# -----------------------------------------------------------
# system level config
# -----------------------------------------------------------

#
# Set the timezone for the VM
#
# export SYSTEM_TIMEZONE=Australia/Sydney
export SYSTEM_TIMEZONE=UTC


#
# Define extra packages here
#
export SYSTEM_PACKAGES=(
)


# -----------------------------------------------------------
# dev user config
# -----------------------------------------------------------

export DEVUSER_NAME="dev"
export DEVUSER_EMAIL=""
export DEVUSER_FULLNAME=""
export DEVUSER_PASSWORD="vagrant"
export DEVUSER_GID=20
export DEVUSER_UID=501


# -----------------------------------------------------------
# aws config
# -----------------------------------------------------------

export AWS_CONFIG_REGION=
export AWS_CONFIG_DEFAULT_FORMAT=json

export AWS_CREDENTIALS_ACCESS_KEY_ID=
export AWS_CREDENTIALS_SECRED_ACCESS_KEY=

# -----------------------------------------------------------
# python config
# -----------------------------------------------------------

export PYTHON_PACKAGES=(
)


# -----------------------------------------------------------
# nodejs config
# -----------------------------------------------------------

export NODEJS_NVM_VERSION=0.33.11
export NODEJS_VERSION=--lts


# -----------------------------------------------------------
# VPN config
# -----------------------------------------------------------

export VPN_L2TP_NAME="my_vpn"
export VPN_L2TP_HOST="my-vpn-hostname"
export VPN_L2TP_PSK="mypskkey"
export VPN_L2TP_USER="myusername"
export VPN_L2TP_IPSEC_IKE=3des-sha1-modp1024
export VPN_L2TP_IPSEC_ESP=3des-sha1
export VPN_L2TP_IPSEC_PFS=no

