#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: nfs server setup and config
# -----------------------------------------------------------------------------



# -----------------------------------------------------------
# _psh_dotnet_configure
# -----------------------------------------------------------

function _psh_dotnet_configure() {
    SYSTEM_PACKAGES+=(
        dotnet-sdk-3.1
    )
}


# -----------------------------------------------------------
# _psh_dotnet_validate
# -----------------------------------------------------------

function _psh_dotnet_validate() {
    :
}


# -----------------------------------------------------------
# _psh_dotnet_pre_install
# -----------------------------------------------------------

function _psh_dotnet_pre_install() {
    :

    if ! ls /etc/yum.repos.d/microsoft* &> /dev/null; then
        _psh_log_info "adding microsoft repositories..."
        dnf config-manager --add-repo https://packages.microsoft.com/config/fedora/31/prod.repo
        if [[ -f /etc/yum.repos.d/prod.repo ]]; then
            # No other company would disrespect a system, only microsoft would
            # shit their crap under the name 'prod'. Bunch of ignorant retards.
            mv /etc/yum.repos.d/prod.repo /etc/yum.repos.d/microsoft.repo
        fi
        _psh_log_info "adding microsoft signing key..."
        rpm --import https://packages.microsoft.com/keys/microsoft.asc

    else
        _psh_log_notice "skip: microsoft repositories are already installed."
    fi
}


# -----------------------------------------------------------
# _psh_dotnet_setup
# -----------------------------------------------------------

function _psh_dotnet_setup() {

    # -----------------------------------------------------------
    # step
    # -----------------------------------------------------------

    # _psh_log_info "step taken"
    :

}


# -----------------------------------------------------------
# _psh_dotnet_verify
# -----------------------------------------------------------

function _psh_dotnet_verify() {
    :

    type dotnet
    dotnet --version

}
