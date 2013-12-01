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

#. ${install.prefix_}/share/meteorit/meteorit-common
. /opt/share/meteorit/meteorit-common

################################################################################
print_usage_exit() {

	printf "Meteorit storm configuration system\n" 1>&2 
	printf "Usage:\t$0 [-h] [-z {host0 host1 ...} [-n [host]]\n" 1>&2 
	printf "\t\t -z [{host0 host1 ...}]: set zookeeper node adresses\n" 1>&2 
	printf "\t\t -n [host]: set nimbus node address\n" 1>&2 
	printf "\t\t -h: provide help\n" 1>&2
	
	exit 0
	
}


################################################################################
error_and_exit_() {
	#<message> <code>

	printf "$1\n" 1>&2
 	exit $2
 	
}


################################################################################
process_yaml_file_parameter_() {
	# <file> 
	
 	if [ "$#" -eq '0' ]; then
 		error_and_exit_ 'No yaml config file passed' 1
 	fi
 
 	f_="$1"
 	shift
 	
 	if [ ! -e "$f_" ]; then
 		error_and_exit_ "Can't find yaml config file ($f_)\n" 1
 	fi
	
}


################################################################################
set_yaml_property() {
	# <file> <property> <value>

	process_yaml_file_parameter_ $@
 	
	if [ $# -ne 3 ]; then
 		error_and_exit_ "Should pass file, propertyname and value\n" 1
	fi
	
	f_="$1"
	p_="$2"
	v_="$3"
 	
 	(has_yaml_property $@ 2> /dev/null)
	if [ "$?" -eq '0' ]; then
		delete_yaml_property "$f_" "$p_"
	fi
 	
 	echo "$p_: $v_" >> "$f_"

}


################################################################################
set_yaml_list_property() {
	# <file> <property> {<value0> <value1>...}

	process_yaml_file_parameter_ $@
 	
	if [ $# -lt 3 ]; then
 		error_and_exit_ "Should pass file, propertyname and values\n" 1
	fi	
 	
 	f_="$1"
 	shift
 	p_="$1"
 	shift
 	
 	(has_yaml_property "$f_" "$p_" 2> /dev/null)
	if [ "$?" -eq '0' ]; then
		delete_yaml_property "$f_" "$p_"
	fi
 	
 	# from now on it's all values
	v_='' 	
 	while [ $# -ne 0 ]; do
  		v_+=" - $1\n"
  		shift
  	done
  	# make sure we interpret \n's
  	# FIXME: this can have side effects with escaped chars in properties
	printf "$p_:\n$v_" >> "$f_"
	
}


################################################################################
has_yaml_property() {
	# <file> <property name>

	process_yaml_file_parameter_ $@

	if [ "$#" -lt '2' ]; then
 		error_and_exit_ "Should pass propertyname\n" 1
	fi

	p_="$2:"
	grep -q "$p_" "$f_"
	if [ "$?" -ne '0' ]; then
		error_and_exit_ "Property '$p_' not found ($?)\n" 1
	fi
	
	exit 0
	
}


################################################################################
is_singleline_() {
	# <file> <property name>
	
	f_="$1"
	property_oneline_expr_="$2:\ +"

	grep -q -E "$property_oneline_expr_" "$f_"
	if [ "$?" -eq '0' ]; then
		exit 0
	else
		exit 1
	fi
}


################################################################################
get_first_line_of_list_() {
	# <file> <list property name>

	f_="$1"
	property_="$2:"
	
	i_=$(grep -E -n "$property_" "$f_" | awk -F: '{print $1}')
	i_=$(($i_ + 1))
	echo -n "$i_"

}


################################################################################
get_yaml_property() {
	# <file> <property>
	
	(has_yaml_property $@)
	e_="$?"
	if [ "$e_" -ne '0' ]; then
		exit $e_
	fi
	
	f_="$1"
	p_="$2"

	$(is_singleline_ $@)
	if [ "$?" -eq '0' ]; then

		# single line, just echo the property
		property_="$p_:\ +"
		value_=$(grep -E "$property_" "$f_" | sed -r "s/$property_//")		
		echo -n "$value_"

	else
		# multiline, we tackle lists for now

		i_=$(get_first_line_of_list_ $@)
		is_list_=true
		value_=''
		list_expr_='^\ +\-\ +'
		
		while $is_list_; do
		
			# check if current line is still a list value and add to output accordingly
			line_=$(awk "FNR==$i_" "$f_")
			echo  "$line_" | grep -E -q "$list_expr_"
			if [ "$?" -eq '0' ]; then
				v_=$(echo "$line_" | sed -r "s/$list_expr_//")
				value_+=" $v_"
				i_=$(( $i_ + 1 ))		
			else
				is_list_=false
			fi
		done

		# we cut the first char as it's a space that has been added by the loop
		echo "$value_" |cut -c2-

	fi

}


################################################################################
delete_yaml_property() {

	(has_yaml_property $@)
	e_="$?"
	if [ "$e_" -ne '0' ]; then
		exit $e_
	fi

	f_="$1"
	p_="$2"

	$(is_singleline_ $@)
	if [ "$?" -eq '0' ]; then

		# single line, just delete the line
		property_="$p_:\ +"
		sed -r -i "/$property_/d" "$f_"

	else

		i_=$(get_first_line_of_list_ $@)
		is_list_=true
		list_expr_='^\ +\-\ +'
		
		while $is_list_; do
		
			# check if current line is still a list value and delete
			line_=$(awk "FNR==$i_" "$f_")
			echo  "$line_" | grep -E -q "$list_expr_"
			if [ "$?" -eq '0' ]; then
				sed -i "${i_}d" "$f_" 
				# notice we don't increment as number of lines has decreased :)
			else
				is_list_=false
			fi
		done
		
		# delete list variable name
		property_="$p_:$"
		sed -r -i "/$property_/d" "$f_"
		
	fi

}


################################################################################
set_zookeeper_addresses() {
 	# <file> {address address ...}
 	f_="$1"
 	shift
	set_yaml_list_property "$f_" 'storm.zookeeper.servers' $@
}


################################################################################
set_nimbus_host() {
 	f_="$1"
 	shift
	set_yaml_property "$f_" 'nimbus.host' "$1"
}


################################################################################
set_supervisor_ports() {
 	# <file> {address address ...}
 	f_="$1"
 	shift
	set_yaml_list_property "$f_" 'supervisor.slots.ports' $@
}


zookeeper_=''
nimbus_=''
supervisors_=''
storm_yaml_='${storm.configfolder_}/storm.yaml'

while getopts "hzn:s" flag
do
  case $flag in
	h) print_usage_exit ;;
	z) zookeeper_='yes';;
	n) nimbus_='yes';;
	s) supervisor_='yes';;
	\?) echo "Invalid option: -$OPTARG (use -h for help)" >&2;;
  esac
done
shift $((OPTIND-1))

if [[ "$zookeeper_" == 'yes' ]]; then
	set_zookeeper_addresses "$storm_yaml_" $@

elif [[ "$nimbus_" == 'yes' ]]; then
		set_nimbus_host "$storm_yaml_" "$1"

elif [[ "$supervisor_" == 'yes' ]]; then
	set_supervisor_ports "$storm_yaml_" $@
	
fi

# fix for stupid vmware bug
