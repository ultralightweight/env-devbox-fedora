#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: nfs server setup and config
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_aws_configure
# -----------------------------------------------------------

function _ups_aws_configure() {
    SYSTEM_PACKAGES+=(
    )
    PYTHON_PACKAGES+=(
        boto
    )
    PYTHON3_PACKAGES+=(
        awscli        
    )
    AWS_CONFIG_DIR=${DEVUSER_HOME}/.aws
}


# -----------------------------------------------------------
# _ups_aws_validate
# -----------------------------------------------------------

function _ups_aws_validate() {
    :
}


# -----------------------------------------------------------
# _ups_aws_pre_install
# -----------------------------------------------------------

function _ups_aws_pre_install() {
    :
}


# -----------------------------------------------------------
# _ups_aws_setup
# -----------------------------------------------------------

function _ups_aws_setup() {

    mkdir -p ${AWS_CONFIG_DIR}

    # -----------------------------------------------------------
    # credentials
    # -----------------------------------------------------------

    AWS_CONFIG_FILE=${AWS_CONFIG_DIR}/config

    if [[ ! -f ${AWS_CONFIG_FILE} ]]; then
        _ups_log_info "writing aws config file: ${AWS_CONFIG_FILE}"
        cat > ${AWS_CONFIG_FILE} <<EOF
[default]
region = ${AWS_CONFIG_REGION}
output = ${AWS_CONFIG_DEFAULT_FORMAT}
EOF
    else
        _ups_log_notice "skip: aws config file already exists: ${AWS_CONFIG_FILE}"
    fi

    # -----------------------------------------------------------
    # credentials
    # -----------------------------------------------------------

    AWS_CREDENTIALS_FILE=${AWS_CONFIG_DIR}/credentials

    if [[ ! -f ${AWS_CREDENTIALS_FILE} ]]; then
        _ups_log_info "writing aws config file: ${AWS_CREDENTIALS_FILE}"
        cat > ${AWS_CREDENTIALS_FILE} <<EOF
[default]
aws_access_key_id = ${AWS_CREDENTIALS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_CREDENTIALS_SECRED_ACCESS_KEY}

EOF
    else
        _ups_log_notice "skip: aws config file already exists: ${AWS_CREDENTIALS_FILE}"
    fi
    

}


# -----------------------------------------------------------
# _ups_aws_verify
# -----------------------------------------------------------

function _ups_aws_verify() {
    :
}
