#!/bin/bash

source $1

BAT_IF_NAME=$(echo $1 |  sed 's/.*.\(bat.*\)\.conf/\1/')

BATCTL="batctl meshif $BAT_IF_NAME"

batctl meshif $BAT_IF_NAME if destroy 2>&1
batctl meshif $BAT_IF_NAME if create

for IF in ${MESH_INTERFACES[@]} ; do
        ip link set $IF down
        $BATCTL if add $IF
done


if [ ${#BRIDGE_NAME} -eq 0 ] ; then
        BRIDGE_NAME=${BAT_IF_NAME}-bridge
fi


if [[( ${#NON_MESH_INTERFACES[@]} -gt 0 || ENABLE_SEPERATE_BRIDGE )]] ; then

        MASTER_IF=$BRIDGE_NAME

        ip link add name $BRIDGE_NAME type bridge 2>&1
        ip link set $BRIDGE_NAME down
        ip link set dev $BAT_IF_NAME master $BRIDGE_NAME

        for IF in ${NON_MESH_INTERFACES[@]} ; do
                ip link set $IF down
                ip link set dev $IF master $BRIDGE_NAME
                ip link set $IF up
        done

else
        MASTER_IF=$BAT_IF_NAME
fi


for IP in ${IPS_FOR_BATMAN_INTERFACE[@]} ; do
        ip addr add $IP dev $MASTER_IF
done


ip link set $BAT_IF_NAME up

for IF in ${MESH_INTERFACES[@]} ; do
        ip link set $IF up
done


if [[( ${#NON_MESH_INTERFACES[@]} -gt 0  ||  ENABLE_SEPERATE_BRIDGE )]] ; then
        ip link set $BRIDGE_NAME up
fi

