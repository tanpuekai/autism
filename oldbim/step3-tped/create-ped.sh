#!/bin/bash
#PBS -q default
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=148:30:00
#PBS -N Greetings
#PBS -j oe
#cd $PBS_O_WORKDIR
echo `pwd`


for i in `ls *.bed`
do
        echo $i
        root1=`echo $i|cut -d"." -f1`
        echo $root1

	/software/plink --noweb --bfile $root1 --recode --out ped-$root1
	mv ped-* ped/
#        cat $root2.bim | awk '{print $2,"\t",$4,"\t",$5,"\t",$6}' > tped-$root2.markers

done

