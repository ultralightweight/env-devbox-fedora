#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.2
# file-purpose: python environment setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_python_pre_packages
# -----------------------------------------------------------

function _psh_python_configure() {
    PYTHON_PACKAGES+=(
        virtualenv
    )

    # PYTHON2_VERSION=${PYTHON2_VERSION:-2}
    PYTHON3_VERSION=${PYTHON3_VERSION:-3}

    # PYTHON2_PACKAGES+=( ${PYTHON_PACKAGES[@]} )
    PYTHON3_PACKAGES+=( ${PYTHON_PACKAGES[@]} )

    SYSTEM_PACKAGES+=(
        # python${PYTHON2_VERSION}-devel
        # python${PYTHON2_VERSION}-pip
        python${PYTHON3_VERSION}-devel
        python${PYTHON3_VERSION}-pip
    )


}


# -----------------------------------------------------------
# _psh_python_post_packages
# -----------------------------------------------------------

function _psh_python_validate() {
    :
}


# -----------------------------------------------------------
# _psh_python_pre_install
# -----------------------------------------------------------

function _psh_python_pre_install() {
    :
}


# -----------------------------------------------------------
# _psh_python_setup
# -----------------------------------------------------------

function _setup_python() {
    local PYTHON_MAJOR_VERSION=$1
    eval "local PIP_PACKAGES+=( \${PYTHON${PYTHON_MAJOR_VERSION}_PACKAGES[@]} )"
    eval "local PYTHON_VERSION=\${PYTHON${PYTHON_MAJOR_VERSION}_VERSION}"
    local PIP=$(type -p pip${PYTHON_VERSION})

    _psh_log_info "Setting up Python version ${PYTHON_VERSION}"

    _psh_log_debug "PYTHON_MAJOR_VERSION=${PYTHON_MAJOR_VERSION}"
    _psh_log_debug "PYTHON_VERSION=${PYTHON_VERSION}"
    _psh_log_debug "PIP=${PIP}"
    _psh_log_debug "PIP_PACKAGES=${PIP_PACKAGES[@]}"

    # -----------------------------------------------------------
    # upgrade pip
    # -----------------------------------------------------------

    _psh_log_info "python-${PYTHON_VERSION}: upgrading pip..."
    ${PIP} install --upgrade pip

    local PIP=$(type -p pip${PYTHON_VERSION})

    # -----------------------------------------------------------
    # installing python packages
    # -----------------------------------------------------------

    _psh_log_info "python-${PYTHON_VERSION}: installing the following python packages: ${PIP_PACKAGES[@]}"
    ${PIP} install --ignore-installed ${PIP_PACKAGES[@]}

}

# -----------------------------------------------------------
# _psh_python_setup
# -----------------------------------------------------------

function _psh_python_setup() {

    # -----------------------------------------------------------
    # installing python packages
    # -----------------------------------------------------------

    _setup_python 3
    # _setup_python 2

}


# -----------------------------------------------------------
# _psh_python_verify
# -----------------------------------------------------------

function _psh_python_verify() {
    # type python2
    # python2 --version
    type python3
    python3 --version
}
