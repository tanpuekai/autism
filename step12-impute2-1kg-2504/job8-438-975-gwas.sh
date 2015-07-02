#!/bin/bash
#PBS -q high_serial 
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
#PBS -l walltime=63:30:00
#PBS -N J8reeting
#PBS -j oe
#PBS -t 1-22


cd $PBS_O_WORKDIR
cd /psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step12-impute2-1kg-2504
echo `pwd`

gtool=/home/pkchen/gtools/gtool

ids111=111trios-660K
ids278=278trios-370K 
ids49=49cases-660K
ids975=980controls-610K


sampledir111=/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step10-shapeit-phasing/out-phase3/out-step7-b37-$ids111
sampledir278=/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step10-shapeit-phasing/out-phase3/out-step7-b37-$ids278
RefFile="/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step7-convert-to-vcf-for-1KG-2504/B.txt"


if [ -d assoc/merge-438-975 ]; then
        echo "Directory assoc/merge-438-975 exists.";
else
        mkdir assoc/merge-111-278 
        echo "Directory assoc/merge-438-975 was created.";
fi



for chr in $(seq $PBS_ARRAYID $PBS_ARRAYID)
do
	sample111=$sampledir111/step7-b37-$ids111-chr-$chr.phased.sample
	sample278=$sampledir278/step7-b37-$ids278-chr-$chr.phased.sample

	for seg in {1..7}
	do
		echo doing $chr,$seg
		echo $'\n'

		prefix111=outped-new/$ids111/out-$ids111.chr$chr.seg$seg
		prefix278=outped-new/$ids278/out-$ids278.chr$chr.seg$seg
		prefix49=outped-new/$ids49/out-$ids49.chr$chr.seg$seg
		prefix975=outped-new/$ids975/out-$ids975.chr$chr.seg$seg

		if [ ! -f $prefix111.fam ]; then
			echo "$prefix111" .bed does not exist
			continue
		fi

		xcldsnp=temp/dup-$PBS_JOBID.txt
		Rscript strand-n-dup.R $prefix111.bim $prefix278.bim $prefix49.bim $prefix975.bim $xcldsnp
		outfix111=temp/out-$PBS_JOBID-111
		outfix278=temp/out-$PBS_JOBID-278
		outfix49=temp/out-$PBS_JOBID-49
		outfix975=temp/out-$PBS_JOBID-975

		/software/plink --noweb --bfile $prefix111 --reference-allele $RefFile 	--exclude $xcldsnp --filter-cases  --make-bed --out $outfix111
		/software/plink --noweb --bfile $prefix278 --reference-allele $RefFile  --exclude $xcldsnp --filter-cases --make-bed --out $outfix278
		/software/plink --noweb --bfile $prefix49 --reference-allele $RefFile  	--exclude $xcldsnp --filter-cases --make-bed --out $outfix49
		/software/plink --noweb --bfile $prefix975 --reference-allele $RefFile  --exclude $xcldsnp --make-bed --out $outfix975
		

		echo $outfix278.bed $outfix278.bim $outfix278.fam>temp/tmp-merge-list-$PBS_JOBID.txt
		echo $outfix49.bed $outfix49.bim $outfix49.fam>>temp/tmp-merge-list-$PBS_JOBID.txt
		mergecase="temp/tmp-2312321$PBS_JOBID-case"

		rm $mergecase.{bed,bim.fam}		
		/software/plink --noweb --bfile $outfix111 --merge-list temp/tmp-merge-list-$PBS_JOBID.txt  --maf 0.05 --geno 0.10 --filter-cases --make-bed --out $mergecase

		mergetarget="temp/tmp-2312321$PBS_JOBID"

		rm $mergetarget.{bed,bim.fam}
		/software/plink --noweb --bfile $mergecase --bmerge $outfix975.bed $outfix975.bim $outfix975.fam --maf 0.05 --geno 0.10 --make-bed --out $mergetarget

		outgwas=assoc/merge-438-975/merge-438-975-chr$chr-seg$seg
		/software/plink --noweb --bfile $mergetarget --assoc --ci 0.95 --out $outgwas 
		/software/plink --noweb --bfile $mergetarget --linear --covar covariate-files/pca-merge-438-975.cov --ci 0.95 --out $outgwas 

		sedline $outgwas.assoc
		echo "sed -i 's/^0\t/$chr\t/g' $outgwas.assoc"
		echo "sed -i 's/^0\t/$chr\t/g' $outgwas.assoc" |sh
#	break
	done
#	break
done

