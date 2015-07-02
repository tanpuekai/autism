#!/bin/bash

cd 157sporadics-94controls-370K

for i in `ls 157*.assoc.logistic`
do
	echo $i
	cat $i |grep "ADD\|OR" > tmp.txt
	mv tmp.txt $i
done
