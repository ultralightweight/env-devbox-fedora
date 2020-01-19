#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: nodejs environment setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_nodejs_configure
# -----------------------------------------------------------

function _ups_nodejs_configure() {
    SYSTEM_PACKAGES+=(
        nodejs
        npm
    )
}


# -----------------------------------------------------------
# _ups_nodejs_validate
# -----------------------------------------------------------

function _ups_nodejs_validate() {
    :
}


# -----------------------------------------------------------
# _ups_nodejs_pre_install
# -----------------------------------------------------------

function _ups_nodejs_pre_install() {
    :
}


# -----------------------------------------------------------
# _ups_nodejs_setup
# -----------------------------------------------------------

function _ups_nodejs_setup() {

    # -----------------------------------------------------------
    # quick fix npm link
    # -----------------------------------------------------------

    # _ups_log_info "applying dirty npm link fix..."

    # Granting write access to global node_modules directory to everybody,
    # which is required for the `npm link` command to work from userland.
    # This is not the best practice, but hey, it's nodejs! There is no best practice.
    #  chmod a+w /usr/lib/node_modules

    # -----------------------------------------------------------
    # unprivileged nvm install
    # -----------------------------------------------------------

    local module_root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
    su - ${DEVUSER_NAME} ${module_root}/nodejs-unprivileged.sh

}


# -----------------------------------------------------------
# _ups_nodejs_verify
# -----------------------------------------------------------

function _ups_nodejs_verify() {
    type node
    node --version
    type npm
    npm --version
}

