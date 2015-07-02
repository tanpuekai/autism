#!/bin/bash
#PBS -q high_serial 
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
#PBS -l walltime=63:30:00
#PBS -N kreeting 
#PBS -j oe
#PBS -t 1-115


cd $PBS_O_WORKDIR
cd /psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step12-impute2-1kg-2504
echo `pwd`

date

NUM=5;

case $NUM in
        1) ids=111trios-660K ;;
	2) ids=157sporadics-94controls-370K ;;
	3) ids=278trios-370K ;;
	4) ids=49cases-660K ;;
	5) ids=980controls-610K;;
        *) echo "INVALID NUMBER!" ;;
esac

if [ -d $ids ]; then
        echo "File $ids exists.";
else
        mkdir $ids
        echo "File $ids does not exist.";
fi


dirfromto="/psychipc01/disk1/users/pkchen/1000genome/release-20101123/from-to"
fromto=`sed -n 1'{p;q;}' $dirfromto/from-to-$PBS_ARRAYID.txt`
chro=`sed -n 2'{p;q;}' $dirfromto/from-to-$PBS_ARRAYID.txt`
seg=`sed -n 3'{p;q;}' $dirfromto/from-to-$PBS_ARRAYID.txt`

from=`echo $fromto|cut -d":" -f2|cut -d"-" -f1`
to=`echo $fromto|cut -d":" -f2|cut -d"-" -f2`
echo $fromto $from $to
echo $chro
echo $seg

sampledir=/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step10-shapeit-phasing/out-phase3/out-step7-b37-$ids
samplefile=$sampledir/step7-b37-$ids-chr-$chro.phased.sample


XFlag=""
if [ $chro = "X" ]; then
	echo Have an X day!
	XFlag="-chrX -sample_g $samplefile "
fi

sourcehaps=/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step10-shapeit-phasing/out-phase3/out-step7-b37-$ids/step7-b37-$ids-chr-$chro.phased.haps
refhap=/psychipc01/disk1/users/pkchen/1000genome/release-2013-may-2/conversion-to-haps-legend/chr-"$chro"-maf0.01.impute.hap.gz
refleg=/psychipc01/disk1/users/pkchen/1000genome/release-2013-may-2/conversion-to-haps-legend/chr-"$chro"-maf0.01.impute.legend.gz
gmap=/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/genetic_map_b37/genetic_map_chr"$chro"_combined_b37.txt

UUID1=`cat /proc/sys/kernel/random/uuid`

Rscript ../step11-impute-all-impute2/sep-chunks.R "temp/tmp-$UUID1.txt" $from $to $NUM

chunk=1
while read line
do
	intfrom=`echo $line|cut -d" " -f1`
	intto=`echo $line|cut -d" " -f2`
	echo "Text read from file - $line"
	echo "from $intfrom to $intto"


#	let chunk=chunk+1
	outfile=$ids/gwas.imputed.chr$chro.seg$seg.chunk$chunk	
	impute2 -use_prephased_g \
	        -known_haps_g $sourcehaps \
        	-h $refhap \
	        -l $refleg \
        	-m  $gmap \
		-int $intfrom $intto \
        	-Ne 20000 $XFlag\
	        -o $outfile 

	let chunk=chunk+1
done < temp/tmp-$UUID1.txt

echo done 


