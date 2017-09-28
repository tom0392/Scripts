#!/bin/bash
#Place this shell script on the server 10.139.10.62 to run koji compile.

rundir=`dirname $0`
PATH_COMPILE=$rundir
DATA=`date "+%F_%H-%M-%S"`
touch $PATH_COMPILE/$DATA.log

for i in `cat $PATH_COMPILE/rpm.txt`
do
	koji add-pkg --owner=tangzhongrui bclinux7 pkg
	koji build bclinux7 $i
	#echo -e "koji build bclinux7 $i" >> $PATH_COMPILE/$DATA.log
	echo -e "Now Koji have finished the compiling of PKG $i\n" >> $PATH_COMPILE/$DATA.log
done
