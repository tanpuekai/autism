#!/bin/bash
#PBS -q high_serial 
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
#PBS -l walltime=63:30:00
#PBS -N Greetings
#PBS -j oe
#PBS -t 1-120


cd $PBS_O_WORKDIR
echo `pwd`


dirref="/psychipc01/disk1/users/pkchen/1000genome/release-20101123"
target="/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step4-extract-odd-to-vcf/step4-b37-157sporadics-94controls-370K.vcf.gz"
dirfromto="/psychipc01/disk1/users/pkchen/1000genome/release-20101123/from-to"

echo $PBS_ARRAYID

fromto=`sed -n 1'{p;q;}' $dirfromto/from-to-$PBS_ARRAYID.txt`
chro=`sed -n 2'{p;q;}' $dirfromto/from-to-$PBS_ARRAYID.txt`
seg=`sed -n 3'{p;q;}' $dirfromto/from-to-$PBS_ARRAYID.txt`

echo $fromto
echo $chro
echo $seg

java -Xmx2000m -jar b4.r1274.jar ref=$dirref/chr-$chro-maf0.01.vcf.gz gt=$target chrom=$fromto out=out-b4-157-94-odd/chr$chro-seg$seg.ref




