#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: provisioner default configuration
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# module config
# -----------------------------------------------------------

export PROVISIONER_ENABLED_MODULES=(
    general
)


# -----------------------------------------------------------
# host name configuration
# -----------------------------------------------------------
#
# Set the timezone for the VM
#

export SYSTEM_HOSTNAME="devbox"


# -----------------------------------------------------------
# system architecture configuration
# -----------------------------------------------------------
#
# Set the architecture for the VM
#

export SYSTEM_ARCHITECTURE=$(uname -m)

case ${SYSTEM_ARCHITECTURE} in 
    aarch64)
        SYSTEM_ARCHITECTURE_ALT=arm64
        ;;
    x86_64)
        SYSTEM_ARCHITECTURE_ALT=amd64
        ;;
    *)
        SYSTEM_ARCHITECTURE_ALT=$(uname -m)
        ;;
esac

export SYSTEM_ARCHITECTURE_ALT


# -----------------------------------------------------------
# time-zone configuration
# -----------------------------------------------------------
#
# Set the timezone for the VM
#

export SYSTEM_TIMEZONE=UTC

# -----------------------------------------------------------
# system packages config
# -----------------------------------------------------------
#
# Define extra packages here, these will be installed using
# dnf / apt, based on which platform is used.
#

export SYSTEM_PACKAGES=(
)

