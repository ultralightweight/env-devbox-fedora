#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.1
# file-purpose: golang environment setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_golang_pre_packages
# -----------------------------------------------------------

function _ups_golang_configure() {
    SYSTEM_PACKAGES+=(
        go
    )
    GOLANG_PACKAGES+=(
        github.com/golang/protobuf/protoc-gen-go
    )

}


# -----------------------------------------------------------
# _ups_golang_post_packages
# -----------------------------------------------------------

function _ups_golang_validate() {
    :
}


# -----------------------------------------------------------
# _ups_golang_pre_install
# -----------------------------------------------------------

function _ups_golang_pre_install() {
    :
}


# -----------------------------------------------------------
# _ups_golang_setup
# -----------------------------------------------------------

function _ups_golang_setup() {

    # -----------------------------------------------------------
    # installing golang packages
    # -----------------------------------------------------------

    if ! grep "GOPATH" ~/.bash_profile; then
        _ups_log_info "Adding GOPATH to ~/.bash_profile..."
        cat >> ~/.bash_profile <<EOF
PATH=$PATH:$(go env GOPATH)/bin
export GOPATH=$(go env GOPATH)
EOF
    fi

    # _ups_log_debug "VARIABLE=${VARIABLE}"
    _ups_log_info "Installing GO packages..."
    local GO_PACKAGE_NAME=
    for GO_PACKAGE_NAME in ${GOLANG_PACKAGES[@]}; do
        _ups_log_info "Installing GO package: ${GO_PACKAGE_NAME}"
        go get ${GO_PACKAGE_NAME}
    done

}


# -----------------------------------------------------------
# _ups_golang_verify
# -----------------------------------------------------------

function _ups_golang_verify() {
    type go
    go version
}

