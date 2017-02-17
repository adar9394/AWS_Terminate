#!/bin/bash
time="$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"| jq .Reservations[].Instances[].LaunchTime)"
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" | jq .Reservations[].Instances[].InstanceId > id.txt
sed -i 's/"//g' id.txt
x=1
for i in "${!time[@]}" 
do
	t="${time[$i]}"
	di="$(sed -n "${x}p" id.txt)"
	m="$(date +%m)"
	d="$(date +%d)"
	h="$(date +%H)"
	hh=${t:12:2}
	
	dd=${t:9:2}
	
	((hhh=$h-$hh))
	
	if [ ${t:6:2} -lt $m ]; then
		aws ec2 terminate-instances --instance-ids $di
		echo "The following instance was terminated: "
		echo $di
	elif [ $dd -lt $d ]; then
		aws ec2 terminate-instances --instance-ids $di
		echo "The following instance was terminated: "
		echo $di
	elif [ $hhh -gt 11 ]; then
		aws ec2 terminate-instances --instance-ids $di
		echo "The following instance was terminated: "
		echo $di
	fi
	((x=x+1))
done


