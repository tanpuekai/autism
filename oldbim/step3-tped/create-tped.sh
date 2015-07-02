#!/bin/bash
#PBS -q default
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=148:30:00
#PBS -N Greetings
#PBS -j oe
cd $PBS_O_WORKDIR
echo `pwd`


for i in `ls ../step2-b-correct-mis/*.bed`
do
	echo $i
	root1=`echo $i|cut -d"." -f1-3`
	echo $root1
	root2=`echo $root1|cut -d"/" -f3,4`
	echo $root2
#	echo $root2|cut -d"-" -f2-10

	/software/plink --noweb --bfile $root1 --make-bed --exclude ../step2-b-correct-mis/triallelic-rs.txt --out $root2
	/software/plink --noweb --bfile $root2 --recode --transpose --out tped-$root2
	cat $root2.bim | awk '{print $2,"\t",$4,"\t",$5,"\t",$6}' > tped-$root2.markers
done
