#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: mongodb setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_mongodb_configure
# -----------------------------------------------------------

function _psh_mongodb_configure() {

    # -----------------------------------------------------------
    # packages
    # -----------------------------------------------------------

    SYSTEM_PACKAGES+=(
        mongodb-org
    )
}


# -----------------------------------------------------------
# _psh_mongodb_validate
# -----------------------------------------------------------

function _psh_mongodb_validate() {
    :
}


# -----------------------------------------------------------
# _psh_mongodb_pre_install
# -----------------------------------------------------------

function _psh_mongodb_pre_install() {

    # -----------------------------------------------------------
    # write repofile
    # -----------------------------------------------------------
    
    local repo_file="/etc/yum.repos.d/mongodb-org-4.0.repo"

    if [[ ! -f ${repo_file} ]]; then 
        _psh_log_info "adding mongodb repositories..."
        cat > $repo_file <<EOF
[Mongodb]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/4.0/${SYSTEM_ARCHITECTURE}/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc
EOF
    else
        _psh_log_notice "skip: mongodb repositories are already installed."
    fi



}


# -----------------------------------------------------------
# _psh_mongodb_setup
# -----------------------------------------------------------

function _psh_mongodb_setup() {

    # -----------------------------------------------------------
    # enable service
    # -----------------------------------------------------------

    _psh_log_info "enabling and starting mongdb service"

    systemctl enable mongod
    systemctl start mongod

}


# -----------------------------------------------------------
# _psh_mongodb_verify
# -----------------------------------------------------------

function _psh_mongodb_verify() {
    :
}


