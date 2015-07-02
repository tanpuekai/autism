#!/bin/bash

for i in `ls ../step2-b-correct-mis/*.bim`
do
	echo $i
	root1=`echo $i|cut -d"." -f1-3|cut -d"/" -f3`
	echo $root1
	cat $i|awk '{print $2,"\t",$4,"\t",$5,"\t",$6}' > $root1.markers
done
