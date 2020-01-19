#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: general setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_general_configure
# -----------------------------------------------------------

function _ups_general_configure() {
    SYSTEM_PACKAGES+=(
        curl
        wget
        htop
        net-tools
        dnf-plugins-core
        mc
        telnet
    )
    SYSTEM_BIN_DIR=/usr/local/bin
}


# -----------------------------------------------------------
# _ups_general_validate
# -----------------------------------------------------------

function _ups_general_validate() {
    :
}


# -----------------------------------------------------------
# _ups_general_pre_install
# -----------------------------------------------------------

function _ups_general_pre_install() {
    :
}


# -----------------------------------------------------------
# _ups_general_setup
# -----------------------------------------------------------

function _ups_general_setup() {

    # -----------------------------------------------------------
    # install packages
    # -----------------------------------------------------------

    _ups_log_info "installing system packages..."
    _ups_log_debug "SYSTEM_PACKAGES: ${SYSTEM_PACKAGES[*]}"
    dnf install -y ${SYSTEM_PACKAGES[*]}


    # -----------------------------------------------------------
    # timezone
    # -----------------------------------------------------------

    _ups_log_info "setting timezone to: ${SYSTEM_TIMEZONE}"
    timedatectl set-timezone ${SYSTEM_TIMEZONE}
    timedatectl set-ntp true

}


# -----------------------------------------------------------
# _ups_general_verify
# -----------------------------------------------------------

function _ups_general_verify() {
    :
}
