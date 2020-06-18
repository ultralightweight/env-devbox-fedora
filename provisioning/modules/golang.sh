#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.1
# file-purpose: golang environment setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_golang_pre_packages
# -----------------------------------------------------------

function _psh_golang_configure() {
    SYSTEM_PACKAGES+=(
        go
    )
    GOLANG_PACKAGES+=(
        github.com/golang/protobuf/protoc-gen-go
    )

}


# -----------------------------------------------------------
# _psh_golang_post_packages
# -----------------------------------------------------------

function _psh_golang_validate() {
    :
}


# -----------------------------------------------------------
# _psh_golang_pre_install
# -----------------------------------------------------------

function _psh_golang_pre_install() {
    :
}


# -----------------------------------------------------------
# _psh_golang_setup
# -----------------------------------------------------------

function _psh_golang_setup() {

    # -----------------------------------------------------------
    # installing golang packages
    # -----------------------------------------------------------

    if ! grep "GOPATH" ~/.bash_profile; then
        _psh_log_info "Adding GOPATH to ~/.bash_profile..."
        cat >> ~/.bash_profile <<EOF
PATH=$PATH:$(go env GOPATH)/bin
export GOPATH=$(go env GOPATH)
EOF
    fi

    # _psh_log_debug "VARIABLE=${VARIABLE}"
    _psh_log_info "Installing GO packages..."
    local GO_PACKAGE_NAME=
    for GO_PACKAGE_NAME in ${GOLANG_PACKAGES[@]}; do
        _psh_log_info "Installing GO package: ${GO_PACKAGE_NAME}"
        go get ${GO_PACKAGE_NAME}
    done

}


# -----------------------------------------------------------
# _psh_golang_verify
# -----------------------------------------------------------

function _psh_golang_verify() {
    type go
    go version
}

