########################
# VPN Connection Helper
########################

printf "Where do you want to connect to? \n"
printf "(s)imonwunderlich\n"
printf "(t)u dresden\n"
read -p "" choice
printf "\n"
case $choice in
	s)
		printf "Connecting to simonwunderlich...\n"
		cd /etc/openvpn/certs/
		sudo openvpn office.simonwunderlich.de-udp.conf
		;;
	t)
		printf "Connecting to TU Dresden...\n"
		sudo openconnect -u s7978780@tu-dresden.de vpn2.zih.tu-dresden.de
		;;
esac
