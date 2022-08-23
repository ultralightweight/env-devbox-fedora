#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.1
# file-purpose: terraform environment setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_terraform_pre_packages
# -----------------------------------------------------------

function _psh_terraform_configure() {
    SYSTEM_PACKAGES+=(
        unzip
    )
    TERRAFORM_VERSION=${TERRAFORM_VERSION:-0.12.26}
    TERRAFORM_DOWNLOAD_PATH="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${SYSTEM_ARCHITECTURE}.zip"
}


# -----------------------------------------------------------
# _psh_terraform_post_packages
# -----------------------------------------------------------

function _psh_terraform_validate() {
    :
}


# -----------------------------------------------------------
# _psh_terraform_pre_install
# -----------------------------------------------------------

function _psh_terraform_pre_install() {
    :
}


# -----------------------------------------------------------
# _psh_terraform_setup
# -----------------------------------------------------------

function _psh_terraform_setup() {

    # -----------------------------------------------------------
    # installing terraform
    # -----------------------------------------------------------

    _psh_log_info "Installing Terraform..."
    if ! type terraform > /dev/null 2>&1; then
        local TERRAFORM_INSTALLER_DIR=/tmp/terraform-installer
        local TERRAFORM_INSTALLER=${TERRAFORM_INSTALLER_DIR}/terraform.zip
        _psh_log_info "Downloading terraform installer from: ${TERRAFORM_DOWNLOAD_PATH} to ${TERRAFORM_INSTALLER}"
        mkdir -pv ${TERRAFORM_INSTALLER_DIR}
        curl -s ${TERRAFORM_DOWNLOAD_PATH} > ${TERRAFORM_INSTALLER}
        unzip -o ${TERRAFORM_INSTALLER} -d ${TERRAFORM_INSTALLER_DIR}
        mv -v ${TERRAFORM_INSTALLER_DIR}/terraform /usr/bin
    else
        _psh_log_notice "Terraform is already installed: $(type terraform)"
    fi

}


# -----------------------------------------------------------
# _psh_terraform_verify
# -----------------------------------------------------------

function _psh_terraform_verify() {
    type terraform
    terraform -v
}

