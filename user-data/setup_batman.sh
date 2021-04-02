#!/bin/bash

CONFIG_DIR="/config/user-data/batman-adv"
LOGFILE="/var/log/user/batman_setup.log"

cd $CONFIG_DIR

touch $LOGFILE
echo '' > $LOGFILE
exec 1>> $LOGFILE 

md5sum -bc md5sums.txt

if [ $? -ne 0 ] ; then
        echo "Checksums did not match! ABORTING!" >&2
        exit -1
fi


lsmod | grep -wq "^libcrc32c"
if [ $? -ne 0 ] ; then
        echo "Loading kernel module libcrc32c.ko"
        insmod ${CONFIG_DIR}/libcrc32c.ko        
fi

lsmod | grep -wq "^batman_adv"
if [ $? -ne 0 ] ; then
        echo "Loading kernel module batman-adv.ko"
        insmod ${CONFIG_DIR}/batman-adv.ko
fi

cp ${CONFIG_DIR}/batctl /usr/sbin/

INTERFACES=$(ls ${CONFIG_DIR}/bat*.conf)

for IF in ${INTERFACES[@]} ; do
        ${CONFIG_DIR}/setup_if.sh $IF
done


