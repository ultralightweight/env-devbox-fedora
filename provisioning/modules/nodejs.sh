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
    # quick fix npm link
    # -----------------------------------------------------------

    # _psh_log_info "applying dirty npm link fix..."

    # Granting write access to global node_modules directory to everybody,
    # which is required for the `npm link` command to work from userland.
    # This is not the best practice, but hey, it's nodejs! There is no best practice.
    #  chmod a+w /usr/lib/node_modules

    # -----------------------------------------------------------
    # unprivileged nvm install
    # -----------------------------------------------------------

    _psh_execute_as ${DEVUSER_NAME} nodejs-unprivileged.sh

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
