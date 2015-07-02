#!/bin/bash
#PBS -q default 
#PBS -l nodes=1:ppn=8
#PBS -l mem=20gb
#PBS -l walltime=63:30:00
#PBS -N Greetings
#PBS -j oe




cd $PBS_O_WORKDIR
echo `pwd`

for i in `ls ../step6-convert-to-vcf/step6*157*.bim`
do
        echo $i
        root1=`echo $i|cut -d"/" -f3`
        root2=`echo $root1|cut -d"." -f1`
        echo $root2

	dir1=odd-even-$root2
	if [ -d $dir1 ]; then
	        echo "File $dir1 exists.";
	else
        	mkdir $dir1
	        echo "File $dir1 does not exist, and has been created.";
	fi

	extractDir=/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/
	sed -n 2~2p $i|cut -f2 > $dir1/evenMarkers.txt
	sed -n 1~2p $i|cut -f2 > $dir1/oddMarkers.txt

	for chr in {8..22}
	do
		root3=$root2-chr-$chr
		mapfile=genetic_map_b37/genetic_map_chr"$chr"_combined_b37.txt
		/software/plink --noweb --bfile ../step6-convert-to-vcf/$root2 --chr $chr --extract $dir1/evenMarkers.txt --recode --out $dir1/even-$root3
	        cut $dir1/$root3.map -f1-4 > $dir1/$root3.map2
		shapeit --input-ped $dir1/$root3.ped $dir1/$root3.map2 \
        		-M $mapfile \
	        	-O $dir1/$root3.phased \
			-T 8 \
			--output-log $dir1/log-chr$chr.log
	done
done

