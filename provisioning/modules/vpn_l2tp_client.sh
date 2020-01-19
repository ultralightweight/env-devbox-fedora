#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
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

    export VPN_L2TP_NAME=
    export VPN_L2TP_HOST=
    export VPN_L2TP_PSK=
    export VPN_L2TP_USER=
    export VPN_L2TP_IPSEC_IKE=
    export VPN_L2TP_IPSEC_ESP=
    export VPN_L2TP_IPSEC_PFS=

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
    
    systemctl start NetworkManager    
    systemctl enable NetworkManager    
    
    nmcli c del ${VPN_L2TP_NAME}
    nmcli connection add connection.id ${VPN_L2TP_NAME} con-name ${VPN_L2TP_NAME} type VPN vpn-type l2tp ifname -- connection.autoconnect no ipv4.method auto vpn.data "gateway = ${VPN_L2TP_HOST}, ipsec-enabled = yes, ipsec-psk = ${VPN_L2TP_PSK}, mru = 1400, mtu = 1400, password-flags = 1, refuse-pap = no, refuse-chap = yes, refuse-mschap = yes, user = ${VPN_L2TP_USER}, ipsec-ike = ${VPN_IPSEC_IKE}, ipsec-esp = ${VPN_IPSEC_ESP}, ipsec-pfs = ${VPN_IPSEC_PFS}"


}


# -----------------------------------------------------------
# _ups_vpn_l2tp_client_verify
# -----------------------------------------------------------

function _ups_vpn_l2tp_client_verify() {
    :
}


