
# -----------------------------------------------------------
# load config
# -----------------------------------------------------------

. /vagrant/provisioning/config.sh


# -----------------------------------------------------------
# git personalization
# -----------------------------------------------------------

echo "$0: writing .gitconfig..."

cat > ~/.gitconfig <<EOF
[user]
    email = ${DEVUSER_EMAIL}
    name = ${DEVUSER_FULLNAME}

EOF



# -----------------------------------------------------------
# ssh known-hosts
# -----------------------------------------------------------

KNOWN_HOSTS=(
    "bitbucket.org"
    "github.com"
)

KNOWN_HOSTS_FILE=~/.ssh/known_hosts

echo "$0: adding known hosts to: ${KNOWN_HOSTS_FILE}"
touch ${KNOWN_HOSTS_FILE}

add_known_host () {
    HOST=$1
    if [[ ! $(grep "${HOST}" ${KNOWN_HOSTS_FILE}) ]]; then
        ssh-keyscan "${HOST}" >> ${KNOWN_HOSTS_FILE}
        echo "$0: added ssh key for host '${HOST}'"
    fi
}

for HOST in ${KNOWN_HOSTS[*]}; do
    add_known_host $HOST
done
