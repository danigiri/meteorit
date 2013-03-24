#!/bin/bash

cd '${project.build.directory}/${lua.name_}'


if [ -e src/luajit ]; then
	echo 'Lua already built, skipping'
	exit 0
fi

echo 'Starting lua build...'


echo 'Compiling:'
make amalg PREFIX=${lua.installfolder_} | pv -l -f -p -s 7 > ./make.output

# the make install script uses a prefix DESTDIR environment variable which we use to create a complete temp install
echo 'Installing:'
make install PREFIX=${lua.installfolder_} DESTDIR=${lua.tempfolder_} | pv -l -f -p -s 18 >> ./make.output
