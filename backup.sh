#!/bin/bash

# read for backup host name
source ~/.ec2-factorer.sh

# instance id for backup directory
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

rsync -aq $1/{M*,results*,worktodo.txt} $BACKUP_HOST:mfaktc_backup/$instance_id-$2/
