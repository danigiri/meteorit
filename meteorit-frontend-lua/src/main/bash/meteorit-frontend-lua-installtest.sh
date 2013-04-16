#/bin/bash -x

SHUNIT2_=/usr/share/shunit2/shunit2
LUA_=${lua.installfolder_}/bin/luajit

[ ! -e "$SHUNIT2_" ] && exit 0

yum list installed ${artifactId} -q &>/dev/null 
[ -z $? ] && exit 0

testLua() {

	hello_=`$LUA_ -e 'print("Hello World")'`
	assertEquals 'LUAJit does not work' 'Hello World' "$hello_"
	
}

. $SHUNIT2_
