#!/bin/bash

AMI_ID= "ami-0220d79f3f480ecf5" 
ZONE_ID= "Z01842473AEAVYOAVFX3C" #  replace with zone ID 
DOMAIN_NAME="daws80s.space" # replace with your domain name

for instance in $@
do
    echo "Launching instance: $instance"
    INSTANCE_ID=$(aws ec2 run-instances \
    --image-id ami-0220d79f3f480ecfs \
    --instance-type t3.micro \
    --security-groups "roboshop-common" "roboshop-$instance" \
    --tags-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=roboshop-$instance}]'\
    --query 'Instance[0].InstanceId' \
    --output text
    )
    echo "Instance ID:$INSTANCE_ID"

    if  [ $instance == " frontend " ]; then
         IP=$(aws ec2 describe-instance --instance-ids $INSTANCE_ID \ 
          --query 'Resevations[*].Instance[*].publicIpAddress' \
          --output text
        )   
    else     R53_RECORD="$DOMAIN_NAME"

        IP=$(aws ec2 describe-instance --instance-ids $INSTANCE_ID \
         --query 'resevations[*]. Instance[*].privateIpAddress' \
         --output text
    ) R53_RECORD="$instance.$DOMAINE_NAME"
    
    fi

    #### Updating R53 Record ####
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
        {

             "Comment": "Update A record to new IP",
             "Changes": [
                 {
                     "Action": "UPSERT",
                     "ResourceRecordSet": {
                          "Name": "$R53_RECORD",
                          "Type": "A",
                          "TTL": 1,
                          "ResourceRecords": [
                              {
                                 "Value": "192.0.2.44"
                                }
                            ]
                        }
                    }
            }    ]
    .   }

done