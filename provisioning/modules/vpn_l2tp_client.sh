#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.1
# file-purpose: google app engine setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_vpn_l2tp_client_configure
# -----------------------------------------------------------

function _ups_vpn_l2tp_client_configure() {

    # -----------------------------------------------------------
    # packages
    # -----------------------------------------------------------

    SYSTEM_PACKAGES+=(
        NetworkManager-l2tp
    )

    #export VPN_L2TP_NAME=
    #export VPN_L2TP_HOST=
    #export VPN_L2TP_PSK=
    #export VPN_L2TP_USER=
    #export VPN_L2TP_IPSEC_IKE=
    #export VPN_L2TP_IPSEC_ESP=
    #export VPN_L2TP_IPSEC_PFS=

    VPN_L2TP_CLIENT_HELPER_SCRIPTS=(
        vpn-up
        vpn-down
    )

}


# -----------------------------------------------------------
# _ups_vpn_l2tp_client_validate
# -----------------------------------------------------------

function _ups_vpn_l2tp_client_validate() {
    :
}


# -----------------------------------------------------------
# _ups_vpn_l2tp_client_pre_install
# -----------------------------------------------------------

function _ups_vpn_l2tp_client_pre_install() {

    # -----------------------------------------------------------
    # block
    # -----------------------------------------------------------

    :

}


# -----------------------------------------------------------
# _ups_vpn_l2tp_client_setup
# -----------------------------------------------------------

function _ups_vpn_l2tp_client_setup() {

    # -----------------------------------------------------------
    # block
    # -----------------------------------------------------------
    
    _ups_log_info "Enabling and starting NetworkManager..."
    systemctl start NetworkManager
    systemctl enable NetworkManager
    
    _ups_log_info "VPN_L2TP_NAME=${VPN_L2TP_NAME}"
    _ups_log_info "VPN_L2TP_HOST=${VPN_L2TP_HOST}"
    _ups_log_info "VPN_L2TP_PSK=${VPN_L2TP_PSK}"
    _ups_log_info "VPN_L2TP_USER=${VPN_L2TP_USER}"
    _ups_log_info "VPN_L2TP_IPSEC_IKE=${VPN_L2TP_IPSEC_IKE}"
    _ups_log_info "VPN_L2TP_IPSEC_ESP=${VPN_L2TP_IPSEC_ESP}"
    _ups_log_info "VPN_L2TP_IPSEC_PFS=${VPN_L2TP_IPSEC_PFS}"

    if ! nmcli connection show ${VPN_L2TP_NAME} > /dev/null 2>&1; then
        _ups_log_info "Creating connection '${VPN_L2TP_NAME}'..."
        nmcli connection add \
            connection.id ${VPN_L2TP_NAME} \
            con-name ${VPN_L2TP_NAME} \
            type VPN \
            vpn-type l2tp \
            ifname \
            -- \
            connection.autoconnect no \
            ipv4.method auto \
            vpn.data "\
                gateway = ${VPN_L2TP_HOST}, \
                ipsec-enabled = yes, \
                ipsec-psk = ${VPN_L2TP_PSK}, \
                mru = 1400, mtu = 1400, \
                password-flags = 1, \
                refuse-pap = no, \
                refuse-chap = yes, \
                refuse-mschap = yes, \
                user = ${VPN_L2TP_USER}, \
                ipsec-ike = ${VPN_L2TP_IPSEC_IKE}, \
                ipsec-esp = ${VPN_L2TP_IPSEC_ESP}, \
                ipsec-pfs = ${VPN_L2TP_IPSEC_PFS} \
            "
    else
        _ups_log_notice "skipped: Connection '${VPN_L2TP_NAME}' already exists."
        _ups_log_notice "skipped: Use the following command to delete and force re-creation: \`nmcli c del ${VPN_L2TP_NAME}\`"
    fi

    local SCRIPT=
    for SCRIPT in ${VPN_L2TP_CLIENT_HELPER_SCRIPTS};
        local SOURCE=${PROVISIONER_ASSETS}/${SCRIPT}
        local TARGET=~/${SCRIPT}
        if [[ ! -f TARGET ]]; then
            _ups_log_info "installing ${SCRIPT} from: ${SOURCE} to: ${TARGET}"
            cat ${SOURCE} | envsubst > ${TARGET}
            chmod +x ${TARGET}
        fi
    done


}


# -----------------------------------------------------------
# _ups_vpn_l2tp_client_verify
# -----------------------------------------------------------

function _ups_vpn_l2tp_client_verify() {
    :
    nmcli c | grep "${VPN_L2TP_NAME}"
}


