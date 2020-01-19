#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.1
# file-purpose: terraform environment setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_terraform_pre_packages
# -----------------------------------------------------------

function _ups_terraform_configure() {
    SYSTEM_PACKAGES+=(
        unzip
    )
    TERRAFORM_VERSION=0.12.13
    TERRAFORM_DOWNLOAD_PATH="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
}


# -----------------------------------------------------------
# _ups_terraform_post_packages
# -----------------------------------------------------------

function _ups_terraform_validate() {
    :
}


# -----------------------------------------------------------
# _ups_terraform_pre_install
# -----------------------------------------------------------

function _ups_terraform_pre_install() {
    :
}


# -----------------------------------------------------------
# _ups_terraform_setup
# -----------------------------------------------------------

function _ups_terraform_setup() {

    # -----------------------------------------------------------
    # installing terraform
    # -----------------------------------------------------------

    _ups_log_info "Installing Terraform..."
    if ! type terraform; then
        local TERRAFORM_INSTALLER_DIR=/tmp/terraform-installer
        local TERRAFORM_INSTALLER=${TERRAFORM_INSTALLER_DIR}/terraform.zip
        _ups_log_info "Downloading terraform installer from: ${TERRAFORM_DOWNLOAD_PATH} to ${TERRAFORM_INSTALLER}"
        mkdir -pv ${TERRAFORM_INSTALLER_DIR}
        curl ${TERRAFORM_DOWNLOAD_PATH} > ${TERRAFORM_INSTALLER}
        unzip -o ${TERRAFORM_INSTALLER} -d ${TERRAFORM_INSTALLER_DIR}
        mv -v ${TERRAFORM_INSTALLER_DIR}/terraform /usr/bin
    else
        _ups_log_notice "Terraform is already installed: $(type terraform)"
    fi

}


# -----------------------------------------------------------
# _ups_terraform_verify
# -----------------------------------------------------------

function _ups_terraform_verify() {
    type terraform
    terraform -v
}

