#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: RPM Fusion repo setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_repo_rpmfusion_configure
# -----------------------------------------------------------

function _ups_repo_rpmfusion_configure() {
    SYSTEM_PACKAGES+=(
    )
}


# -----------------------------------------------------------
# _ups_repo_rpmfusion_validate
# -----------------------------------------------------------

function _ups_repo_rpmfusion_validate() {
    :
}


# -----------------------------------------------------------
# _ups_repo_rpmfusion_pre_install
# -----------------------------------------------------------

function _ups_repo_rpmfusion_pre_install() {

    if ! ls /etc/yum.repos.d/rpmfusion* &> /dev/null; then
        _ups_log_info "adding rpmfusion repositories..."
        dnf install -y \
            https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
            https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    else
        _ups_log_notice "skip: rpmfusion repositories are already installed."
    fi

}


# -----------------------------------------------------------
# _ups_repo_rpmfusion_setup
# -----------------------------------------------------------

function _ups_repo_rpmfusion_setup() {

    # -----------------------------------------------------------
    # step
    # -----------------------------------------------------------

    # _ups_log_info "step taken"
    :

}


# -----------------------------------------------------------
# _ups_repo_rpmfusion_verify
# -----------------------------------------------------------

function _ups_repo_rpmfusion_verify() {
    :
}
