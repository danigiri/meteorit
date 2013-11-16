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

. ${install.prefix_}/share/meteorit/meteorit-common


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
error_and_exit() {
	#<message> <code>
	printf "$1\n" >&2
 	exit $2
}


################################################################################
process_yaml_file_parameter_() {
	# <file> 
	
 	if [ $# -eq 0 ]; then
 		error_and_exit 'No yaml config file passed' 1
 	fi
 
 	f_="$1"
 	shift
 	
 	if [ ! -e "$f_" ]; then
 		printf "Can't find yaml config file ($f_)\n" >&2
 		exit 1
 	fi
	
}


################################################################################
add_yaml_property() {
	# <file> <property name> {<value0> <value1> ... }

	process_yaml_file_parameter_ $@
 	
	if [ $# -lt 2 ]; then
 		printf "Should pass propertyname and value\n" >&2
 		exit 1
	fi
 	
}


################################################################################
has_yaml_property() {

	process_yaml_file_parameter_ $@

	if [ $# -ne 2 ]; then
 		printf "Should pass propertyname only\n" >&2
 		exit 1
	fi

	p_="$2"
	grep -q "$p_" "$f_"
	if [ "$?" -ne 0 ]; then
		printf "Property not found ($?)\n" >&2
		exit 1
	fi
	
	exit 0
}


################################################################################
get_yaml_property() {
	$(has_yaml_property $@)

}


################################################################################
add_zookeeper_addresses() {
 	# $1 file {address address ...}
	a=a
  
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







