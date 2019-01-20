#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: project setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_devproject_configure
# -----------------------------------------------------------

function _ups_devproject_configure() {
    SYSTEM_PACKAGES+=(
    )
}


# -----------------------------------------------------------
# _ups_devproject_validate
# -----------------------------------------------------------

function _ups_devproject_validate() {
    :
}


# -----------------------------------------------------------
# _ups_devproject_pre_install
# -----------------------------------------------------------

function _ups_devproject_pre_install() {
    :
}


# -----------------------------------------------------------
# _ups_devproject_setup
# -----------------------------------------------------------

function _ups_devproject_setup() {

    # -----------------------------------------------------------
    # step
    # -----------------------------------------------------------

    _ups_log_info "step taken"


    # -----------------------------------------------------------
    # invoking unprivilaged provisioner
    # -----------------------------------------------------------

    _ups_log_info "executing project setup with devuser: ${DEVUSER_NAME}"

    local module_root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
    su - ${DEVUSER_NAME} ${module_root}/devproject-unprivileged.sh

}


# -----------------------------------------------------------
# _ups_devproject_verify
# -----------------------------------------------------------

function _ups_devproject_verify() {
    :
}
