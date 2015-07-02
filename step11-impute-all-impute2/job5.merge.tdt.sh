#!/bin/bash
#PBS -q high_serial
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
#PBS -l walltime=63:30:00
#PBS -N J5reeting
#PBS -j oe
#PBS -t 1-22


cd $PBS_O_WORKDIR
cd /psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step11-impute-all-impute2
echo `pwd`

gtool=/home/pkchen/gtools/gtool

ids111=111trios-660K 
ids278=278trios-370K 

sampledir111=/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step10-shapeit-phasing/out-step6-b37-$ids111
sampledir278=/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step10-shapeit-phasing/out-step6-b37-$ids278


if [ -d assoc/merge-111-278 ]; then
        echo "Directory assoc/merge-111-278 exists.";
else
        mkdir assoc/merge-111-278 
        echo "Directory assoc/merge-111-278 was created.";
fi



for chr in $(seq $PBS_ARRAYID $PBS_ARRAYID) #{1..22}
#for chr in {1..3}
do
	sample111=$sampledir111/step6-b37-$ids111-chr-$chr.phased.sample
	sample278=$sampledir278/step6-b37-$ids278-chr-$chr.phased.sample

	for seg in {1..7}
	do
		echo $'\t' $'\t' doing $chr,$seg $'\t'
		prefix111=outped-new/$ids111/out-$ids111.chr$chr.seg$seg
		prefix278=outped-new/$ids278/out-$ids278.chr$chr.seg$seg

		if [ ! -f $prefix111.bed ]; then
			echo "$prefix111".bed does not exist
			continue
		fi

		xclsnp=temp/tmp-bim1-$PBS_JOBID.txt
		mergetarget=temp/merge-$PBS_JOBID
		rm $mergetarget* $xclsnp

		Rscript strand-n-dup.R $prefix111.bim $prefix278.bim $xclsnp

#		Rscript gen-dup.R $prefix111.bim temp/tmp-bim1-$PBS_JOBID.txt
#		Rscript gen-dup.R $prefix278.bim temp/tmp-bim2-$PBS_JOBID.txt
#		cat temp/tmp-bim1-$PBS_JOBID.txt temp/tmp-bim1-$PBS_JOBID.txt > temp/tmp-dup-$PBS_JOBID.txt
#		
#		/software/plink --noweb --bfile $prefix111 --bmerge $prefix278.bed $prefix278.bim $prefix278.fam --make-bed --out $mergetarget
#		cat $mergetarget.missnp>>temp/tmp-dup-$PBS_JOBID.txt

		if [ 1 = 1 ]; then
#			echo "******re-doing merging by excluding missnp*****"
			/software/plink --noweb --bfile $prefix111 --exclude $xclsnp --make-bed --out $mergetarget-111
			/software/plink --noweb --bfile $prefix278 --exclude $xclsnp --make-bed --out $mergetarget-278
			/software/plink --noweb --bfile $mergetarget-111 --bmerge $mergetarget-278.bed $mergetarget-278.bim $mergetarget-278.fam  --make-bed --out $mergetarget
		fi
#		Rscript updatefam.R $sample111 $sample278 $mergetarget.fam 

#		/software/plink --noweb --bfile $mergetarget --cluster --matrix --out $outgwas
#exit
		outgwas=assoc/merge-111-278/merge-111-278-chr$chr-seg$seg
		/software/plink --noweb --bfile $mergetarget --tdt --ci 0.95 --out $outgwas
		/software/plink --noweb --bfile $mergetarget --assoc --ci 0.95 --out $outgwas

		sedline $outgwas.tdt
		echo "sed -i 's/^0\t/$chr\t/g' $outgwas.tdt"
		echo "sed -i 's/^0\t/$chr\t/g' $outgwas.tdt" |sh

		sedline $outgwas.assoc
		echo "sed -i 's/^0\t/$chr\t/g' $outgwas.assoc"
		echo "sed -i 's/^0\t/$chr\t/g' $outgwas.assoc" |sh

		rm $mergetarget* $xclsnp
#	break
	done
#	break
done

