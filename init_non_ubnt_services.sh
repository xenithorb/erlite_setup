#!/bin/bash

# include
. include/common_functions

SERVICES=( 
	"freeradius"
	"knockd"
)

for i in "${SERVICES[@]}"; do 
	if ! get_done "$i"; then
		update-rc.d "$i" defaults && 
		
		if [[ "$i" == "freeradius" ]]; then
			# Setup the log folder that it expects
			# Fails otherwise	
			log_folder="/var/log/freeradius"
			mkdir -p "$log_folder" &&
			chown -R freerad. "$log_folder" &&
			
			# Make sure symlink is setup for /config/etc/freeradius
			mv /etc/freeradius{,.old} &&
			ln -s /config/etc/freeradius /etc/freeradius
		fi &&

		if [[ "$i" == "knockd" ]]; then
			mv /etc/knockd.conf{,.old} &&
			ln -s /config/etc/knockd.conf /etc/knockd.conf
		fi && 
		service "$i" start &&
		put_done "$i"
	fi
done
