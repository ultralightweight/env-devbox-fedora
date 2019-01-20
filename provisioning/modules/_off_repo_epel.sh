#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: nfs server setup and config
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_repo_epel_configure
# -----------------------------------------------------------

function _ups_repo_epel_configure() {
    SYSTEM_PACKAGES+=(
        epel-release
    )
}


# -----------------------------------------------------------
# _ups_repo_epel_validate
# -----------------------------------------------------------

function _ups_repo_epel_validate() {
    :
}


# -----------------------------------------------------------
# _ups_repo_epel_pre_install
# -----------------------------------------------------------

function _ups_repo_epel_pre_install() {
    :
}


# -----------------------------------------------------------
# _ups_repo_epel_setup
# -----------------------------------------------------------

function _ups_repo_epel_setup() {

    # -----------------------------------------------------------
    # step
    # -----------------------------------------------------------

    # _ups_log_info "step taken"
    :

}


# -----------------------------------------------------------
# _ups_repo_epel_verify
# -----------------------------------------------------------

function _ups_repo_epel_verify() {
    :
}
