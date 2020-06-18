#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: devuser personalization executed as developer user
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# load provisioner
# -----------------------------------------------------------

source ${PROVISIONER_MAIN}


# -----------------------------------------------------------
# git personalization
# -----------------------------------------------------------


if [[ ! -f ~/.gitconfig ]]; then
    _psh_log_info "writing ~/.gitconfig..."
    cat > ~/.gitconfig <<EOF
[user]
    email = ${DEVUSER_EMAIL}
    name = ${DEVUSER_FULLNAME}

EOF
fi


# -----------------------------------------------------------
# ssh known-hosts
# -----------------------------------------------------------

KNOWN_HOSTS=(
    "bitbucket.org"
    "github.com"
)

KNOWN_HOSTS_FILE=~/.ssh/known_hosts

_psh_log_info "adding known hosts to: ${KNOWN_HOSTS_FILE}"
touch ${KNOWN_HOSTS_FILE}

add_known_host () {
    HOST=$1
    if [[ ! $(grep "${HOST}" ${KNOWN_HOSTS_FILE}) ]]; then
        ssh-keyscan "${HOST}" >> ${KNOWN_HOSTS_FILE}
        _psh_log_info "added ssh key for host '${HOST}'"
    fi
}

for HOST in ${KNOWN_HOSTS[*]}; do
    add_known_host $HOST
done

