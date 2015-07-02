#!/bin/bash
#PBS -q default 
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=63:30:00
#PBS -N Greetings
#PBS -j oe
#PBS -t 117 


cd $PBS_O_WORKDIR
echo `pwd`


dirref="/psychipc01/disk1/users/pkchen/1000genome/release-20101123"
target="../../step6-convert-to-vcf/mod-step6-b37-111trios-660K.vcf.gz"
outdir="b37-111trios-660K"
#target="/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/"
dirfromto="/psychipc01/disk1/users/pkchen/1000genome/release-20101123/from-to"

FILE=out-$outdir
if [ -d $FILE ]; then    
	echo "File $FILE exists."; 
else    
	mkdir $FILE 
	echo "File $FILE does not exist."; 
fi

echo $PBS_ARRAYID
fromto=`sed -n 1'{p;q;}' $dirfromto/from-to-$PBS_ARRAYID.txt`
chro=`sed -n 2'{p;q;}' $dirfromto/from-to-$PBS_ARRAYID.txt`
seg=`sed -n 3'{p;q;}' $dirfromto/from-to-$PBS_ARRAYID.txt`

echo $fromto
echo $chro
echo $seg

java -Xmx2000m -jar ../b4.r1274.jar ref=$dirref/chr-$chro-maf0.01.vcf.gz gt=$target chrom=$fromto out=out-$outdir/chr$chro-seg$seg.ref




