#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: provisioner configuration
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# module config
# -----------------------------------------------------------
#
# Please uncomment required module
#

export PROVISIONER_ENABLED_MODULES=(
    # ---------------------------
    # generic modules
    # ---------------------------
    general
    # repo_epel
    # repo_rpmfusion

    # ---------------------------
    # developer user and tools
    # ---------------------------
    devuser
    devtools
    # devproject

    # ---------------------------
    # file sharing modules
    # ---------------------------
    nfs
    # samba

    # ---------------------------
    # programming languages
    # ---------------------------
    python
    # golang
    nodejs

    # ---------------------------
    # databases
    # ---------------------------
    # mongodb    # broken
    # mongotron

    # ---------------------------
    # container support
    # ---------------------------
    # docker
    # lxc

    # ---------------------------
    # cloud support
    # ---------------------------
    # aws
    # gae
    # terraform

    # ---------------------------
    # kubernetes support
    # ---------------------------
    # kubernetes_client
    # kubernetes_minikube

    # ---------------------------
    # vpn support
    # ---------------------------
    # vpn_l2tp_client
    # vpn_tinc
)


# -----------------------------------------------------------
# time-zone configuration
# -----------------------------------------------------------
#
# Set the timezone for the VM
#

export SYSTEM_TIMEZONE=UTC
# export SYSTEM_TIMEZONE=Australia/Sydney


# -----------------------------------------------------------
# system packages config
# -----------------------------------------------------------
#
# Define extra packages here, these will be installed using
# dnf / apt, based on which platform is used.
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

export NODEJS_NVM_VERSION=0.35.3
export NODEJS_VERSION=--lts
export NODEJS_PACKAGES=(
#     @vue/cli
)

# -----------------------------------------------------------
# VPN config
# -----------------------------------------------------------

export VPN_L2TP_NAME="my_vpn"
export VPN_L2TP_HOST="my-vpn-hostname"
export VPN_L2TP_PSK="mypskkey"
export VPN_L2TP_USER="myusername"
export VPN_L2TP_IPSEC_IKE=3des-sha1-modp2048
export VPN_L2TP_IPSEC_ESP=3des-sha1
export VPN_L2TP_IPSEC_PFS=no

