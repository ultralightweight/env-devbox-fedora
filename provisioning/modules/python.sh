#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: python environment setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_python_pre_packages
# -----------------------------------------------------------

function _ups_python_configure() {
    SYSTEM_PACKAGES+=(
        python-devel
        python3-devel
    )
    PYTHON_PACKAGES+=(
        virtualenv
    )

    PYTHON2_VERSION=${PYTHON2_VERSION:-2.7}
    PYTHON3_VERSION=${PYTHON3_VERSION:-3.6}

    PYTHON2_PACKAGES+=( ${PYTHON_PACKAGES[@]} )
    PYTHON3_PACKAGES+=( ${PYTHON_PACKAGES[@]} )
}


# -----------------------------------------------------------
# _ups_python_post_packages
# -----------------------------------------------------------

function _ups_python_validate() {
    :
}


# -----------------------------------------------------------
# _ups_python_pre_install
# -----------------------------------------------------------

function _ups_python_pre_install() {
    :
}


# -----------------------------------------------------------
# _ups_python_setup
# -----------------------------------------------------------

function _setup_python() {
    local PYTHON_MAJOR_VERSION=$1
    eval "local PIP_PACKAGES+=( \${PYTHON${PYTHON_MAJOR_VERSION}_PACKAGES[@]} )"
    eval "local PYTHON_VERSION=\${PYTHON${PYTHON_MAJOR_VERSION}_VERSION}"
    local EASY_INSTALL=easy_install-${PYTHON_VERSION}
    local PIP=pip${PYTHON_VERSION}

    _ups_log_info "setting up python version ${PYTHON_VERSION}"

    _ups_log_debug "PYTHON_MAJOR_VERSION=${PYTHON_MAJOR_VERSION}"
    _ups_log_debug "PYTHON_VERSION=${PYTHON_MAJOR_VERSION}"
    _ups_log_debug "EASY_INSTALL=${PYTHON_MAJOR_VERSION}"
    _ups_log_debug "PIP=${PYTHON_MAJOR_VERSION}"
    _ups_log_debug "PIP_PACKAGES=${PYTHON_MAJOR_VERSION}"

    # -----------------------------------------------------------
    # install and upgrade pip
    # -----------------------------------------------------------

    if ! type ${PIP}; then 
        _ups_log_info "python-${PYTHON_VERSION}: installing pip..."
        ${EASY_INSTALL} pip
    else
        _ups_log_notice "skip: pip already installed."
    fi

    _ups_log_info "python-${PYTHON_VERSION}: upgrading pip..."
    ${PIP} install --upgrade pip

    # -----------------------------------------------------------
    # installing python packages
    # -----------------------------------------------------------

    _ups_log_info "python-${PYTHON_VERSION}: installing python packages..."
    ${PIP} install ${PIP_PACKAGES[@]}

}

# -----------------------------------------------------------
# _ups_python_setup
# -----------------------------------------------------------

function _ups_python_setup() {

    # -----------------------------------------------------------
    # installing python packages
    # -----------------------------------------------------------

    _setup_python 3
    _setup_python 2

}


# -----------------------------------------------------------
# _ups_python_verify
# -----------------------------------------------------------

function _ups_python_verify() {
    :
}
