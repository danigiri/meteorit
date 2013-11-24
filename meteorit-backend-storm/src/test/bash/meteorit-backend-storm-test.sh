#/bin/bash

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

SHUNIT2_=/usr/share/shunit2/shunit2


oneTimeSetUp() {
	workfolder_="$SHUNIT_TMPDIR"
	yaml_="$workfolder_/test.yaml"

	if [ "$#" -eq '1' ]; then
		# used for development
		source "$1"
	else
		source '${project.build.outputDirectory}/meteorit-backend-storm-setup.sh'
	fi

}


setUp() {
	# pwd is target
	cp test/test.yaml "$yaml_"

}

test_set_yaml_property() {

	$(set_yaml_property 2> /dev/null) 
	assertEquals 'No file parameter given, should die' '1' "$?"

	$(set_yaml_property 'NONEXISTANTFILE' 2> /dev/null)
	assertEquals 'Nonexistant file, should die' '1' "$?"

	$(set_yaml_property "$yaml_" 2> /dev/null)
	assertEquals 'No property specified, should die' '1' "$?"

	$(set_yaml_property "$yaml_" 'newproperty' 2> /dev/null)
	assertEquals 'Not found property, should die' '1' "$?"
	
	$(has_yaml_property "$yaml_" 'newproperty' 2> /dev/null)
	assertEquals 'Before adding the property, should die' '1' "$?"
	set_yaml_property "$yaml_" 'newproperty' '54321'
	$(has_yaml_property "$yaml_" 'newproperty')
	assertEquals 'Just added the property, should not die' '0' "$?"
	v_=$(get_yaml_property "$yaml_" 'newproperty')
	assertEquals 'Set property does not have correct value' '54321' "$v_"

	set_yaml_property "$yaml_" 'newproperty' '654321'
	v_=$(get_yaml_property "$yaml_" 'newproperty')
	assertEquals 'Resetted property does not have correct value' '654321' "$v_"
	
}


test_set_yaml_list_property() {

	$(set_yaml_list_property 2> /dev/null) 
	assertEquals 'No file parameter given, should die' '1' "$?"

	$(set_yaml_list_property 'NONEXISTANTFILE' 2> /dev/null)
	assertEquals 'Nonexistant file, should die' '1' "$?"

	$(set_yaml_list_property "$yaml_" 2> /dev/null)
	assertEquals 'No property specified, should die' '1' "$?"

	$(has_yaml_property "$yaml_" 'newproperty' 2> /dev/null)
	assertEquals 'Before adding the property, should die' '1' "$?"
	set_yaml_list_property "$yaml_" 'newproperty' '1' '2' '3'
	v_=$(get_yaml_property "$yaml_" 'newproperty')
	assertEquals 'List property is not recovered properly' '1 2 3' "$v_"

	set_yaml_list_property "$yaml_" 'newproperty' '1' '2' '3' '4'
	v_=$(get_yaml_property "$yaml_" 'newproperty')
	assertEquals 'List property is not resetted properly' '1 2 3 4' "$v_"

}


test_has_yaml_property() {

	$(has_yaml_property 2> /dev/null) 
	assertEquals 'No file parameter given, should die' '1' "$?"

	$(has_yaml_property 'NONEXISTANTFILE' 2> /dev/null)
	assertEquals 'Nonexistant file, should die' '1' "$?"

	$(has_yaml_property "$yaml_" 2> /dev/null)
	assertEquals 'No property specified, should die' '1' "$?"

	$(has_yaml_property "$yaml_" 'notfoundproperty' 2> /dev/null)
	assertEquals 'Not found property, should die' '1' "$?"
	
	$(has_yaml_property "$yaml_" 'value.text')
	assertEquals 'Existing property, should not die' '0' "$?"	

}


test_get_yaml_property() {

	$(get_yaml_property 2> /dev/null) 
	assertEquals 'No parameter given, should die' '1' "$?"

	$(get_yaml_property 'NONEXISTANTFILE' 2> /dev/null)
	assertEquals 'Nonexistant file, should die' '1' "$?"

	$(get_yaml_property "$yaml_" 2> /dev/null)
	assertEquals 'No property specified, should die' '1' "$?"

	$(get_yaml_property "$yaml_" 'notfoundproperty' 2> /dev/null)
	assertEquals 'Property does not exist, should die' '1' "$?"

	v_=$(get_yaml_property "$yaml_" 'value.text')
	assertEquals 'Text property is not recovered properly' '"foo"' "$v_"

	v_=$(get_yaml_property "$yaml_" 'value.int')
	assertEquals 'Numeric property is not recovered properly' '12345' "$v_"

	v_=$(get_yaml_property "$yaml_" 'value.list')
	assertEquals 'List property is not recovered properly' '1 2 3 4' "$v_"

}


test_delete_yaml_property() {

	$(delete_yaml_property 2> /dev/null) 
	assertEquals 'No parameter given, should die' '1' "$?"

	$(delete_yaml_property 'NONEXISTANTFILE' 2> /dev/null)
	assertEquals 'Nonexistant file, should die' '1' "$?"

	$(delete_yaml_property "$yaml_" 2> /dev/null)
	assertEquals 'No property specified, should die' '1' "$?"

	$(delete_yaml_property "$yaml_" 'notfoundproperty' 2> /dev/null)
	assertEquals 'Property does not exist, should die' '1' "$?"

	$(has_yaml_property "$yaml_" 'value.text')
	assertEquals 'Existing property before deletion, should not die' '0' "$?"
	delete_yaml_property "$yaml_" 'value.text'
	$(has_yaml_property "$yaml_" 'value.text'  2> /dev/null)
	assertEquals 'Deleted property, should die' '1' "$?"	
	v_=$(get_yaml_property "$yaml_" 'value.int')
	assertEquals 'It seems delete deleted more than expected' '12345' "$v_"

	delete_yaml_property "$yaml_" 'value.list'
	$(has_yaml_property "$yaml_" 'value.list'  2> /dev/null)
	assertEquals 'Deleted list property, should die' '1' "$?"
	v_=$(get_yaml_property "$yaml_" 'value.int')
	assertEquals 'It seems list delete deleted more than expected' '12345' "$v_"
		
}



. $SHUNIT2_

# fix for stupid vmware bug
