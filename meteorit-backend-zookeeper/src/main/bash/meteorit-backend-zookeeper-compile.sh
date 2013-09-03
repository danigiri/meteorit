

cd ${mon.sourcefolder_}
make PREFIX=${mon.installfolder_} | \
pv -f -l -p -s 4 > ./make.output


ERR_=$?
if [ $ERR_ -ne 0 ]; then
	echo "Error running make, checkout 'make.output'"
	exit $ERR_
fi
