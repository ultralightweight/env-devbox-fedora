#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: kubernetes client setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_kubernetes_client_configure
# -----------------------------------------------------------

function _ups_kubernetes_client_configure() {
    SYSTEM_PACKAGES+=(
        kubectl
    )
    KUBERNETES_CLIENT_HELM_DOWNLOAD_URL="https://get.helm.sh/helm-v3.0.0-linux-amd64.tar.gz"
    KUBERNETES_CLIENT_BIN_DIR=${SYSTEM_BIN_DIR}
}


# -----------------------------------------------------------
# _ups_kubernetes_client_validate
# -----------------------------------------------------------

function _ups_kubernetes_client_validate() {
    :
}


# -----------------------------------------------------------
# _ups_kubernetes_client_pre_install
# -----------------------------------------------------------

function _ups_kubernetes_client_pre_install() {
  
    # -----------------------------------------------------------
    # write repofile
    # -----------------------------------------------------------

    local repo_file="/etc/yum.repos.d/kubernetes.repo"
    
    if [[ ! -f ${repo_file} ]]; then 
        _ups_log_info "writing kubernetes repository file: ${repo_file}"
        cat > ${repo_file} <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
        _ups_log_info "importing repository keys..."
        rpm --import https://packages.cloud.google.com/yum/doc/yum-key.gpg
        rpm --import https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
        rpm -qa --qf '%{VERSION}-%{RELEASE} %{SUMMARY}\n' *pubkey*
    else
        _ups_log_notice "skip: kubernetes repository already installed: ${repo_file}"
    fi

}


# -----------------------------------------------------------
# _ups_kubernetes_client_setup
# -----------------------------------------------------------

function _ups_kubernetes_client_setup() {

    # -----------------------------------------------------------
    # helm
    # -----------------------------------------------------------

    if ! type helm >/dev/null 2>&1; then
        _ups_log_info "installing helm from: ${KUBERNETES_CLIENT_HELM_DOWNLOAD_URL}"
        # curl -sS -o /tmp/helm.tar.gz ${KUBERNETES_CLIENT_HELM_DOWNLOAD_URL}
        mkdir -p /tmp/helm
        curl -sS --location ${KUBERNETES_CLIENT_HELM_DOWNLOAD_URL} | tar xz -C /tmp/helm
        mv /tmp/helm/linux-amd64/helm ${KUBERNETES_CLIENT_BIN_DIR}
        rm -rf /tmp/helm
    fi

}


# -----------------------------------------------------------
# _ups_kubernetes_client_verify
# -----------------------------------------------------------

function _ups_kubernetes_client_verify() {
    
    type kubectl
    kubectl version --client

    type helm
    helm version
}














