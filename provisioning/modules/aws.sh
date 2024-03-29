#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.1
# file-purpose: amazon web services (aws) setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_aws_configure
# -----------------------------------------------------------

function _psh_aws_configure() {
    SYSTEM_PACKAGES+=(
    )
    PYTHON_PACKAGES+=(
        boto
    )
    PYTHON3_PACKAGES+=(
        awscli
        aws-sam-cli
    )
    AWS_CONFIG_DIR=${DEVUSER_HOME}/.aws
    AWS_CONFIG_FILE=${AWS_CONFIG_DIR}/config
    AWS_CREDENTIALS_FILE=${AWS_CONFIG_DIR}/credentials
    AWS_BIN_DIR=${SYSTEM_BIN_DIR}
    AWS_EKSCTL_VERSION="0.89.0"
    AWS_EKSCTL_DOWNLOAD_URL="https://github.com/weaveworks/eksctl/releases/download/v${AWS_EKSCTL_VERSION}/eksctl_$(uname -s)_amd64.tar.gz"
    # AWS_IAMAUTHENTICATOR_DOWNLOAD_URL=https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
    AWS_IAMAUTHENTICATOR_VERSION="0.5.5"
    AWS_IAMAUTHENTICATOR_DOWNLOAD_URL="https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AWS_IAMAUTHENTICATOR_VERSION}/aws-iam-authenticator_0.5.5_linux_amd64"
    AWS_CF_WATCH_DOWNLOAD_URL="https://raw.githubusercontent.com/alestic/aws-cloudformation-stack-status/master/aws-cloudformation-stack-status"
    AWS_HELPER_SCRIPTS=(
        aws-assume-role
        aws-session
        aws-ecr-login
    )
}


# -----------------------------------------------------------
# _psh_aws_validate
# -----------------------------------------------------------

function _psh_aws_validate() {
    :
}


# -----------------------------------------------------------
# _psh_aws_pre_install
# -----------------------------------------------------------

function _psh_aws_pre_install() {
    :
}


# -----------------------------------------------------------
# _psh_aws_setup
# -----------------------------------------------------------

function _psh_aws_setup() {


    # -----------------------------------------------------------
    # eksctl
    # -----------------------------------------------------------

    if ! type eksctl >/dev/null 2>&1; then
        _psh_log_info "installing eksctrl from: ${AWS_EKSCTL_DOWNLOAD_URL}"
        curl -sSL --location ${AWS_EKSCTL_DOWNLOAD_URL} | tar xz -C /tmp
        mv -v /tmp/eksctl ${AWS_BIN_DIR}
    fi


    # -----------------------------------------------------------
    # aws-iam-authenticator
    # -----------------------------------------------------------

    if ! type aws-iam-authenticator >/dev/null 2>&1; then
        _psh_log_info "installing aws-iam-authenticator from: ${AWS_IAMAUTHENTICATOR_DOWNLOAD_URL}"
        curl -sSL -o aws-iam-authenticator ${AWS_IAMAUTHENTICATOR_DOWNLOAD_URL}
        chmod +x aws-iam-authenticator
        mv -v aws-iam-authenticator ${AWS_BIN_DIR}
    fi


    # -----------------------------------------------------------
    # aws-cloudformation-stack-status
    # -----------------------------------------------------------

    if ! type aws-cloudformation-stack-status >/dev/null 2>&1; then
        _psh_log_info "installing aws-cloudformation-stack-status from: ${AWS_CF_WATCH_DOWNLOAD_URL}"
        curl -sSL -o aws-cloudformation-stack-status ${AWS_CF_WATCH_DOWNLOAD_URL}
        chmod +x aws-cloudformation-stack-status
        mv -v aws-cloudformation-stack-status ${AWS_BIN_DIR}
    fi


    # -----------------------------------------------------------
    # aws helper scripts
    # -----------------------------------------------------------

    local AWS_HELPER_SCRIPT=
    for AWS_HELPER_SCRIPT in ${AWS_HELPER_SCRIPTS[@]}; do
        local SOURCE=${PROVISIONER_ASSETS}/${AWS_HELPER_SCRIPT}
        local TARGET=${AWS_BIN_DIR}/${AWS_HELPER_SCRIPT}
        if ! type ${AWS_HELPER_SCRIPT} >/dev/null 2>&1; then
            _psh_log_info "installing ${AWS_HELPER_SCRIPT} from: ${SOURCE} to: ${TARGET}"
            cp -vf ${SOURCE} ${TARGET}
            chmod +x ${TARGET}
        fi
    done


    # -----------------------------------------------------------
    # config
    # -----------------------------------------------------------

    _psh_log_info "setting up aws configuration..."

    mkdir -p ${AWS_CONFIG_DIR}

    if [[ ! -f ${AWS_CONFIG_FILE} ]]; then
        _psh_log_info "writing aws config file: ${AWS_CONFIG_FILE}"
        cat > ${AWS_CONFIG_FILE} <<EOF
[default]
region = ${AWS_CONFIG_REGION}
output = ${AWS_CONFIG_DEFAULT_FORMAT}
EOF
    else
        _psh_log_notice "skip: aws config file already exists: ${AWS_CONFIG_FILE}"
    fi


    # -----------------------------------------------------------
    # aws credentials
    # -----------------------------------------------------------

    _psh_log_info "setting up aws credentials..."

    if [[ ! -f ${AWS_CREDENTIALS_FILE} ]]; then
        _psh_log_info "writing aws config file: ${AWS_CREDENTIALS_FILE}"
        cat > ${AWS_CREDENTIALS_FILE} <<EOF
[default]
aws_access_key_id = ${AWS_CREDENTIALS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_CREDENTIALS_SECRED_ACCESS_KEY}
EOF
    else
        _psh_log_notice "skip: aws credentials file already exists: ${AWS_CREDENTIALS_FILE}"
    fi


    # -----------------------------------------------------------
    # custom aws config
    # -----------------------------------------------------------

    if ls ${PROVISIONER_CONFIG_CREDENTIALS_ROOT}/aws/* > /dev/null 2>&1; then
        _psh_log_info "copying additional aws config files..."
        cp -rv ${PROVISIONER_CONFIG_CREDENTIALS_ROOT}/aws/. ${AWS_CONFIG_DIR}/
        rm -fv ${AWS_CONFIG_DIR}/.placeholder
    else
        _psh_log_warning "no additional aws config found in: ${PROVISIONER_CONFIG_CREDENTIALS_ROOT}/aws/"
    fi

    chown -R ${DEVUSER_NAME}:${DEVUSER_GID} ${DEVUSER_HOME}/.aws
    chmod 600 ${AWS_CONFIG_DIR}/*

}


# -----------------------------------------------------------
# _psh_aws_verify
# -----------------------------------------------------------

function _psh_aws_verify() {
    type aws
    aws --version

    type eksctl
    eksctl version

    type aws-iam-authenticator
    aws-iam-authenticator version

    for AWS_HELPER_SCRIPT in ${AWS_HELPER_SCRIPTS[@]}; do
        type ${AWS_HELPER_SCRIPT}
    done

}

