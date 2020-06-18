#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: RPM Fusion repo setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_repo_rpmfusion_configure
# -----------------------------------------------------------

function _psh_repo_rpmfusion_configure() {
    SYSTEM_PACKAGES+=(
    )
}


# -----------------------------------------------------------
# _psh_repo_rpmfusion_validate
# -----------------------------------------------------------

function _psh_repo_rpmfusion_validate() {
    :
}


# -----------------------------------------------------------
# _psh_repo_rpmfusion_pre_install
# -----------------------------------------------------------

function _psh_repo_rpmfusion_pre_install() {

    if ! ls /etc/yum.repos.d/rpmfusion* &> /dev/null; then
        _psh_log_info "adding rpmfusion repositories..."
        dnf install -y \
            https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
            https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    else
        _psh_log_notice "skip: rpmfusion repositories are already installed."
    fi

}


# -----------------------------------------------------------
# _psh_repo_rpmfusion_setup
# -----------------------------------------------------------

function _psh_repo_rpmfusion_setup() {

    # -----------------------------------------------------------
    # step
    # -----------------------------------------------------------

    # _psh_log_info "step taken"
    :

}


# -----------------------------------------------------------
# _psh_repo_rpmfusion_verify
# -----------------------------------------------------------

function _psh_repo_rpmfusion_verify() {
    :
}
