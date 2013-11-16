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
	source '${project.build.outputDirectory}/meteorit-backend-storm-setup.sh'
}


setUp() {
	# pwd is target
	cp test/test.yaml "$yaml_"

}

test_add_yaml_property() {

	$(add_yaml_property) 
	assertEquals 'No file parameter given, should die' '1' "$?"

	$(add_yaml_property 'NONEXISTANTFILE')
	assertEquals 'Nonexistant file, should die' '1' "$?"

	$(add_yaml_property "$yaml_")
	assertEquals 'No property specified, should die' '1' "$?"

}


test_has_yaml_property() {

	$(has_yaml_property >&2 /dev/null) 
	assertEquals 'No file parameter given, should die' '1' "$?"

	$(has_yaml_property 'NONEXISTANTFILE' >&2 /dev/null)
	assertEquals 'Nonexistant file, should die' '1' "$?"

	$(has_yaml_property "$yaml_" >&2 /dev/null)
	assertEquals 'No property specified, should die' '1' "$?"

	$(has_yaml_property "$yaml_" 'notfoundproperty' >&2 /dev/null)
	assertEquals 'Not found property, should die' '1' "$?"
	
	$(has_yaml_property "$yaml_" 'atribute.text')
	assertEquals 'Existant property, should not die' '0' "$?"	
	
}

test_get_yaml_property() {

	$(get_yaml_property) 
	assertEquals 'No parameter given should die' '1' "$?"

	$(get_yaml_property 'NONEXISTANTFILE')
	assertEquals 'Nonexistant file should die' '1' "$?"

	$(get_yaml_property "$yaml_")
	assertEquals 'No property specified should die' '1' "$?"

	$(get_yaml_property "$yaml_" 'notfoundproperty')
	assertEquals 'No property should die' '1' "$?"

}

. $SHUNIT2_

# fix for stupid vmware bug
