#!/bin/bash

source ../../../.env/set-formating

export AUD_RPT=sg_list_audit_report.list
export AUD_RPT_ALL=sg_list_audit_report_all.list
export AUD_RPT_USED=sg_list_audit_report_user.list
export AUD_DATA_DIR=../../../data
export AUD_RPT_BAK=sg_list_audit_report.list.$(date +%d%m%Y%S)

echo "Running clean-up from previous execution"

#mv ../../../data/sg_list_audit_report.list ../../../data/sg_list_audit_report.list.$(date +%d%m%Y%S)

mv ${AUD_DATA_DIR}/${AUD_RPT} ${AUD_DATA_DIR}/${AUD_RPT_BAK}

for region in `cat ../../../data/region_list`
do
echo " "
echo "-----------------------------------------"
echo "		Starting Scan for $region 	"
echo "-----------------------------------------"

echo " "
echo " "
echo "------------------------All security group for $region------------------------"
aws ec2 describe-security-groups --query 'SecurityGroups[*].{GroupName:GroupName,GroupId:GroupId}'  --region $region --output table |tr '\t' '\n'


echo "------------------------All security group for $region not in use------------------------"
aws ec2 describe-security-groups --query 'SecurityGroups[*].{GroupName:GroupName,GroupId:GroupId}'  --region $region --output text > ${AUD_DATA_DIR}/${AUD_RPT_ALL}
aws ec2 describe-instances --query 'Reservations[*].Instances[*].SecurityGroups[*].{GroupName:GroupName,GroupId:GroupId}'  --region $region --output table
aws ec2 describe-instances --query 'Reservations[*].Instances[*].SecurityGroups[*].GroupId'  --region $region --output text > ${AUD_DATA_DIR}/${AUD_RPT_USED}
echo "------------------------Comparing SG not in use in  $region------------------------"

echo " 
 
"  >> ${AUD_DATA_DIR}/${AUD_RPT}
echo " ----Region is $region-----" >>  ${AUD_DATA_DIR}/${AUD_RPT}
echo " 

" >> ${AUD_DATA_DIR}/${AUD_RPT}
comm -23  <(aws ec2 describe-security-groups --query 'SecurityGroups[*].{GroupName:GroupName,GroupId:GroupId,"VpcId":"VpcId"}'  --output table  --region ${region} | tr '\t' '\n'| sort) <(aws ec2 describe-instances --query 'Reservations[*].Instances[*].SecurityGroups[*].{GroupName:GroupName,GroupId:GroupId,"VpcId":"VpcId"}' --output table  --region ${region} | tr '\t' '\n' | sort | uniq) >> ${AUD_DATA_DIR}/${AUD_RPT}

echo "-----------------------------------------"
echo "          Ending Scan for $region    "
echo "-----------------------------------------"
echo " "
done


echo "Display Audit report"

cat ${AUD_DATA_DIR}/${AUD_RPT}
