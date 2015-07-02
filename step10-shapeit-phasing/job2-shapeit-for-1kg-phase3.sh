#!/bin/bash
#PBS -q default 
#PBS -l nodes=1:ppn=8
#PBS -l mem=20gb
#PBS -l walltime=63:30:00
#PBS -N Greetings
#PBS -j oe




cd $PBS_O_WORKDIR
echo `pwd`

for i in `ls ../step7-convert-to-vcf-for-1KG-2504/step7*.bim`
do
        echo $i
        root1=`echo $i|cut -d"/" -f3`
        root2=`echo $root1|cut -d"." -f1`
        echo $root2

	dir1=out-phase3/out-$root2
	if [ -d $dir1 ]; then
	        echo "File $dir1 exists.";
	else
        	mkdir $dir1
	        echo "File $dir1 does not exist, and has been created.";
	fi

	for chr in {1..22} X
	do
		flagX=""
		if [ $chr = "X" ]; then
			flagX="--chrX"
		fi

		root3=$root2-chr-$chr
		mapfile=../genetic_map_b37/genetic_map_chr"$chr"_combined_b37.txt
		/software/plink --noweb --bfile ../step7-convert-to-vcf-for-1KG-2504/$root2 --chr $chr --recode --out $dir1/$root3
#	        cut $dir1/$root3.map -f1-4 > $dir1/$root3.map2
		shapeit --input-ped $dir1/$root3.ped $dir1/$root3.map \
        		-M $mapfile \
	        	-O $dir1/$root3.phased \
			-T 8 $flagX\
			--output-log $dir1/log-chr$chr.log
	done
done

