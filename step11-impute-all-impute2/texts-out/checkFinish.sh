#!/bin/bash

cntDone=0
cntunDone=0
for i in `ls $1/*reeting*`
do
#	cntErr=`cat $i|grep rror|wc -l`
	cntHave=`cat $i|tail -n1|grep  Have|wc -l`
#	if [ $cntErr -gt 0 ]; then
#		echo -n $i
#		echo -n $'\t'
#		echo $cntErr
#	else 
	if [ $cntHave -eq 0 ]; then
		echo -n $i
		echo -n $'\t'
		echo $cntHave
		let cntunDone=cntunDone+1
	else 
		let cntDone=cntDone+1
	fi 
done
echo $cntDone jobs completed successfully
echo $cntunDone jobs completed unsuccessfully
