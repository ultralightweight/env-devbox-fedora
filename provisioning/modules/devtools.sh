#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: developer tools and environment
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_devtools_configure
# -----------------------------------------------------------

function _psh_devtools_configure() {
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
# _psh_devtools_validate
# -----------------------------------------------------------

function _psh_devtools_validate() {
    :
}


# -----------------------------------------------------------
# _psh_devtools_pre_install
# -----------------------------------------------------------

function _psh_devtools_pre_install() {
    :
}


# -----------------------------------------------------------
# _psh_devtools_setup
# -----------------------------------------------------------

function _psh_devtools_setup() {

    # -----------------------------------------------------------
    # step
    # -----------------------------------------------------------

    # _psh_log_info "step taken"
    :

}


# -----------------------------------------------------------
# _psh_devtools_verify
# -----------------------------------------------------------

function _psh_devtools_verify() {
    :
}
