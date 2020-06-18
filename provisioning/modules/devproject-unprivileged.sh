#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: project setup stage executed as developer user
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# load provisioner
# -----------------------------------------------------------

source ${PROVISIONER_MAIN}


# -----------------------------------------------------------
# setup project
# -----------------------------------------------------------

_psh_log_info "setting up project"

if [ ! -d ${DEVPROJECT_DIR} ]; then
    git clone ${DEVPROJECT_GIT} ${DEVPROJECT_DIR}
fi

DEVPROJECT_SETUP_FILE=~/devproject_setup.sh

_psh_log_info "writing project setup script file: ${DEVPROJECT_SETUP_FILE}"

echo -n "${DEVPROJECT_SETUP}" > ${DEVPROJECT_SETUP_FILE}

_psh_log_info "executing devproject setup file: ${DEVPROJECT_SETUP_FILE}"
source ${DEVPROJECT_SETUP_FILE}


_psh_log_info "project ready"

