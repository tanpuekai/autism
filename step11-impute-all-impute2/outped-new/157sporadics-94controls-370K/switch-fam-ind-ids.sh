#!/bin/bash

for i in `ls *.fam`
do
	echo $i
	awk '{print $2,$1,$3,$4,$5,$6}' $i > tmp.txt
	mv tmp.txt  $i
done
