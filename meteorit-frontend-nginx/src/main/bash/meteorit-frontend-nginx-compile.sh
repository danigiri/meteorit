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

cd '${nginx.sourcefolder_}'
if [ -e objs/nginx ]; then
	echo 'Nginx already built, skipping'
	exit 0
fi

echo 'Starting nginx build...'


echo 'Configuring:'

# add LuaJIT environment
LUAJIT_LIB='${install.prefix_}/lj2/lib'
LUAJIT_INC='${install.prefix_}/lj2/include/luajit-2.0'

#if [ ! -d "$LUAJIT_LIB" || ! -d "$LUAJIT_INC" ]; then
#	echo "Please install the 'meteorit-frontend-lua' package and then build this"
#	exit 1
#fi

# we configure, taking care to add add the lua shared library to the binary lookup path (rpath)
./configure --prefix='${nginx.installfolder_}' 				 \
			--with-ld-opt="-Wl,-rpath,$LUAJIT_LIB" 			 \
			--add-module='${nginx-lua-module.sourcefolder_}' \
			--user='${nginx.username_}'						 \
			--group='${nginx.groupname_}' 					 \
			| pv -f -l -p -s 120 > ./configure.output

ERR_=$?
if [ $ERR_ -ne 0 ]; then
	echo "Error configuring, checkout 'configure.output'"
	exit $ERR_
fi
echo 'Compiling:'
make | pv -l -f -p -s 641 > ./make.output
ERR_=$?
if [ $ERR_ -ne 0 ]; then
	echo "Error running make, checkout 'make.output'"
	exit $ERR_
fi

# the make install script uses a prefix DESTDIR environment variable which we use to create a complete temp install
DESTDIR='${nginx.tempfolder_}' make install

echo 'Completed'

