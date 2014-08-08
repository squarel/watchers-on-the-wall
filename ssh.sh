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
123456
123456
EOF

# check or add tunnel shell
tunnel_shell="usr/bin/wow_tunnel_shell"
if [ ! -f "tunnel_shell" ]; then
touch /usr/bin/wow_tunnel_shell
chmod +x /usr/bin/wow_tunnel_shell

cat > /usr/bin/wow_tunnel_shell <<EOC
#!/bin/bash
trap '' 2 20 24
clear
echo -e "Night gathers, and now my watch begins..."
while [ true ] ; do
    sleep 1000
done
exit 0
EOC
fi

# change shell
chsh -s /usr/bin/wow_tunnel_shell $1 >/dev/null 2>&1
