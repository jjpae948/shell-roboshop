#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5" 
ZONE_ID="Z01842473AEAVYOAVFX3C" #  replace with  your zone ID 
DOMAIN_NAME="daws80s.space" # replace with your domain name
R= "\e[31m"
G= "\E[32m"
Y= "\e[33m"
N= "\e[0m"

### validation ###
if  [ $# -1t 2 ];then
    echo -e "$R ERROR:: Atleast 2 Arguments required $N"
    echo "USAGE: $0 [create/delete] [instance2...]"
    exit1
fi     