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
	source './meteorit-backend-storm-setup.sh'
}


setUp() {
	cat <<-EOF > "$yaml_"
	property0: valuea
	property1:
	 - valueb
	 - valuec
	property2: valuec
EOF
}

test_add_yaml_property() {

set -x

	err_=$(add_yaml_property)
	assertEquals 'No parameter given should die' "1" "$err_"

	err_=$(add_yaml_property 'NONEXISTANTFILE')
	assertEquals 'Nonexistant file should die' "1" "$err_"

set +x

}


. $SHUNIT2_