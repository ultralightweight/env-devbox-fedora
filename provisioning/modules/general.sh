#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: general setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_general_configure
# -----------------------------------------------------------

function _psh_general_configure() {
    SYSTEM_PACKAGES+=(
        curl
        wget
        htop
        net-tools
        dnf-plugins-core
        mc
        telnet
        # ntp
    )
    SYSTEM_HELPER_SCRIPTS=(
        timesync
    )
    SYSTEM_BIN_DIR=/usr/local/bin
    SYSTEM_SWAP_SUBVOLUME=${SYSTEM_SWAP_SUBVOLUME:-/swap}
    SYSTEM_SWAP_FILE=${SYSTEM_SWAP_FILE:-${SYSTEM_SWAP_SUBVOLUME}/swapfile0}
    SYSTEM_SWAP_SIZE=${SYSTEM_SWAP_SIZE:-}
}


# -----------------------------------------------------------
# _psh_general_validate
# -----------------------------------------------------------

function _psh_general_validate() {
    _psh_log_info "SYSTEM_PACKAGES='${SYSTEM_PACKAGES}'"
    _psh_log_info "SYSTEM_HELPER_SCRIPTS='${SYSTEM_HELPER_SCRIPTS}'"
    _psh_log_info "SYSTEM_BIN_DIR='${SYSTEM_BIN_DIR}'"
    _psh_log_info "SYSTEM_SWAP_SUBVOLUME='${SYSTEM_SWAP_SUBVOLUME}'"
    _psh_log_info "SYSTEM_SWAP_FILE='${SYSTEM_SWAP_FILE}'"
    _psh_log_info "SYSTEM_SWAP_SIZE='${SYSTEM_SWAP_SIZE}'"
}


# -----------------------------------------------------------
# _psh_general_pre_install
# -----------------------------------------------------------

function _psh_general_pre_install() {
    :
}


# -----------------------------------------------------------
# _psh_general_setup
# -----------------------------------------------------------

function _psh_general_setup() {

    # -----------------------------------------------------------
    # install packages
    # -----------------------------------------------------------

    _psh_log_info "installing system packages..."
    _psh_log_debug "SYSTEM_PACKAGES: ${SYSTEM_PACKAGES[*]}"
    dnf install -y --nogpgcheck ${SYSTEM_PACKAGES[*]}


    # -----------------------------------------------------------
    # timezone
    # -----------------------------------------------------------

    _psh_log_info "setting timezone to: ${SYSTEM_TIMEZONE}"
    timedatectl set-timezone ${SYSTEM_TIMEZONE}
    timedatectl set-ntp true

    # _psh_log_info "enabling and starting ntpd service..."
    # systemctl enable ntpd
    # systemctl start ntpd

    _psh_log_info "enabling and starting timesyncd service..."
    systemctl enable systemd-timesyncd
    systemctl start systemd-timesyncd


    # # -----------------------------------------------------------
    # # swap
    # # -----------------------------------------------------------
    # if [[ ! -z "${SYSTEM_SWAP_SIZE}" && ! -z "${SYSTEM_SWAP_FILE}" ]]; then
    #     _psh_log_info "configuring swap file: ${SYSTEM_SWAP_FILE} size: ${SYSTEM_SWAP_SIZE}"
    #     if [[ ! -f "${SYSTEM_SWAP_FILE}" ]]; then
    #         _psh_log_info "creating swap file: ${SYSTEM_SWAP_FILE} size: ${SYSTEM_SWAP_SIZE}"
    #         dd if=/dev/zero of=${SYSTEM_SWAP_FILE} bs=1M count=5000
    #         chown root:root ${SYSTEM_SWAP_FILE}
    #         chmod 600 ${SYSTEM_SWAP_FILE}
    #         mkswap ${SYSTEM_SWAP_FILE}
    #         swapon ${SYSTEM_SWAP_FILE}
    #     fi
    #     if ! grep "${SYSTEM_SWAP_FILE}" /etc/fstab 2>&1 > /dev/null; then
    #         _psh_log_info "appending swap file to fstab..."
    #         echo "${SYSTEM_SWAP_FILE} swap                                                        swap    defaults        0 0" >> /etc/fstab
    #     fi
    # fi

    # -----------------------------------------------------------
    # swap
    # -----------------------------------------------------------
    # origin: https://gist.github.com/eloylp/b0d64d3c947dbfb23d13864e0c051c67
    # -----------------------------------------------------------
    if [[ ! -z "${SYSTEM_SWAP_SIZE}" && ! -z "${SYSTEM_SWAP_FILE}" ]]; then
        _psh_log_info "configuring swap file: ${SYSTEM_SWAP_FILE} size: ${SYSTEM_SWAP_SIZE}"
        if [[ ! -f "${SYSTEM_SWAP_FILE}" ]]; then
            _psh_log_info "creating swap subvolume: ${SYSTEM_SWAP_SUBVOLUME}..."
            btrfs subvolume create /swap
            _psh_log_info "creating swap file: ${SYSTEM_SWAP_FILE} size: ${SYSTEM_SWAP_SIZE}..."
            touch ${SYSTEM_SWAP_FILE}
            chattr +C ${SYSTEM_SWAP_FILE}  ## Needed to disable Copy On Write on the file.
            dd if=/dev/zero of=${SYSTEM_SWAP_FILE} bs=1M count=5000
            _psh_log_info "configuring swap file: ${SYSTEM_SWAP_FILE}..."
            chown root:root ${SYSTEM_SWAP_FILE}
            chmod 600 ${SYSTEM_SWAP_FILE}
            mkswap ${SYSTEM_SWAP_FILE}
            swapon ${SYSTEM_SWAP_FILE}
            _psh_log_info "swap file: ${SYSTEM_SWAP_FILE} configured"
            free -h
        fi
        if ! grep "${SYSTEM_SWAP_FILE}" /etc/fstab 2>&1 > /dev/null; then
            _psh_log_info "appending swap file to fstab..."
            echo "${SYSTEM_SWAP_FILE} swap                                                        swap    defaults        0 0" >> /etc/fstab
        fi
    fi

    # -----------------------------------------------------------
    # generic helper scripts
    # -----------------------------------------------------------

    local SYSTEM_HELPER_SCRIPT=
    for SYSTEM_HELPER_SCRIPT in ${SYSTEM_HELPER_SCRIPTS[@]}; do
        local SOURCE=${PROVISIONER_ASSETS}/${SYSTEM_HELPER_SCRIPT}
        local TARGET=${SYSTEM_BIN_DIR}/${SYSTEM_HELPER_SCRIPT}
        if ! type ${SYSTEM_HELPER_SCRIPT} >/dev/null 2>&1; then
            _psh_log_info "installing ${SYSTEM_HELPER_SCRIPT} from: ${SOURCE} to: ${TARGET}"
            cp -vf ${SOURCE} ${TARGET}
            chmod +x ${TARGET}
        fi
    done

}


# -----------------------------------------------------------
# _psh_general_verify
# -----------------------------------------------------------

function _psh_general_verify() {
    :
}
