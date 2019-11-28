#!/bin/bash

REGION=${aws_region}
NFSVOLUME=${volume_id}
DEVICE=/dev/sdf
DIRECTORY=/mnt/nfs
INSTANCEID=$(curl -s "http://169.254.169.254/latest/meta-data/instance-id")

# wait until volume is available
n=0
until [ $n -ge 5 ]
do
   aws ec2 describe-volumes --volume-ids $NFSVOLUME  --region $REGION|grep -q available && break
   echo "waiting $NFSVOLUME to be available"
   ((n += 1))
   sleep 2
done

# if the volume is available
if aws ec2 describe-volumes --volume-ids $NFSVOLUME  --region $REGION|grep -qi available; then
  # attach the volume
  aws ec2 attach-volume --volume-id $NFSVOLUME --device $DEVICE --instance-id "$INSTANCEID" --region $REGION

  # wait until volume is attached
  n=0
  until [ $n -ge 5 ]
  do
     aws ec2 describe-volumes --volume-ids $NFSVOLUME  --region $REGION|grep -q attached && break
     echo "waiting $NFSVOLUME to be attached"
     ((n += 1))
     sleep 2
  done

  # if the volume is attached
  if aws ec2 describe-volumes --volume-ids $NFSVOLUME  --region $REGION|grep -q attached; then    

      # create directory it not created before, then mount
      if [ ! -d "$DIRECTORY" ]; then
        sudo mkdir $DIRECTORY
      fi
      sudo mount $DEVICE $DIRECTORY
      # check if .NFSMASTER file is present
      if [ -f "$DIRECTORY/.NFSMASTER" ]; then
        echo "$DEVICE is attached and mounted at $DIRECTORY"
        df -h $DIRECTORY
      else
        echo "A problem occurred, $DEVICE is not attached and/or couldn't be mounted  "
      fi

    else
        echo "A problem occurred, $NFSVOLUME is not attached"
    fi


else
    echo "A problem occurred, $NFSVOLUME is not available"
fi 

echo "/mnt/nfs *(rw,sync)" > /etc/exports
service nfs restart