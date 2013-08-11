#!/bin/bash

# PREREMOVAL script for meteorit-frontend

#  Copyright 2013 Daniel Giribet <dani - calidos.cat>
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

nginx_logfolder=${nginx.installfolder_}/logs
ngnix_fastcgifolder=${nginx.installfolder_}/fastcgi_temp

# last time, clean up the environment
if [ "$1" == '0' ]; then
	/sbin/service nginx stop
	/sbin/chkconfig nginx off
	if [ -e "$nginx_logfolder" ]; then
		echo "Deleting logs..."
		rm -rf "$nginx_logfolder"
		echo "Deleting temporary folders..."
		for d in ${nginx.installfolder_}/*_temp; do
			[ -d "$d" ] && rm -rf "$d"
		done
	fi
	/sbin/service redis stop
	
fi