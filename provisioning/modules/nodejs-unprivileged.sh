#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: nodejs installation executed as developer user
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# load provisioner
# -----------------------------------------------------------

source ${PROVISIONER_MAIN}


# -----------------------------------------------------------
# set config
# -----------------------------------------------------------

NODEJS_NVM_INSTALL_URL=https://raw.githubusercontent.com/creationix/nvm/v${NODEJS_NVM_VERSION}/install.sh


# -----------------------------------------------------------
# install nvm
# -----------------------------------------------------------

if ! type nvm &> /dev/null; then
    _psh_log_info "installing nvm from: ${NODEJS_NVM_INSTALL_URL}"
    curl -o- ${NODEJS_NVM_INSTALL_URL} | bash
    export NODEJS_NVM_DIR="$HOME/.nvm"
    [ -s "$NODEJS_NVM_DIR/nvm.sh" ] && \. "$NODEJS_NVM_DIR/nvm.sh"
    [ -s "$NODEJS_NVM_DIR/bash_completion" ] && \. "$NODEJS_NVM_DIR/bash_completion"
else
    _psh_log_info "skipping: nvm: already installed"
fi


# -----------------------------------------------------------
# install lts version
# -----------------------------------------------------------

su - ${DEVUSER_NAME} nvm install ${NODEJS_VERSION}

# -----------------------------------------------------------
# quick fix npm link
# -----------------------------------------------------------

# _psh_log_info "applying dirty npm link fix..."

# Granting write access to global node_modules directory to everybody,
# which is required for the `npm link` command to work from userland.
# This is not the best practice, but hey, it's nodejs! There is no best practice.
# chmod a+w /usr/lib/node_modules
