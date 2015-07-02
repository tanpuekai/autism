#!/bin/bash

for i in `ls *.bed *.fam`
do
	root1=`echo $i|cut -d"-" -f 2-10`
	echo build37-$root1 $'\t' $i
	mv $i build37-$root1
done
