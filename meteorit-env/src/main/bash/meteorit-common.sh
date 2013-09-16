
# common meteorit shell script functions for meteorit

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

remove_user() {

	id "$1" 2>/dev/null
	if [ $? -eq 0 ]; then
		echo "Deleting '$1' user..."
		/usr/sbin/userdel -f "$1"
	else
		echo "Can't delete '$1' user as it doesn't exist"
	fi
	
}


add_daemon_user() {
# <username> <homedir>

	id "$1" 2>/dev/null
	if [ $? -eq 1 ]; then
		echo "Adding '$1' daemon user"
		if [ $# -eq 2 ]; then
			 /usr/sbin/useradd -c "$1 daemon" -d "$2" -M -r -s /sbin/nologin "$1"
		else
			 /usr/sbin/useradd -c "$1 daemon" -M -r -s /sbin/nologin "$1"
		fi		
	fi

}

add_user() {
# <username> <homedir>
	id "$1" 2>/dev/null
	if [ $? -eq 1 ]; then
		echo "Adding '$1' user"
		if [ $# -eq 2 ]; then
			 /usr/sbin/useradd -c "$1 daemon" -d "$2" -M -r "$1"
		else
			 /usr/sbin/useradd -c "$1 daemon" -M -r "$1"
		fi		
	fi

}