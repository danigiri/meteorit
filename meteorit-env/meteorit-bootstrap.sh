#!/bin/bash

echo 'Installing base stuff...'
# http://wiki.centos.org/AdditionalResources/Repositories/RPMForge
yum install -q -y wget
wget -q 'http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm' -O rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
rpm -K rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
if [ $? != 0 ]; then
	echo 'Could not verify rpmforge package'
	exit 1
fi
rpm -i rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm

yum install -q -y gcc