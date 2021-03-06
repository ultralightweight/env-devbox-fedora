#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Neville Tummon <nt.devs@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: samba server setup and config
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_samba_configure
# -----------------------------------------------------------

function _psh_samba_configure() {
    SYSTEM_PACKAGES+=(
        samba
    )
}


# -----------------------------------------------------------
# _psh_samba_validate
# -----------------------------------------------------------

function _psh_samba_validate() {
    :
}


# -----------------------------------------------------------
# _psh_samba_pre_install
# -----------------------------------------------------------

function _psh_samba_pre_install() {
    :
}


# -----------------------------------------------------------
# _psh_samba_setup
# -----------------------------------------------------------

function _psh_samba_setup() {

    # -----------------------------------------------------------
    # samba shares
    # -----------------------------------------------------------

    _psh_log_info "configuring samba shares..."

    cp /etc/samba/smb.conf /etc/samba/smb.conf.backup

    if [[ ! $(grep "\[system\]" /etc/samba/smb.conf) ]]; then 
        _psh_log_info "creating samba share 'system'..."
        cat << EOF > /etc/samba/smb.conf
[system]
        comment = Root directory
        public = yes
        path = /
        writeable = yes
        create mask = 0644
        directory mask = 0755
        write list = root ${DEVUSER_NAME}
EOF
fi

    smbpasswd -a ${DEVUSER_NAME} -n
    (echo ${DEVUSER_PASSWORD}; echo ${DEVUSER_PASSWORD}) | smbpasswd -a ${DEVUSER_NAME}

    # -----------------------------------------------------------
    # samba service
    # -----------------------------------------------------------

    _psh_log_info "enabling and starting samba server service..."
    setsebool -P samba_enable_home_dirs=1
    systemctl start smb nmb
    systemctl enable smb nmb

}


# -----------------------------------------------------------
# _psh_samba_verify
# -----------------------------------------------------------

function _psh_samba_verify() {
    :

    systemctl status smb nmb
    testparm -s
}


