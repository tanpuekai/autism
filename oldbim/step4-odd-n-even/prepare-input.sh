#!/bin/bash

for i in `ls ../step3-tped/*.tped`
do
	echo $i
	root1=`echo $i|cut -d"." -f1-3`
	echo $root1
	root2=`echo $root1|cut -d"/" -f3,4`
	echo $root2
	echo $root2|cut -d"-" -f3-10

	cp $i .
	cp $root1.tfam .

	Rscript getfam.R $root1.tfam
#########
	cut -f2,5- -d" " $i > aut-$root2.in

	cnt=`cat aut-$root2.in|wc -l`
	echo $cnt
	for j in $(seq 1 $cnt); do echo "M"; done > M.txt
	paste -d " " M.txt aut-$root2.in > tmp.txt
	mv tmp.txt aut-$root2.in

	line 2 ids.double.txt > tmp.txt
	cat tmp.txt aut-$root2.in > aut-$root2.bgl
done
