#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: project setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_devproject_configure
# -----------------------------------------------------------

function _psh_devproject_configure() {
    SYSTEM_PACKAGES+=(
    )
}


# -----------------------------------------------------------
# _psh_devproject_validate
# -----------------------------------------------------------

function _psh_devproject_validate() {
    :
}


# -----------------------------------------------------------
# _psh_devproject_pre_install
# -----------------------------------------------------------

function _psh_devproject_pre_install() {
    :
}


# -----------------------------------------------------------
# _psh_devproject_setup
# -----------------------------------------------------------

function _psh_devproject_setup() {

    # -----------------------------------------------------------
    # step
    # -----------------------------------------------------------

    _psh_log_info "step taken"


    # -----------------------------------------------------------
    # invoking unprivilaged provisioner
    # -----------------------------------------------------------

    _psh_log_info "executing project setup with devuser: ${DEVUSER_NAME}"

    local module_root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
    su - ${DEVUSER_NAME} ${module_root}/devproject-unprivileged.sh

}


# -----------------------------------------------------------
# _psh_devproject_verify
# -----------------------------------------------------------

function _psh_devproject_verify() {
    :
}
