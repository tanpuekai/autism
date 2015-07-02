#!/bin/bash

for i in `ls ../step2-b-correct-mis/*.bed`
do
	echo $i
	root1=`echo $i|cut -d"." -f1-3`
	echo $root1
	root2=`echo $root1|cut -d"/" -f3,4`
	echo $root2
#	echo $root2|cut -d"-" -f2-10

	/software/plink --noweb --bfile $root1 --make-bed --transpose --exclude ../step2-b-correct-mis/triallelic-rs.txt --out $root2
#	/software/plink --noweb --bfile $root2 --recode --transpose --exclude ../step2-b-correct-mis/triallelic-rs.txt --out tped-$root2
#	cat $root2.bim | awk '{print $2,"\t",$4,"\t",$5,"\t",$6}' > tped-$root2.markers
	exit
done
