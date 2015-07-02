#!/bin/bash
#PBS -q default
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=63:30:00
#PBS -N Greetings
#PBS -j oe


cd $PBS_O_WORKDIR
cd /psychipc01/disk1/users/pkchen/autism_b37_pstrnd/pca-analysis
echo `pwd`

RefFile="/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step6-convert-to-vcf/B.txt"
outdir=all-plink-files-after-pruning

file1="/psychipc01/disk1/users/pkchen/hapmap/unique-hapmap"
file2="../step6-convert-to-vcf/step6-b37-111trios-660K"
file3="../step6-convert-to-vcf/step6-b37-157sporadics-94controls-370K"
file4="../step6-convert-to-vcf/step6-b37-278trios-370K"
file5="../step6-convert-to-vcf/step6-b37-49cases-660K"
file6="../step6-convert-to-vcf/step6-b37-980controls-610K"

file7="/psychipc01/disk1/users/pkchen/hapmap/unique-hapmap-EAsian"
file8="/psychipc01/disk1/users/pkchen/hapmap/unique-hapmap-Chinese"

if [ "a" = "b" ]; then
	/software/plink --noweb --bfile $file1 --exclude kept-out.missnp --reference-allele $RefFile --make-bed --out $outdir/tmp-hapmap 
	/software/plink --noweb --bfile $file7 --exclude kept-out.missnp --reference-allele $RefFile --make-bed --out $outdir/tmp-hapmap-ea 
#	cat  $file2.bim|grep rs6687776
fi
if [ "a" = "b" ]; then
	/software/plink --noweb --bfile $file8 --exclude kept-out.missnp --reference-allele $RefFile --make-bed --out $outdir/tmp-hapmap-chinese
fi
if [ "a" = "b" ]; then
	/software/plink --noweb --bfile $file2 --reference-allele $RefFile --make-bed --out $outdir/tmp-111trios
	/software/plink --noweb --bfile $file3 --reference-allele $RefFile --make-bed --out $outdir/tmp-157-94 
	/software/plink --noweb --bfile $file4 --reference-allele $RefFile --make-bed --out $outdir/tmp-278trios
	/software/plink --noweb --bfile $file5 --reference-allele $RefFile --make-bed --out $outdir/tmp-49cases
	/software/plink --noweb --bfile $file6 --reference-allele $RefFile --make-bed --out $outdir/tmp-980controls
fi

new1=$outdir/tmp-hapmap
new2=$outdir/tmp-hapmap-ea
new3=$outdir/tmp-111trios
new4=$outdir/tmp-hapmap-chinese

if [ "a" = "b" ]; then
	/software/plink --noweb --bfile $new1 --filter-founders --geno 0.05  --make-bed --out $outdir/hapmap-only-founders

	/software/plink --noweb --bfile $new1 --merge-list all-aut.txt --geno 0.05 --make-bed --out $outdir/hapmap-n-aut
	/software/plink --noweb --bfile $outdir/hapmap-n-aut 	--filter-founders --geno 0.05 --make-bed --out $outdir/hapmap-n-aut-founders

	/software/plink --noweb --bfile $new2 --merge-list all-aut.txt --geno 0.05 --make-bed --out $outdir/EA-hapmap-n-aut
	/software/plink --noweb --bfile $outdir/EA-hapmap-n-aut	--filter-founders --geno 0.05 --make-bed --out $outdir/EA-hapmap-n-aut-founders

	/software/plink --noweb --bfile $new3 --merge-list aut.only.txt --geno 0.05 --make-bed --out $outdir/aut-only
	/software/plink --noweb --bfile $outdir/aut-only  	--filter-founders --geno 0.05 --make-bed --out $outdir/aut-only-founders
fi

if [ "a" = "b" ]; then
	/software/plink --noweb --bfile $new4 --merge-list all-aut.txt --geno 0.05 --make-bed --out $outdir/chn-hapmap-n-aut
	/software/plink --noweb --bfile $outdir/chn-hapmap-n-aut --filter-founders --geno 0.05 --make-bed --out $outdir/chn-hapmap-n-aut-founders
fi


new5=$outdir/tmp-278trios
if [ "a" = "b" ]; then
	/software/plink --noweb --bfile $new3 --bmerge $new5.bed $new5.bim $new5.fam --maf 0.05 --geno 0.05 --make-bed --out $outdir/merge-trios-389
fi


if [ "a" = "a" ]; then
	echo $outdir/tmp-111trios-cases.bed $outdir/tmp-111trios-cases.bim $outdir/tmp-111trios-cases.fam > mergelist-438.txt
	echo $outdir/tmp-278trios-cases.bed $outdir/tmp-278trios-cases.bim $outdir/tmp-278trios-cases.fam >> mergelist-438.txt
	/software/plink --noweb --bfile $file2 --reference-allele $RefFile --filter-cases --make-bed --out $outdir/tmp-111trios-cases
	/software/plink --noweb --bfile $file4 --reference-allele $RefFile --filter-cases --make-bed --out $outdir/tmp-278trios-cases

	/software/plink --noweb --bfile $outdir/tmp-49cases --merge-list mergelist-438.txt --maf 0.05 --geno 0.05 --make-bed --out $outdir/tmp-merge-438-cases

	tobemerged="$outdir/tmp-980controls.bed $outdir/tmp-980controls.bim $outdir/tmp-980controls.fam"
	/software/plink --noweb --bfile $outdir/tmp-merge-438-cases --bmerge $tobemerged --maf 0.05 --geno 0.05 --make-bed --out $outdir/tmp-merge-438-975

fi


#.bed
#file2=/psychipc01/disk1/users/pkchen/hapmap/unique-hapmap.bim
#file3=/psychipc01/disk1/users/pkchen/hapmap/unique-hapmap.fam

#../step6-convert-to-vcf/step6-b37-157sporadics-94controls-370K 
#/software/plink --noweb --bfile tmp  --bmerge $file1 $file2 $file3  --recode --makebed --out merge-157-94-and-hapmap
#/software/plink --noweb --bfile tmp  --bmerge $file1 $file2 $file3  --recode --makebed --out merge-157-94-and-hapmap

#convertf -p par.PED.EIGENSTRAT
#mergeit -p par.merge
