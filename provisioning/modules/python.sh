#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.1
# file-purpose: python environment setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_python_pre_packages
# -----------------------------------------------------------

function _ups_python_configure() {
    SYSTEM_PACKAGES+=(
        python-devel
        python2-pip
        python3-devel
        python3-pip
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
    local PIP=$(type -p pip${PYTHON_VERSION})

    _ups_log_info "Setting up Python version ${PYTHON_VERSION}"

    _ups_log_debug "PYTHON_MAJOR_VERSION=${PYTHON_MAJOR_VERSION}"
    _ups_log_debug "PYTHON_VERSION=${PYTHON_MAJOR_VERSION}"
    _ups_log_debug "PIP=${PYTHON_MAJOR_VERSION}"
    _ups_log_debug "PIP_PACKAGES=${PYTHON_MAJOR_VERSION}"

    # -----------------------------------------------------------
    # upgrade pip
    # -----------------------------------------------------------

    _ups_log_info "python-${PYTHON_VERSION}: upgrading pip..."
    ${PIP} install --upgrade pip

    local PIP=$(type -p pip${PYTHON_VERSION})

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
