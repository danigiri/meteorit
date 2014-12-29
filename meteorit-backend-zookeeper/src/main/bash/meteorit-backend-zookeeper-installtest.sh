#!/usr/bin/env bash

#  Copyright 2014 Daniel Giribet <dani - calidos.cat>
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

ZK_CLIENT_=${zookeeper.installfolder_}/bin/cli_st
ZK_MTCLIENT_=${zookeeper.installfolder_}/bin/cli_mt

yum list installed ${project.artifactId} -q &>/dev/null 
[ -z $? ] && exit 1

host_='localhost'
port_='2181'

while getopts "h:p:u:" flag; do
	case $flag in
		h) host_="$OPTARG";;
		u) url_="$OPTARG";;
		p) port_="$OPTARG";;
	    \?) echo "Invalid option: -$OPTARG" >&2;;
	esac
done
shift $((OPTIND-1))

[ -z "$url_" ] && url_="$host_:$port_"

#@Test
testZookeeper() {

	assertTrue 'Zookeeper is not installed' `[ -e $ZK_CLIENT_ ]; echo $?`
	assertTrue 'Zookeeper (multithreaded client) is not installed' `[ -e $ZK_MTCLIENT_ ]; echo $?`

	echo 'ls /' | $ZK_CLIENT_ "$url_"  2>&1 | grep Socket -q
	assertEquals "Zookeeper is not answering ($url_)" 1 $?

	echo 'ls /' | $ZK_MTCLIENT_ "$url_"  2>&1 | grep Socket -q
	assertEquals "Zookeeper (multithreaded client) is not answering ($url_)" 1 $?

}

export PS_EXIT_ON_FAIL=1 
. ${meteorit.libs_}/provashell
