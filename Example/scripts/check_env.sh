#!/bin/sh

function check_brew
{
	has_brew=$( type '/usr/local/bin/brew' 2>/dev/null )
	if (( $? == 0)); then
		echo "homebrew is installed" >&1
	else
        echo "homwbrew is not installed" >&1
	fi
}

function check_fauxpas
{
	if [ -d "/Applications/FauxPas.app" ]; then
		echo "FauxPas App is installed" >&1
	else
		echo "FauxPas App is not installed" >&1
	fi
}

function check_xcodeproj
{
	gem which xcodeproj 1>/dev/null 2>/dev/null
	if [ $? -eq 0 ]
	then
		echo "xcodeproj is installed" >&1
	else
		gem install xcodeproj
		echo "xcodeproj is not installed" >&1
	fi
}

function help
{
	echo "check_brew\n\
check_fauxpas\n\
check_xcodeproj\n"
}

"$@"

