#!/bin/bash
#PBS -q default 
#PBS -l nodes=1:ppn=8
#PBS -l mem=20gb
#PBS -l walltime=63:30:00
#PBS -N Greetings
#PBS -j oe




cd $PBS_O_WORKDIR
echo `pwd`

for i in `ls ../step6-convert-to-vcf/step6*.bim`
do
        echo $i
	if [ $i = "../step6-convert-to-vcf/step6-b37-980controls-610K.bim" ]; then
		continue
	fi
        root1=`echo $i|cut -d"/" -f3`
        root2=`echo $root1|cut -d"." -f1`
        echo $root2

	dir1=out-$root2
	if [ -d $dir1 ]; then
	        echo "File $dir1 exists.";
	else
        	mkdir $dir1
	        echo "File $dir1 does not exist, and has been created.";
	fi

	for chr in {X..X}
	do
		root3=$root2-chr-$chr
		mapfile=../genetic_map_b37/genetic_map_chr"$chr"_combined_b37.txt
		/software/plink --noweb --bfile ../step6-convert-to-vcf/$root2 --chr $chr --recode --out $dir1/$root3
	        cut $dir1/$root3.map -f1-4 > $dir1/$root3.map2
		shapeit --input-ped $dir1/$root3.ped $dir1/$root3.map2 \
        		-M $mapfile \
	        	-O $dir1/$root3.phased \
			-T 8 --chrX\
			--output-log $dir1/log-chr$chr.log
	done
done

