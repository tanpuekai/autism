#!/bin/bash
#PBS -q default
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
#PBS -l walltime=148:30:00
#PBS -N Greetings
#PBS -j oe

cd $PBS_O_WORKDIR
echo `pwd`


linkp="/software/plink --noweb --bfile"
pseq="/home/pkchen/plinkseq/pseq"

#sort -k 3 ../chr-1-X.rs.2010.txt -o ref-2010.txt
#sort -k 3 ../chr-1-X.rs.2014.txt -o ref-2014.txt


for i in `ls ../step2-b-correct-mis/*bim`
do
        echo $i
        root1=`echo $i|cut -d"." -f1-3`
        echo $root1
        root2=`echo $root1|cut -d"/" -f3,4|cut -d "-" -f2-`
        echo $root2

	REF_ALLELE_FILE=../step3-sep-markers/ref-$root2.txt
	NEWPLINKFILE=step4-$root2
	PLINKSEQ_PROJECT=project-$root2
	EXTRACT=../step3-sep-markers/"$root2".odd.markers

	echo $REF_ALLELE_FILE
	echo $NEWPLINKFILE
	echo $PLINKSEQ_PROJECT
	echo $EXTRACT


	$linkp $root1 --reference-allele $REF_ALLELE_FILE --extract $EXTRACT --make-bed --out step4-$root2
	$pseq $PLINKSEQ_PROJECT new-project
	$pseq $PLINKSEQ_PROJECT load-plink --file $NEWPLINKFILE --id $NEWPLINKFILE
	$pseq $PLINKSEQ_PROJECT write-vcf | gzip > $NEWPLINKFILE.vcf.gz

done

