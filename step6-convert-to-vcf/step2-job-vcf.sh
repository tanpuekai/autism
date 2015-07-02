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
cnt=1
 
alias pseq='/home/pkchen/plinkseq/pseq'
for i in `ls step1*.bim`
do
	root1=`echo $i|cut -d"." -f1`	
	echo $root1
	root2=`echo $root1|cut -d "-" -f2-`
	echo $root2
	PLINKFILE=../step2-b-correct-mis/$root1
	REF_ALLELE_FILE=ref-table-$i.txt
	NEWPLINKFILE=step6-$root2
	PLINKSEQ_PROJECT=project-$root2
	EXCLUDE=excld-table-$i.txt

	echo $PLINKFILE
	echo $REF_ALLELE_FILE
	echo $NEWPLINKFILE
	echo $PLINKSEQ_PROJECT
	echo $EXCLUDE

	/software/plink --noweb --bfile $PLINKFILE --reference-allele $REF_ALLELE_FILE --exclude $EXCLUDE --make-bed --out $NEWPLINKFILE
	pseq $PLINKSEQ_PROJECT new-project
	pseq $PLINKSEQ_PROJECT load-plink --file $NEWPLINKFILE --id $NEWPLINKFILE
	pseq $PLINKSEQ_PROJECT write-vcf | gzip > $NEWPLINKFILE.vcf.gz

done

for i in `ls *.vcf`; 
do 
	echo $i;awk '{print $1}' $i| sed 's/23/X/g'> tmp.txt;
	sed -i 's/chr//g' tmp.txt;cut -d$'\t' $i-f2-> tmp2.txt;  
	paste tmp.txt tmp2.txt > mod-$i;gzip -v mod-$i; 
done
