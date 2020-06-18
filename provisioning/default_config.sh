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
#
# Please uncomment required module
#

export PROVISIONER_ENABLED_MODULES=(
    general
)


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
