#!/usr/bin/env bash

set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__DIR__="$(cd "$(dirname "${0}")"; echo $(pwd))"
__BASE__="$(basename "${0}")"
__FILE__="${__DIR__}/${__BASE__}"

ARG1="${1:-Undefined}"

if [[ "$(id -u)" != "0" ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# check or add group
grep -i "wow_allow_tunnel" /etc/group >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "wow_allow_tunnel group exists, continue..."
else
    groupadd wow_allow_tunnel
fi

# add user
useradd $1 -g wow_allow_tunnel
passwd $1 <<EOF
$2
$2
EOF

# check or add tunnel shell
tunnel_shell="/usr/bin/wow_tunnel_shell"
if [ ! -f "$tunnel_shell" ]; then
    touch $tunnel_shell
    chmod +x $tunnel_shell

cat > $tunnel_shell <<EOF
#!/bin/bash
trap '' 2 20 24
clear
echo -e "Night gathers, and now my watch begins..."
while [ true ] ; do
    sleep 1000
done
exit 0
EOF
fi

# change shell
chsh -s /usr/bin/wow_tunnel_shell $1 >/dev/null 2>&1
