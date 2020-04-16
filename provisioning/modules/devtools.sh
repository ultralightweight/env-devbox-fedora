#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: developer tools and environment
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_devtools_configure
# -----------------------------------------------------------

function _ups_devtools_configure() {
    SYSTEM_PACKAGES+=(
        git
        tig
        gcc
        make
        psmisc
        htop
        lsof
        strace
        jq
    )
}


# -----------------------------------------------------------
# _ups_devtools_validate
# -----------------------------------------------------------

function _ups_devtools_validate() {
    :
}


# -----------------------------------------------------------
# _ups_devtools_pre_install
# -----------------------------------------------------------

function _ups_devtools_pre_install() {
    :
}


# -----------------------------------------------------------
# _ups_devtools_setup
# -----------------------------------------------------------

function _ups_devtools_setup() {

    # -----------------------------------------------------------
    # step
    # -----------------------------------------------------------

    # _ups_log_info "step taken"
    :

}


# -----------------------------------------------------------
# _ups_devtools_verify
# -----------------------------------------------------------

function _ups_devtools_verify() {
    :
}
