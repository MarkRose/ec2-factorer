#!/bin/bash

# read for backup host name
source ~/.ec2-factorer.sh

# update mfloopy
cd ~/primetools
git reset --hard
git pull

# update ec2-factorer
cd ~/ec2-factorer
git reset --hard
git pull


# instance id for backup directory
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# instance type will determine number of GPUs to configure.
instance_type=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)

if [ "x$instance_type" == "xcg1.4xlarge" ] ; then last_card=1 ; else last_card=0 ; fi

# pull some work and start processing immediately
for i in $(seq 0 $last_card) ; do
~/ec2-factorer/fetch.sh ~/mfaktc$i
cd ~/mfaktc$i
screen -dmS mf$i ./mfaktc.exe -d $i 
done

# create crontab
cron=""
set -f
for i in $(seq 0 $last_card) ; do
cron="$cron
30 * * * * $HOME/ec2-factorer/fetch.sh $HOME/mfaktc$i
* * * * * rsync \"$HOME/mfaktc$i/{M*,results*,worktodo.txt}\" $BACKUP_HOST:mfaktc_backup/$INSTANCE_ID-$i/
"
done
echo "$cron" | crontab -
