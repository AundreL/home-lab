#!/usr/bin/env sh

COLOR_GREEN="\033[0;32m"
COLOR_RED="\033[0;31m"
COLOR_BLUE="\033[0;34m"
END_COLOR="\033[0m"

UPDATE_SCRIPT_LOCATION="./update.sh"
BASE_SOURCE_CONFIG_LOCATION="./configuration.nix"
SYS_NIXOS_CONFIG_LOCATION="/etc/nixos/configuration.nix"

function compare(){
	cmp -s "$1" "$2"

	if [ $? -eq 0 ]; then
	 	#same
		echo 0
	else
		#different
		echo 1
	fi
}

function exit_with_message(){
	printf "$2\n"
	exit $1
}

printf "${COLOR_BLUE}starting testing of update script${END_COLOR}\n"

mock_source=$(mktemp /tmp/update.XXXXXXXXXXXXXXXXX)
cp -f $BASE_SOURCE_CONFIG_LOCATION $mock_source

mock_destination=$(mktemp /tmp/update.XXXXXXXXXXXXXXXXX)

$UPDATE_SCRIPT_LOCATION $mock_source $mock_destination

result=$(compare "$BASE_SOURCE_CONFIG_LOCATION" "$mock_destination")

rm $mock_source
rm $mock_destination

if [ $result -eq 0 ]; then
	message="file contains updated content: ${COLOR_GREEN}success${END_COLOR}"
else
	message="file contains updated content: ${COLOR_RED}fail${END_COLOR}"
	exit_with_message "$result" "$message"
fi

$UPDATE_SCRIPT_LOCATION

result=$(compare "$BASE_SOURCE_CONFIG_LOCATION" "$SYS_NIXOS_CONFIG_LOCATION")

if [ $result -eq 0 ]; then
	message="file contains updated content: ${COLOR_GREEN}success${END_COLOR}"
else
	message="file contains updated content: ${COLOR_RED}fail${END_COLOR}"
fi

exit_with_message "$result" "$message"
