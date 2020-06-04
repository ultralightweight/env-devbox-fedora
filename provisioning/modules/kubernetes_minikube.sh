#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: minikube
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_kubernetes_minikube_configure
# -----------------------------------------------------------

function _ups_kubernetes_minikube_configure() {
    SYSTEM_PACKAGES+=(
    )
    KUBERNETES_MINIKUBE_DOWNLOAD_URL="https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
    KUBERNETES_MINIKUBE_BIN_DIR=${SYSTEM_BIN_DIR}
}


# -----------------------------------------------------------
# _ups_kubernetes_minikube_validate
# -----------------------------------------------------------

function _ups_kubernetes_minikube_validate() {
    :
}


# -----------------------------------------------------------
# _ups_kubernetes_minikube_pre_install
# -----------------------------------------------------------

function _ups_kubernetes_minikube_pre_install() {

    _ups_log_info "importing GPG keys for Google Package Repositories..."
    rpm --verbose --import https://packages.cloud.google.com/apt/doc/rpm-package-key.gpg
    rpmkeys --verbose --import https://packages.cloud.google.com/apt/doc/rpm-package-key.gpg
    rpm --verbose --import https://packages.cloud.google.com/apt/doc/yum-key.gpg
    rpmkeys --verbose --import https://packages.cloud.google.com/apt/doc/yum-key.gpg

}


# -----------------------------------------------------------
# _ups_kubernetes_minikube_setup
# -----------------------------------------------------------

function _ups_kubernetes_minikube_setup() {

    # -----------------------------------------------------------
    # minikube
    # -----------------------------------------------------------

    if ! type minikube >/dev/null 2>&1; then
        _ups_log_info "installing minikube from: ${KUBERNETES_MINIKUBE_DOWNLOAD_URL}"
        curl -sS --location ${KUBERNETES_MINIKUBE_DOWNLOAD_URL} -o /tmp/minikube
        chmod +x /tmp/minikube
        mv -v /tmp/minikube ${KUBERNETES_MINIKUBE_BIN_DIR}
    fi

}


# -----------------------------------------------------------
# _ups_kubernetes_minikube_verify
# -----------------------------------------------------------

function _ups_kubernetes_minikube_verify() {

    type minikube
    minikube version

}
