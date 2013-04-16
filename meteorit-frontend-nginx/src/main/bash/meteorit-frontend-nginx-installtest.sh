#/bin/bash

SHUNIT2_=/usr/share/shunit2/shunit2
NGINX_=${nginx.installfolder_}/sbin/nginx

[ ! -e "$SHUNIT2_" ] && exit 0

yum list installed ${artifactId} -q &>/dev/null 
[ -z $? ] && exit 0

host_='localhost'
port_='80'

while getopts "h:u:" flag; do
	case $flag in
		h) host_="$OPTARG";;
		u) url_="$OPTARG";;
	    \?) echo "Invalid option: -$OPTARG" >&2;;
	esac
done
shift $((OPTIND-1))

[ -z "$url_" ] && url_="http://$host_:$port_/"

testNginx() {

	assertTrue 'Nginx is not installed' "[ -e $NGINX_ ]"
	
	wget -q -O - "$url_" | grep 'Welcome to nginx!' -q
	assertEquals "Nginx is not answering ($url_)" 0 $?

}

testNginxRedis() {
	r_="$RANDOM"
	url2_="$url_/test?e=$r_"
	answer_=`wget -q -O - "$url2_"`
	assertEquals "Nginx does not answer to the test URL ($url2_)" 0 $?
	assertEquals "redis value isn't returned correctly" "OK$r_" "$answer_"
}


. $SHUNIT2_
