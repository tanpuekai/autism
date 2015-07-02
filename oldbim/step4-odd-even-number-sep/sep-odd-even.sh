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
	sed -n 1~2p $i > tmp.txt
	cut -f2,5- -d" " tmp.txt > oddnum-$root2.in

	cnt=`cat oddnum-$root2.in|wc -l`
	echo $cnt
	for j in $(seq 1 $cnt); do echo "M"; done > M.txt
	paste -d " " M.txt oddnum-$root2.in > tmp.txt
	mv tmp.txt oddnum-$root2.in

	line 2 ids.double.txt > tmp.txt
	cat tmp.txt oddnum-$root2.in > oddnum-$root2.bgl

#######
	sed -n 2~2p $i > tmp.txt
	cut -f2,5- -d" " tmp.txt > evennum-$root2.in

	cnt=`cat evennum-$root2.in|wc -l`
	echo $cnt
	for j in $(seq 1 $cnt); do echo "M"; done > M.txt
	paste -d " " M.txt evennum-$root2.in > tmp.txt
	mv tmp.txt evennum-$root2.in

	line 2 ids.double.txt > tmp.txt
	cat tmp.txt evennum-$root2.in > evennum-$root2.bgl
done
