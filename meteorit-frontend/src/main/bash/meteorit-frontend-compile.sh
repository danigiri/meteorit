#!/bin/bash

echo 'Starting lua build...'

cd '${project.build.directory}/${lua.name_}'
echo 'Compiling:'
make PREFIX=${lua.installfolder_} | pv -l -f -p -s 6 > ./make.output
echo 'Installing:'
make install PREFIX=${lua.tempfolder_} | pv -l -f -p -s 18 >> ./make.output
cd ${lua.tempfolder_}
find . -type d -exec mkdir -vp ${lua.tempfolder2_}/'{}' \; 

echo 'Starting nginx build...'

cd '${nginx.sourcefolder_}'
if [ -e objs/nginx ]; then
	echo 'Already compiled, skipping'
	exit 0
fi

echo 'Configuring:'
./configure --prefix='${nginx.installfolder_}' \
			--add-module='${redis2-module.sourcefolder_}/' \
			--user='${nginx.username_}'\
			--group='${nginx.groupname_}' | pv -f -l -p -s 115 > ./configure.output
ERR_=$?
if [ $ERR_ -ne 0 ]; then
	echo "Error configuring, checkout 'configure.output'"
	exit $ERR_
fi
echo 'Compiling:'
make | pv -l -f -p -s 461 > ./make.output
ERR_=$?
if [ $ERR_ -ne 0 ]; then
	echo "Error running make, checkout 'make.output'"
	exit $ERR_
fi

# the make install script uses a prefix DESTDIR environment variable which we use to create a complete temp install
DESTDIR='${nginx.tempfolder_}' make install

echo 'Modifying configuration...'
sed -i  -e 's/^#user.*nobody;/user ${nginx.username_};/' ${nginx.tempfolder_}/${nginx.installfolder_}/conf/nginx.conf

echo 'Completed'