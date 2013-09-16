#!/bin/bash

cd '${zookeeper.sourcefolder_}/src/c'
#if [ -e cli_mt ]; then
#	echo 'Zookeeper binary clients already built, skipping'
#	exit 0
#fi

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

DESTDIR='${zookeeper.tempfolder_}' make install | pv -f -l -p -s 29 >> ./make.output

echo 'Completed'