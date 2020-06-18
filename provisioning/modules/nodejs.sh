#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: nodejs environment setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_nodejs_configure
# -----------------------------------------------------------

function _psh_nodejs_configure() {
    SYSTEM_PACKAGES+=(
        nodejs
        npm
    )
    export NODEJS_NVM_VERSION=${NODEJS_NVM_VERSION:-0.33.11}
    export NODEJS_VERSION=${NODEJS_VERSION:---lts}
    export NODEJS_NVM_DOWNLOAD_URL=${NODEJS_NVM_DOWNLOAD_URL:-https://raw.githubusercontent.com/creationix/nvm/v${NODEJS_NVM_VERSION}/install.sh}
    export NODEJS_PACKAGES=${NODEJS_PACKAGES:-}
}


# -----------------------------------------------------------
# _psh_nodejs_validate
# -----------------------------------------------------------

function _psh_nodejs_validate() {
    :
}


# -----------------------------------------------------------
# _psh_nodejs_pre_install
# -----------------------------------------------------------

function _psh_nodejs_pre_install() {
    :
}


# -----------------------------------------------------------
# _psh_nodejs_setup
# -----------------------------------------------------------

function _psh_nodejs_setup() {

    # -----------------------------------------------------------
    # unprivileged nvm install
    # -----------------------------------------------------------

    _psh_execute_as \
        -e NODEJS_NVM_DOWNLOAD_URL \
        -e NODEJS_VERSION \
        ${DEVUSER_NAME} nodejs-unprivileged.sh


    # -----------------------------------------------------------
    # npm global package installation
    # -----------------------------------------------------------

    if [[ ! -z "${NODEJS_PACKAGES[@]}" ]]; then 
        _psh_log_info "Installing global NodeJS packages: ${NODEJS_PACKAGES[@]}"
        npm install -g "${NODEJS_PACKAGES[@]}"
    fi

}


# -----------------------------------------------------------
# _psh_nodejs_verify
# -----------------------------------------------------------

function _psh_nodejs_verify() {
    type node
    node --version
    type npm
    npm --version
}
