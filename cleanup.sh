!#/bin/bash 
##########################################################################################
####THIS SCRIPT IS FOR CLEANNING UP COMPLETE HDP STACKS FROM NODE ########################
########################RUN THIS SCRIPT WITH YOUR OWN RISK ###############################
##########################################################################################

echo "Stoping Ambari Server & Agent....... "
ambari-server stop
ambari-agent stop

echo "stoppng HDP components by finding PIDs" 

ps -ef | egrep 'ambari|java' | awk {print $2} >> pid.txt

for k in `pid.txt`
do
        kill -9 $k
done


echo "Uninstalling HDP components from node" 

for i in `cat service.txt` 
do 
	yum remove $i -y 

echo "Deleting users......" 
	userdel -r $i 

echo "Deleting hdp stack files........" 

        find /var/* -name $i >> dir.txt
        find /usr/* -name $i >> dir.txt
        find /etc/* -name $i >> dir.txt
        find /tmp/* -name $i >> dir.txt
        find /mnt/* -name $i >> dir.txt
        find /sbin/* -name $i >> dir.txt
        find /bin/* -name $i >> dir.txt

done
for j in `cat dir.txt`
do
        rm -rf $j
done

echo "Resettng ambari-server...."
ambari-server reset 


