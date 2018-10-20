#!/bin/bash

read -p "Provide region where security group to be deleted: " region
read -p "Provide security group name to be scaned in all region: " sg_name


echo "Running clean-up from previous execution"

#mv ../../../data/sg_list_backup.list ../../../data/sg_list_backup.list.$(date +%d%m%Y%S)

echo " "
echo "-----------------------------------------"
echo "		Starting delete of $sg_name in $region 	"
echo "-----------------------------------------"
aws ec2 describe-security-groups --group-names $sg_name --region $region --output text
aws ec2 describe-security-groups --group-names $sg_name --region $region --output text >>../../../data/sg_list_backup.list
read -p "Enter SG ID to be deleted : " sg_id
echo "Security Group with SG-ID $sg_id will be deleted"
read -p "Press enter to continue"

aws ec2 delete-security-group --group-id $sg_id --region $region

echo "-----------------------------------------"
echo "          Ending region delete of $sg_name in $region    "
echo "-----------------------------------------"
echo " "
