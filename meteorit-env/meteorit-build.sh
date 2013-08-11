#!/bin/bash

# setup and variables
[ -z "$MAVEN_URL" ] && MAVEN_URL='http://ftp.cixug.es/apache/maven/maven-3/3.1.0/binaries/apache-maven-3.1.0-bin.tar.gz'
[ -z "$MAVEN_FILE" ] && MAVEN_FILE='apache-maven.tar.gz'
[ -z "$PREFIX" ] && PREFIX='/opt'

MAVEN_INSTALL_FOLDER_="$PREFIX/apache-maven"


echo 'Installing development stuff...'

yum install -q -y wget

yum install -q -y gcc make pcre-devel zlib-devel
yum install -q -y rpm-build man shunit2 pv

yum install -q -y java-1.6.0-openjdk

echo 'Installing maven...'

wget -q "$MAVEN_URL" -O "$MAVEN_FILE"
if [ $? -ne 0 ]; then
	echo "Could not get maven ($?)"
	exit 1
fi

# Variable set to internal maven folder, contains version number, etc.
# 'apache-maven-3.1.0/boot/plexus-classworlds-2.4.2.jar' --> 'apache-maven-3.1.0'
MAVEN_FOLDER_=`tar tzf "$MAVEN_FILE" |head -1|awk -F '/' '{print $1}'`

tar xzf "$MAVEN_FILE"
rm -f "$MAVEN_FILE"

mkdir -p "$MAVEN_INSTALL_FOLDER_"
mv "$MAVEN_FOLDER_" "$MAVEN_INSTALL_FOLDER_"

export M2_HOME="$MAVEN_INSTALL_FOLDER_/$MAVEN_FOLDER_"
export M2="$M2_HOME/bin"
export PATH="$PATH:$M2"
 
[ -z "$JAVA_HOME" ] && export JAVA_HOME='/usr'
 
echo '************************************'
echo '*** Add this to your environment ***'
echo "export M2_HOME="$MAVEN_INSTALL_FOLDER_/$MAVEN_FOLDER_""
echo 'export M2="$M2_HOME/bin"
export PATH="$PATH:$M2"
export JAVA_HOME=/usr'
echo '************************************'
 
echo 'Installed development stuff.'