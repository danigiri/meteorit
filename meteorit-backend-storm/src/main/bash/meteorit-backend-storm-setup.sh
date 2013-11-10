#!/bin/bash

# CONFIGURATION script for meteorit-backend-storm

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

. ${install.prefix_}/share/meteorit/meteorit-common.sh


################################################################################
print_usage_exit() {
	printf "\t%s\n" "Meteorit storm configuration system\n" \
		   "Usage:\t$0 [-h] [-z {host0 host1 ...} [-n [host]]\n" \
		   "\t\t -z [{host0 host1 ...}]: set zookeeper node adresses (empty for localhost)\n" \
		   "\t\t -n [host]: set nimbus node address (empty for localhost)\n" \
		   "\t\t -h: provide help\n" \
	exit 0
}


################################################################################
add_yaml_property() {
	# <file> <property name> {<value0> <value1> ... }

 	if [ "$#" -eq 0 ]; then
 		printf "No yaml config file passed\n" >&2
 		exit 1
 	fi
 
 	f_="$1"
 	shift
 	
 	if [ ! -e "$1" ]; then
 		printf "Can't find yaml config file ($f_)\n" >&2
 		exit 1
 	fi
 	
 	

}

################################################################################
add_zookeeper_addresses() {
 	# $1 file {address address ...}
 echo 'aa'

  
}


zookeeper_=''
nimbus_=''

while getopts "hzn" flag
do
  case $flag in
	h) print_usage_exit ;;
	z) zookeeper_='yes';;
	n) nimbus_='yes';;
	\?) echo "Invalid option: -$OPTARG (use -h for help)" >&2;;
  esac
done
shift $((OPTIND-1))

if [[ "$zookeeper_" == 'yes' ]]; then
	# configure storm zookeeper servers
	a=a
#if [ $#]

elif [[ "$nimbus_" == 'yes' ]]; then
	# specify nimbus address
	a=a

fi
