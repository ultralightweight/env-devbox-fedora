#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: kubernetes client setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_kubernetes_client_configure
# -----------------------------------------------------------

function _psh_kubernetes_client_configure() {
    SYSTEM_PACKAGES+=(
        kubectl
    )
    KUBERNETES_CLIENT_BIN_DIR=${KUBERNETES_CLIENT_BIN_DIR:-${SYSTEM_BIN_DIR}}
    HELM2_VERSION=${HELM2_VERSION:-2.16.9}
    HELM3_VERSION=${HELM3_VERSION:-3.2.4}
    KUBERNETES_CLIENT_HELM2_DOWNLOAD_URL="https://get.helm.sh/helm-v${HELM2_VERSION}-linux-amd64.tar.gz"
    KUBERNETES_CLIENT_HELM3_DOWNLOAD_URL="https://get.helm.sh/helm-v${HELM3_VERSION}-linux-amd64.tar.gz"
    K9S_VERSION=${K9S_VERSION:-0.20.5}
    KUBERNETES_CLIENT_K9s_DOWNLOAD_URL="https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz"
}


# -----------------------------------------------------------
# _psh_kubernetes_client_validate
# -----------------------------------------------------------

function _psh_kubernetes_client_validate() {
    :
}


# -----------------------------------------------------------
# _psh_kubernetes_client_pre_install
# -----------------------------------------------------------

function _psh_kubernetes_client_pre_install() {
  
    # -----------------------------------------------------------
    # write repofile
    # -----------------------------------------------------------

    local repo_file="/etc/yum.repos.d/kubernetes.repo"
    
    if [[ ! -f ${repo_file} ]]; then 
        _psh_log_info "writing kubernetes repository file: ${repo_file}"
        cat > ${repo_file} <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
        _psh_log_info "importing repository keys..."
        rpm --import https://packages.cloud.google.com/yum/doc/yum-key.gpg
        rpm --import https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
        rpm -qa --qf '%{VERSION}-%{RELEASE} %{SUMMARY}\n' *pubkey*
    else
        _psh_log_notice "skip: kubernetes repository already installed: ${repo_file}"
    fi

}


# -----------------------------------------------------------
# _psh_kubernetes_client_setup
# -----------------------------------------------------------

function _psh_kubernetes_client_setup() {

    # -----------------------------------------------------------
    # helm
    # -----------------------------------------------------------

    if ! type helm3 >/dev/null 2>&1; then
        _psh_log_info "installing helm3 from: ${KUBERNETES_CLIENT_HELM3_DOWNLOAD_URL}"
        mkdir -p /tmp/helm
        curl -sS --location ${KUBERNETES_CLIENT_HELM3_DOWNLOAD_URL} | tar xz -C /tmp/helm
        mv /tmp/helm/linux-amd64/helm ${KUBERNETES_CLIENT_BIN_DIR}/helm3
        ln -sf ${KUBERNETES_CLIENT_BIN_DIR}/helm3 ${KUBERNETES_CLIENT_BIN_DIR}/helm
        rm -rf /tmp/helm
    fi

    if ! type helm2 >/dev/null 2>&1; then
        _psh_log_info "installing helm2 from: ${KUBERNETES_CLIENT_HELM2_DOWNLOAD_URL}"
        mkdir -p /tmp/helm
        curl -sS --location ${KUBERNETES_CLIENT_HELM2_DOWNLOAD_URL} | tar xz -C /tmp/helm
        mv /tmp/helm/linux-amd64/helm ${KUBERNETES_CLIENT_BIN_DIR}/helm2
        rm -rf /tmp/helm2
    fi


    # -----------------------------------------------------------
    # k9s
    # -----------------------------------------------------------

    if ! type k9s >/dev/null 2>&1; then
        _psh_log_info "installing k9s from: ${KUBERNETES_CLIENT_K9s_DOWNLOAD_URL}"
        mkdir -p /tmp/k9s
        curl -sS --location ${KUBERNETES_CLIENT_K9s_DOWNLOAD_URL} | tar xz -C /tmp/k9s
        mv /tmp/k9s/linux-amd64/k9s ${KUBERNETES_CLIENT_BIN_DIR}
        ln -s ${KUBERNETES_CLIENT_BIN_DIR}/helm3 ${KUBERNETES_CLIENT_BIN_DIR}/k9s
        rm -rf /tmp/k9s
    fi


}


# -----------------------------------------------------------
# _psh_kubernetes_client_verify
# -----------------------------------------------------------

function _psh_kubernetes_client_verify() {
    
    type kubectl
    kubectl version --client

    type helm3
    helm3 version --client

    type helm2
    helm2 version --client

    type k9s
    k9s version


}



