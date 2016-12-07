#!/bin/bash
Time=$(date +%F-%H-%M-%S)
filename=tar_salt_srv_$Time.tar.gz
tar zcf $filename salt pillar
sz $filename 
sleep 1
find -type f -name "$filename" |xargs rm -f 
