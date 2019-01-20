#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: nfs server setup and config
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_docker_configure
# -----------------------------------------------------------

function _ups_docker_configure() {
    SYSTEM_PACKAGES+=(
        docker-ce
    )
}


# -----------------------------------------------------------
# _ups_docker_validate
# -----------------------------------------------------------

function _ups_docker_validate() {
    :
}


# -----------------------------------------------------------
# _ups_docker_pre_install
# -----------------------------------------------------------

function _ups_docker_pre_install() {

    if ! ls /etc/yum.repos.d/docker-ce* &> /dev/null; then
        _ups_log_info "adding docker-ce repositories..."
        dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    else
        _ups_log_notice "skip: docker-ce repositories are already installed."
    fi

}


# -----------------------------------------------------------
# _ups_docker_setup
# -----------------------------------------------------------

function _ups_docker_setup() {

    # -----------------------------------------------------------
    # step
    # -----------------------------------------------------------

    _ups_log_info "enabling and starting docker service..."
    systemctl enable docker
    systemctl start docker

    # -----------------------------------------------------------
    # add dev user
    # -----------------------------------------------------------

    if [[ ! -n "${DEVUSER_NAME}" ]]; then
        _ups_log_info "granting permission for developer user to use docker: ${DEVUSER_NAME}"
        usermod -aG docker ${DEVUSER_NAME}
    else:
        _ups_log_notice "skipped: permission for developer user: \${DEVUSER_NAME} not defined, "
    fi

}


# -----------------------------------------------------------
# _ups_docker_verify
# -----------------------------------------------------------

function _ups_docker_verify() {
    :
}
