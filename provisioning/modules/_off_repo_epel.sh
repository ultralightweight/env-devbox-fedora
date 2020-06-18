#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: nfs server setup and config
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_repo_epel_configure
# -----------------------------------------------------------

function _psh_repo_epel_configure() {
    SYSTEM_PACKAGES+=(
        epel-release
    )
}


# -----------------------------------------------------------
# _psh_repo_epel_validate
# -----------------------------------------------------------

function _psh_repo_epel_validate() {
    :
}


# -----------------------------------------------------------
# _psh_repo_epel_pre_install
# -----------------------------------------------------------

function _psh_repo_epel_pre_install() {
    :
}


# -----------------------------------------------------------
# _psh_repo_epel_setup
# -----------------------------------------------------------

function _psh_repo_epel_setup() {

    # -----------------------------------------------------------
    # step
    # -----------------------------------------------------------

    # _psh_log_info "step taken"
    :

}


# -----------------------------------------------------------
# _psh_repo_epel_verify
# -----------------------------------------------------------

function _psh_repo_epel_verify() {
    :
}
