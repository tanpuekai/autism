#!/bin/bash
#PBS -q high_serial 
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
#PBS -l walltime=63:30:00
#PBS -N Jreeting
#PBS -j oe
#PBS -t 1-23

cd $PBS_O_WORKDIR
cd /psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step11-impute-all-impute2
echo `pwd`

gtool=/home/pkchen/gtools/gtool
NUM=1;

case $NUM in
        1) ids=111trios-660K ;;
#	2) ids=157sporadics-94controls-370K ;;
	3) ids=278trios-370K ;;
#	4) ids=49cases-660K ;;
#	5) ids=980controls-610K;;
        *) echo "INVALID NUMBER!" ;;
esac

sampledir=/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step10-shapeit-phasing/out-step6-b37-$ids
RefFile="/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step6-convert-to-vcf/B.txt"
#sampledir=/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step10-shapeit-phasing/out-step6-b37

echo $ids

if [ -d assoc/$ids ]; then
        echo "File assoc/$ids exists.";
else
        mkdir assoc/$ids
        echo "File assoc/$ids does not exist.";
fi


for chr in  $(seq $PBS_ARRAYID $PBS_ARRAYID) #{1..22}
do
	if [ $chr -eq 23 ]; then	
		chr=X
	fi

	sample=$sampledir/step6-b37-$ids-chr-$chr.phased.sample
	for seg in {1..7}
	do

		echo $'\n' $'\n' $'\n'  doing $chr, $seg $'\n'

		gunzip -v $ids/gwas.imputed.chr$chr.seg$seg.chunk?.gz
		gunzip -v $ids/gwas.imputed.chr$chr.seg$seg.chunk??.gz
		gunzip -v $ids/gwas.imputed.chr$chr.seg$seg.chunk*_info.gz

		cnt0=`find $ids -name "gwas.imputed.chr$chr.seg$seg.chunk?"|wc -l`
		cnt00=`find $ids -name "gwas.imputed.chr$chr.seg$seg.chunk??"|wc -l`
		let cnt=cnt0+cnt00
		echo gwas.imputed.chr$chr-seg$seg-chunk? $'\t' $cnt0 $cnt00 $cnt
		if [ $cnt -eq 0 ]; then
			echo  none
			continue
		fi

		chunktmp=temp/chunk-$PBS_JOBID.txt
		infotmp=temp/info-$PBS_JOBID.txt
		tmpfile=temp/tmp-$PBS_JOBID.txt
		if [ $cnt00 -gt 0 ]; then
			cat $ids/gwas.imputed.chr$chr.seg$seg.chunk{?,??} > $chunktmp
			cat $ids/gwas.imputed.chr$chr.seg$seg.chunk{?,??}_info > $infotmp
		else
			cat $ids/gwas.imputed.chr$chr.seg$seg.chunk? > $chunktmp
			cat $ids/gwas.imputed.chr$chr.seg$seg.chunk?_info > $infotmp
		fi

		outprefix=outped-new/$ids/out-$ids.chr$chr.seg$seg
		$gtool -G --g  $chunktmp --s $sampledir/step6-b37-$ids-chr-$chr.phased.sample --snp --ped $outprefix.ped --map $outprefix.map --phenotype plink_pheno --threshold 0.9


		exclsnps="temp/xclude-$PBS_JOBID.txt"
		Rscript gen-dup.R $outprefix.map >$exclsnps 

		head -n 1 $infotmp > $tmpfile
		cat $infotmp |grep -v info >> $tmpfile

		mv $tmpfile $infotmp 
		Rscript lowinfo.R $infotmp >> $exclsnps
		#cut -f2 $outprefix.map |grep -v "^rs" >> $exclsnps

		rm $outprefix.{bed,bim,fam}
		/software/plink --noweb --file  $outprefix --exclude $exclsnps --reference-allele $RefFile --missing-genotype N --make-bed --maf 0.05 --geno 0.05 --out $outprefix
		Rscript updatefam-sep.R $sample $outprefix.fam
		rm $outprefix.{ped,map}
		rm $exclsnps
		rm $chunktmp

		#outgwas=assoc/$ids/$ids-chr$chr-seg$seg
#		/software/plink --noweb --bfile  $outprefix --tdt --out $outgwas
		gzip -v $ids/gwas.imputed.chr$chr.seg$seg.chunk?
		gzip -v $ids/gwas.imputed.chr$chr.seg$seg.chunk??
		gzip -v $ids/gwas.imputed.chr$chr.seg$seg.chunk*_info
	done
done


