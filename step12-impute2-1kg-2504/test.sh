#!/bin/bash

while [ 1 = 1 ] 
do
	cnt=`showq |grep pkchen|wc -l`
	echo $cnt
	sleep 2s
	if [ $cnt -eq 0 ]; then
#		sed -i 's/NUM=3/NUM=5/g' job1-impute2.sh
		mv kreeting.o146869-* texts/278/ 
		qsub job1-impute2.sh
		echo done
		break
	fi
done
