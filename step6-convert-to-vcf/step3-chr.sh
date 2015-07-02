#!/bin/sh
#PBS -q default
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
#PBS -l walltime=148:30:00
#PBS -N Greetings
#PBS -j oe


cd $PBS_O_WORKDIR
echo `pwd`
 
##-- SCRIPT PARAMETER TO MODIFY--##
 

for i in `ls *.vcf`; 
do 
	echo $i;awk '{print $1}' $i| sed 's/23/X/g'> tmp.txt;
	sed -i 's/chr//g' tmp.txt;cut -d$'\t' $i-f2-> tmp2.txt;  
	paste tmp.txt tmp2.txt > mod-$i;
	gzip -v mod-$i; 
done
