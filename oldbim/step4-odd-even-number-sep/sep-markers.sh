#!/bin/bash

for i in `ls ../step3-tped/*.markers`
do
	echo $i
	root1=`echo $i|cut -d"." -f1-3`
	echo $root1
	root2=`echo $root1|cut -d"/" -f3,4`
	echo $root2
#	echo $root2|cut -d"-" -f3-10

	echo $root2.markers
#########
	sed -n 1~2p $i > oddnum-$root2.markers
	sed -n 2~2p $i > evennum-$root2.markers


#######
#	sed -n 2~2p $i > tmp.txt
done
