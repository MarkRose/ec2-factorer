#!/bin/bash

# read credentials
. ~/.mfloopy_credentials.sh

~/primetools/mfloop.py -u $M_USER -p $M_PASS -U $G_USER -P $G_PASS -w $1 -t 0 -g 25 -e 74 -T dctf -o let_gpu72_decide
