#!/bin/bash
#PBS -q default
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=63:30:00
#PBS -N Ireetings-
#PBS -j oe


cd $PBS_O_WORKDIR
echo `pwd`


for j in `ls -d step9-impute-all/out-b37-*`
	do
	echo $j
	echo ""
	
	for i in `ls $j/*.vcf.gz`
	do
		zcat $i|cut -f8|grep -v "##"|grep -v INFO > INFO.txt
		sed -i 's/;/\t/g' INFO.txt
		sed -i 's/=/\t/g' INFO.txt
		cut -f2,4,6 INFO.txt >tmp.txt
		mv tmp.txt INFO.txt
		echo -n $i
		Rscript count_info_score.R 
	done
done
