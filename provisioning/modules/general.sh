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
    SYSTEM_SWAP_FILE=${SYSTEM_SWAP_FILE:-/swap}
    SYSTEM_SWAP_SIZE=${SYSTEM_SWAP_SIZE:-}
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
    dnf install -y --nogpgcheck ${SYSTEM_PACKAGES[*]}


    # -----------------------------------------------------------
    # timezone
    # -----------------------------------------------------------

    _ups_log_info "setting timezone to: ${SYSTEM_TIMEZONE}"
    timedatectl set-timezone ${SYSTEM_TIMEZONE}
    timedatectl set-ntp true


    # -----------------------------------------------------------
    # swap
    # -----------------------------------------------------------
    if [[ ! -z "${SYSTEM_SWAP_SIZE}" && ! -z "${SYSTEM_SWAP_FILE}" ]]; then
        _ups_log_info "enabling swap file: ${SYSTEM_SWAP_FILE} size: ${SYSTEM_SWAP_SIZE}"
        if [[ ! -f "${SYSTEM_SWAP_FILE}" ]]; then
            _ups_log_info "creating swap file: ${SYSTEM_SWAP_FILE} size: ${SYSTEM_SWAP_SIZE}"
            dd if=/dev/zero of=${SYSTEM_SWAP_FILE} bs=1M count=5000
            chown root:root ${SYSTEM_SWAP_FILE}
            chmod 600 ${SYSTEM_SWAP_FILE}
            mkswap ${SYSTEM_SWAP_FILE}
            swapon ${SYSTEM_SWAP_FILE}
        fi
        if ! grep "${SYSTEM_SWAP_FILE}" /etc/fstab 2>&1 > /dev/null; then
            _ups_log_info "appending swap file to fstab..."
            echo "${SYSTEM_SWAP_FILE} swap                                                        swap    defaults        0 0" >> /etc/fstab
        fi
    fi

}


# -----------------------------------------------------------
# _ups_general_verify
# -----------------------------------------------------------

function _ups_general_verify() {
    :
}
