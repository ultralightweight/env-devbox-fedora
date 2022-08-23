#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: google app engine setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_gae_configure
# -----------------------------------------------------------

function _psh_gae_configure() {

    # -----------------------------------------------------------
    # packages
    # -----------------------------------------------------------

    SYSTEM_PACKAGES+=(
        google-cloud-sdk
        google-cloud-sdk-app-engine-python-extras
        google-cloud-sdk-app-engine-python
        # google-cloud-sdk-datastore-emulator
        # google-cloud-sdk-app-engine-java
        # google-cloud-sdk-app-engine-go
        # google-cloud-sdk-bigtable-emulator
        # google-cloud-sdk-datalab
        # google-cloud-sdk-datastore-emulator
        # google-cloud-sdk-cbt
        google-cloud-sdk-cloud-build-local
        # google-cloud-sdk-pubsub-emulator
        kubectl
    )
}


# -----------------------------------------------------------
# _psh_gae_validate
# -----------------------------------------------------------

function _psh_gae_validate() {
    :
}


# -----------------------------------------------------------
# _psh_gae_pre_install
# -----------------------------------------------------------

function _psh_gae_pre_install() {

    # -----------------------------------------------------------
    # write repofile
    # -----------------------------------------------------------

    local repo_file="/etc/yum.repos.d/google-cloud-sdk.repo"
    
    if [[ ! -f ${repo_file} ]]; then 
        _psh_log_info "adding gae repositories..."
        cat > $repo_file <<EOF
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-${SYSTEM_ARCHITECTURE}
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
    else
        _psh_log_notice "skip: gae repositories are already installed."
    fi


}


# -----------------------------------------------------------
# _psh_gae_setup
# -----------------------------------------------------------

function _psh_gae_setup() {
    # -----------------------------------------------------------
    # appcfg.py
    # -----------------------------------------------------------
    
    chmod -v +x /usr/lib64/google-cloud-sdk/platform/google_appengine/appcfg.py
    ln -sfv /usr/lib64/google-cloud-sdk/platform/google_appengine/appcfg.py /usr/local/bin

}


# -----------------------------------------------------------
# _psh_gae_verify
# -----------------------------------------------------------

function _psh_gae_verify() {
    :
}


