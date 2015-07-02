#!/bin/bash
#PBS -q default
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=60:00:00
#PBS -N Greetings
#PBS -j oe

cd $PBS_O_WORKDIR
date

vcftools="$HOME/vcftools_0.1.12b/bin/vcftools"

#fam=step6-b37-278trios-370K
fam=step6-b37-980controls-610K

Rscript splitfam.R $fam.fam

rm tmp.vcf.gz
zcat mod-$fam.vcf.gz |sed 's/##fileformat=VCFv4.1[\t]##fileformat=VCFv4.1/##fileformat=VCFv4.1/g'> tmp.vcf
gzip tmp.vcf


cut fami-1.fam -d" " -f1 > tmp.fam
$vcftools  --gzvcf tmp.vcf.gz --keep tmp.fam --recode --stdout | gzip -c > split/$fam-1.vcf.gz

cut fami-2.fam -d" " -f1 > tmp.fam
$vcftools  --gzvcf tmp.vcf.gz --keep tmp.fam --recode --stdout | gzip -c > split/$fam-2.vcf.gz

cut fami-3.fam -d" " -f1 > tmp.fam
$vcftools  --gzvcf tmp.vcf.gz --keep tmp.fam --recode --stdout | gzip -c > split/$fam-3.vcf.gz
