#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: nfs server setup and config
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_nfs_configure
# -----------------------------------------------------------

function _ups_nfs_configure() {
    SYSTEM_PACKAGES+=(
        nfs-utils
    )
}


# -----------------------------------------------------------
# _ups_nfs_validate
# -----------------------------------------------------------

function _ups_nfs_validate() {
    :
}


# -----------------------------------------------------------
# _ups_nfs_pre_install
# -----------------------------------------------------------

function _ups_nfs_pre_install() {
    :
}


# -----------------------------------------------------------
# _ups_nfs_setup
# -----------------------------------------------------------

function _ups_nfs_setup() {

    # -----------------------------------------------------------
    # nfs shares
    # -----------------------------------------------------------

    _ups_log_info "configuring NFS shares..."

    sed -i -r "s/#Domain = [a-z.]*/Domain = devbox/g" /etc/idmapd.conf

    cat > /etc/exports <<EOF
/ *(rw,insecure,nohide,no_root_squash)
EOF

    # -----------------------------------------------------------
    # nfs service
    # -----------------------------------------------------------

    _ups_log_info "enabling and starting NFS server service..."
    systemctl start rpcbind nfs-server
    systemctl enable rpcbind nfs-server

}


# -----------------------------------------------------------
# _ups_nfs_verify
# -----------------------------------------------------------

function _ups_nfs_verify() {
    :
}


