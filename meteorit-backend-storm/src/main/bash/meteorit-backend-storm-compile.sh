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

[ -z USED_JAVA_HOME ] && USED_JAVA_HOME='/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64'
if [ ! -e "$USED_JAVA_HOME" ]; then
	echo "Please set 'USED_JAVA_HOME' env variable so JZMQ can be built"
	exit 1
fi

cd '${jzmq.sourcefolder_}'
if [ -e src/zmq.jar ]; then
	echo 'jzmq already built, skipping'
	exit 0
fi

echo 'Starting jzmq build...'


echo 'Configuring (1/2):'
chmod a+x -v autogen.sh
./autogen.sh | pv -f -l -p -s 24 > ./autogen.output
ERR_=$?
if [ $ERR_ -ne 0 ]; then
	echo "Error configuring (1/2), checkout 'autoreconf.output'"
	exit $ERR_
fi

echo 'Configuring (2/2):'
chmod a+x -v ./configure

# can't seem to locate the jni.h otherwise
JAVA_HOME="$USED_JAVA_HOME" ./configure --with-zeromq=/usr \
	| pv -f -l -p -s 103 > ./configure.output
ERR_=$?
if [ $ERR_ -ne 0 ]; then
	echo "Error configuring (2/2), checkout 'configure.output'"
	exit $ERR_
fi


make | pv -f -l -p -s 56 > ./make.output
ERR_=$?
if [ $ERR_ -ne 0 ]; then
	echo "Error running make, checkout 'make.output'"
	exit $ERR_
fi

DESTDIR='${jzmq.tempfolder_}' make install | pv -f -l -p -s 36 >> ./make.output

echo 'Completed'