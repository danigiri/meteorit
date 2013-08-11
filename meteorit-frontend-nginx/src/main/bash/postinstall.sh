#!/bin/bash

# PREINSTALLATION script for meteorit-frontend

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

 # first time installation
if [ "$1" -eq '1' ]; then

	echo 'Starting redis...'
	# configure redis for startup and start it
	/sbin/chkconfig redis on
	/sbin/service redis start

	echo 'Starting nginx...'
	/sbin/service nginx start
	/sbin/chkconfig nginx on
	
else

	/sbin/service nginx upgrade

fi
