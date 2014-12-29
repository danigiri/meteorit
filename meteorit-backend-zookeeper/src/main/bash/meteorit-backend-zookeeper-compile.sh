#!/bin/bash

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

# TODO: build complains about running libtool because of staged build

cd '${zookeeper.sourcefolder_}/src/c'
if [ -e cli_mt ]; then
	echo 'Zookeeper binary clients already built, skipping'
	exit 0
fi

echo 'Starting zookeeper clients build...'
echo 'Configuring (1/2):'
autoreconf -if | pv -f -l -p -s 5 > ./autoreconf.output
ERR_=$?
if [ $ERR_ -ne 0 ]; then
	echo "Error configuring (1/2), checkout 'autoreconf.output'"
	exit $ERR_
fi

echo 'Configuring (2/2):'
chmod a+x -v ./configure
./configure --prefix='${zookeeper.installfolder_}'\
	| pv -f -l -p -s 159 > ./configure.output
ERR_=$?
if [ $ERR_ -ne 0 ]; then
	echo "Error configuring (2/2), checkout 'configure.output'"
	exit $ERR_
fi

make | pv -f -l -p -s 116 > ./make.output
ERR_=$?
if [ $ERR_ -ne 0 ]; then
	echo "Error running make, checkout 'make.output'"
	exit $ERR_
fi

DESTDIR='${zookeeper.tempfolder_}' make install | pv -f -l -p -s 29 > ./make.output

echo 'Completed'
