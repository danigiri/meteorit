#!/usr/bin/env bash

# pwd is 'target' folder

mon_='${mon.sourcefolder_}/mon'
flag_file_=./FLAG


#@AfterScript
cleanup() {
	rm -f "$flag_file_"
}


#@Test
foo() {
	rm -f "$flag_file_"
	bash -c "$mon_ -a 1 'touch $flag_file_'" 2>/dev/null
	assertTrue "Mon does not run the error command" `[ -e "$flag_file_" ]; echo $?`
}


# execute tests and bail out on failure
export PS_EXIT_ON_FAIL=1 
. ${meteorit.libs_}/provashell
