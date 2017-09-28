#!/bin/bash
#rundir='dirname $0'

###########################################################################################
#If the package from the path of PATH_UPDATE is newer than the package from PATH_OS,
#then copy the newer package to the PATH_OS.
#edit by tangzhongrui.
###########################################################################################

PATH_DCOS_UPDATE=/srv/www/mirror/bclinux/dcos/updates/x86_64/Packages
PATH_UPDATE=/srv/www/mirror/bclinux/el7.3/updates/x86_64/Packages
PATH_OS=/srv/www/mirror/bclinux/dcos
PATH_LOG=/opt/mirror/dcos
#PATH_LOG=/home/tangzhongrui/dcos_update/log
DATA=`date "+%F_%H-%M-%S"`

touch $PATH_LOG/$DATA.log

rpm -q rpmdevtools > /dev/null
if [ $? == 1 ]
then 	
	sudo yum -y install rpmdevtools
fi

count=0
for i in `cat $PATH_LOG/dcos1-376.txt`
do
	#echo -e "i=$i\n"
	k=$i
#================================== IN FOR =============================================
	for j in `ls $PATH_UPDATE | grep ${i%-*-*.rpm} | grep -v i686.rpm`	
	do
		#echo -e "j=$j\n"
		if test ${i%-*-*.rpm} = ${j%-*-*.rpm}
    		then			
			rpmdev-vercmp $j $k > /dev/null 
			if [ $? == 11 ] 
			then
				k=$j
				#[ ! -f $PATH_DCOS_UPDATE/$k ] && sudo cp $PATH_UPDATE/$k $PATH_DCOS_UPDATE/ && echo -e "Now $i can update to $k, COPY $PATH_UPDATE/$k TO $PATH_DCOS_UPDATE/\n" >> $PATH_LOG/$DATA.log
				if [ ! -f $PATH_DCOS_UPDATE/$k ]
				then
					cp $PATH_UPDATE/$k $PATH_DCOS_UPDATE/
					echo -e "Now $i can update to $k, COPY $PATH_UPDATE/$k TO $PATH_DCOS_UPDATE/\n" >> $PATH_LOG/$DATA.log				
					let count+=1
				fi
			fi
		fi
	done
#==================================END OF FOR=============================================	
done

if [[ $count -ne 0 ]]
then
	cd $PATH_DCOS_UPDATE/../
	createrepo ./
fi

echo -e "$DATA:Now $count newer packages have been added to the source of dcos successfully!\n"  >> $PATH_LOG/$DATA.log
mv $PATH_LOG/$DATA.log $PATH_LOG/$DATA+$count.log
