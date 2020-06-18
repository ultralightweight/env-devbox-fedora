#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: nodejs installation executed as developer user
# -----------------------------------------------------------------------------

# -----------------------------------------------------------
# initializing interactive environment
# -----------------------------------------------------------
# nvm installs itself in .bashrc, which is only executed when 
# an interactive shell is created. This is a script, so we
# have to source it manually. **Sigh**

[[ -f ~/.bashrc ]] && source ~/.bashrc


# -----------------------------------------------------------
# load provisioner
# -----------------------------------------------------------

source ${PROVISIONER_MAIN}


# -----------------------------------------------------------
# install nvm
# -----------------------------------------------------------

if ! nvm --version &> /dev/null 2>&1; then
    _psh_log_info "downloading nvm installer from: ${NODEJS_NVM_DOWNLOAD_URL}"
    curl -s -o- ${NODEJS_NVM_DOWNLOAD_URL} > ~/nvm_installer.sh
    _psh_log_info "installing nvm..."
    bash ~/nvm_installer.sh
    NODEJS_NVM_DIR="$HOME/.nvm"
    [ -s "$NODEJS_NVM_DIR/nvm.sh" ] && \. "$NODEJS_NVM_DIR/nvm.sh"
    [ -s "$NODEJS_NVM_DIR/bash_completion" ] && \. "$NODEJS_NVM_DIR/bash_completion"
else
    _psh_log_info "nvm already installed: skipping"
fi

[[ -f ~/nvm_installer.sh ]] && rm -fv ~/nvm_installer.sh


# -----------------------------------------------------------
# install lts version
# -----------------------------------------------------------

_psh_log_info "installing nodejs version '${NODEJS_VERSION}' using nvm... "
nvm install ${NODEJS_VERSION}


# -----------------------------------------------------------
# quick fix npm link
# -----------------------------------------------------------

# _psh_log_info "applying dirty npm link fix..."

# Granting write access to global node_modules directory to everybody,
# which is required for the `npm link` command to work from userland.
# This is not the best practice, but hey, it's nodejs! There is no best practice.
# chmod a+w /usr/lib/node_modules
