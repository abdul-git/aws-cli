#!/bin/bash

read -p "Provide security group name to be scaned in all region: " sg_name

for region in `cat ../../../data/region_list`
do
echo " "
echo "-----------------------------------------"
echo "		Starting Scan for $region 	"
echo "-----------------------------------------"
aws ec2 describe-security-groups --group-names $sg_name --region $region
echo "-----------------------------------------"
echo "          Ending Scan for $region    "
echo "-----------------------------------------"
echo " "
done
