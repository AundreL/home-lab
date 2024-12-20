#!/usr/bin/env sh

COLOR_GREEN="\033[0;32m"
COLOR_RED="\033[0;31m"
COLOR_BLUE="\033[0;34m"
END_COLOR="\033[0m"

BASE_SOURCE_CONFIG_LOCATION="./configuration.nix"
SYS_NIXOS_CONFIG_LOCATION="/etc/nixos/configuration.nix"

function update(){
	local source_file=$1
	local destination_file=$2
	
	if [[ ! -w $source_file ]]; then
		exit_with_message 1 "insufficent privilage to source file"
	fi

	if [[ ! -w $destination_file ]]; then
		exit_with_message 1 "insufficent privilage to destination file"
	fi

	local source_temp=$(mktemp /tmp/update.XXXXXXXXXXXXXXXXX)
	
	cp -f $source_file $source_temp
	
	if [ $? -ne 0 ];then
		rm $source_temp
		exit_with_message 1 "error during backup copy"
	fi
	
	cp -f $source_temp $destination_file
	rm $source_temp
	
	if [ $? -ne 0 ];then
		exit_with_message 1 "error during destination copy"
	fi
	
}

function exit_with_message(){
	printf "$2\n"
	exit $1
}

printf "${COLOR_BLUE}updating nixos configuration${END_COLOR}\n"

if [ $# -eq 0 ]; then
	update "$BASE_SOURCE_CONFIG_LOCATION" "$SYS_NIXOS_CONFIG_LOCATION"
elif [ $# -eq 2 ]; then
	update $1 $2
else
	exit_with_message 1 "invalid number of arguments"
fi
