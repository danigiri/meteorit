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

echo 'Installing base stuff...'
# http://wiki.centos.org/AdditionalResources/Repositories/RPMForge
yum install -q -y wget

# 
wget -q 'http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm' -O rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
rpm -K rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
if [ $? != 0 ]; then
	echo 'Could not verify rpmforge package'
	exit 1
fi
rpm -i rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm

# epel repo
wget -q 'http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'
rpm --import https://fedoraproject.org/static/0608B895.txt
rpm -K epel-release-6-8.noarch.rpm
if [ $? != 0 ]; then
	echo 'Could not verify epel package'
	exit 1
fi
rpm -Uvh epel-release-6*.rpm

yum install -q -y java-1.6.0-openjdk pcre zlib 

# storm deps
yum install -q -y unzip libuuid libuuid-devel


# enable port 80
# rulepos=`/sbin/service iptables status | grep -P '\d+.*ACCEPT' | tail -1 | awk '{print $1}'`
# rulepos=$(( $rulepos + 1 ))
# iptables -I INPUT $rulepos -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
# /sbin/service iptables save
# /sbin/service iptables restart

# centos64.localdomain or whatever the name of the host is needs to resolve for logback
# to work on storm worker nodes