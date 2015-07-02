#!/bin/bash
#PBS -q default
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=148:30:00
#PBS -N Greetings
#PBS -j oe


cd $PBS_O_WORKDIR
echo `pwd`


vcftools="$HOME/vcftools_0.1.12b/bin/vcftools"

for i in `ls -d ../step9-impute-all/out-b37-*`
do
	echo $i
	root1=`echo $i|cut -d"-" -f5-`
	echo $root1

	if [ -d $root1 ]; then
        	echo "File $root1 exists.";
	else
        	mkdir $root1
	        echo "File $root1 does not exist.";
	fi

	for j in `ls $i/*.vcf.gz`
	do
		echo $j
		root2=`echo $j|cut -d"/" -f4`
		root3=`echo $root2|cut -d"." -f1`
		echo $root3
		$vcftools --gzvcf $j --plink --out $root1/$root3
		/software/plink --noweb --file $root1/$root3 --recode --make-bed --out $root1/$root3
		rm $root1/$root3.map $root1/$root3.ped $root1/$root3.log $root1/$root3.nosex
	done
	
done
