#!/bin/bash

function change_to_static() {
	local real_file=$1;
	local static_file=$2;

	cp ${static_file} ${real_file} # change static file to real file
}


function change_to_dhcp()
{
	local real_file=$1;
	local dhcp_file=$2;

	cp ${dhcp_file} ${real_file} # change dhcp file to real file
}

REAL_FILE="/etc/network/interfaces"; # ACTIVE NETWORK CONFIGURATION FILE
DHCP_FILE="/etc/network/interfaces.dhcp"; # DHCP NETWORK CONFIGURATION FILE
STAT_FILE="/etc/network/interfaces.static"; # STATIC NETWORK CONFIGURATION FILE
USER_UUID=`id | grep --perl-regexp --only-match 'uid=[\d]+'`; 
USER_UUID=`echo ${USER_UUID} | awk --field-separator '=' '{print $2}'`;

if [ ${USER_UUID} -ne 0 ];
then
	echo "[-] You need root access to run this file!";
	exit 1;
fi


if [ $# -le 0 ];
then
	echo -e "[+] usage\t: changenetwork <dhcp/static>";
	exit 1;
fi

USER_ARGUMENT=$1;

if [ ${USER_ARGUMENT} == "dhcp" ];
then
	change_to_dhcp ${REAL_FILE} ${DHCP_FILE};
	echo "[+] Done!";
elif [ ${USER_ARGUMENT} == "static" ];
then
	change_to_static ${REAL_FILE} ${STAT_FILE};
	echo "[+] Done!";
else
	echo "[-] ${USER_ARGUMENT} is invalid argument!";
	exit 1;
fi

systemctl restart networking.service # restart networking service
