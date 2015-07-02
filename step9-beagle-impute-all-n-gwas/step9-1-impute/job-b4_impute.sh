#!/bin/bash
#PBS -q default 
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=63:30:00
#PBS -N Qreetings-980-2-
#PBS -j oe
#PBS -t 56 


cd $PBS_O_WORKDIR
echo `pwd`

date
dirref="/psychipc01/disk1/users/pkchen/1000genome/release-20101123"

NUM=6;
part="b-"

case $NUM in
	1) target="../step6-convert-to-vcf/mod-step6-b37-111trios-660K.vcf.gz";;
	2) target="../step6-convert-to-vcf/mod-step6-b37-157sporadics-94controls-370K.vcf.gz";;
	3) target="../step6-convert-to-vcf/mod-step6-b37-278trios-370K.vcf.gz";;
	4) target="../step6-convert-to-vcf/mod-step6-b37-49cases-660K.vcf.gz";;
	5) target="../step6-convert-to-vcf/mod-step6-b37-980controls-610K.vcf.gz";;

	6) target="../step6-convert-to-vcf/split/step6-b37-980controls-610K-1.vcf.gz";;
	7) target="../step6-convert-to-vcf/split/step6-b37-980controls-610K-2.vcf.gz";;
	8) target="../step6-convert-to-vcf/split/step6-b37-980controls-610K-3.vcf.gz";;

	9) target="../step6-convert-to-vcf/split/step6-b37-278trios-370K-1.vcf.gz";;
	10) target="../step6-convert-to-vcf/split/step6-b37-278trios-370K-2.vcf.gz";;
	11) target="../step6-convert-to-vcf/split/step6-b37-278trios-370K-3.vcf.gz";;
	*) echo "INVALID NUMBER!" ;;
esac
case $NUM in
	1) outdir="b37-111trios-660K";;
	2) outdir="b37-157sporadics-94controls-370K";;
	3) outdir="b37-278trios-370K";;
	4) outdir="b37-49cases-660K";;
	5) outdir="b37-980controls-610K";;

	6) outdir="b37-980controls-610K-1";;
	7) outdir="b37-980controls-610K-2";;
	8) outdir="b37-980controls-610K-3";;

	9) outdir="b37-278trios-370K-1";;
	10) outdir="b37-278trios-370K-2";;
	11) outdir="b37-278trios-370K-3";;
	*) echo "INVALID NUMBER!" ;;
esac

echo $target
echo $outdir


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
fromto=`sed -n 1'{p;q;}' $dirfromto/from-to-$part$PBS_ARRAYID.txt`
chro=`sed -n 2'{p;q;}' $dirfromto/from-to-$part$PBS_ARRAYID.txt`
seg=`sed -n 3'{p;q;}' $dirfromto/from-to-$part$PBS_ARRAYID.txt`

echo $fromto
echo $chro
echo $seg

java -Xmx2000m -jar b4.r1274.jar ref=$dirref/chr-$chro-maf0.01.vcf.gz gt=$target chrom=$fromto out=out-$outdir/chr$chro-seg$seg.ref

date


