#!/bin/bash
#PBS -q default
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=63:30:00
#PBS -N Greetings
#PBS -j oe


cd $PBS_O_WORKDIR
echo `pwd`


#echo /software/plink --noweb --bfile ../step6-convert-to-vcf/step6-b37-157sporadics-94controls-370K --recode --out step6-b37-157sporadics-94controls-370K

NUM=14;

case $NUM in
	1) 	convertf -p par.PED.EIGENSTRAT.hapmap.only.founders ;;
	2) 	convertf -p par.PED.EIGENSTRAT.aut.hapmap.founders ;;
	3) 	convertf -p par.PED.EIGENSTRAT.aut.hapmap.EA.founders ;;
	4) 	convertf -p par.PED.EIGENSTRAT.hapmap.ea.only ;;
	5) 	convertf -p par.PED.EIGENSTRAT.aut.only.founders ;;
	6)	convertf -p par.PED.EIGENSTRAT.aut.hapmap.Chinese.founders ;;
	7)	convertf -p par.PED.EIGENSTRAT.hapmap.Chinese.only ;;

	8)	convertf -p parfiles-2/par.PED.EIGENSTRAT.157.94 ;;
	9) 	convertf -p par.PED.EIGENSTRAT.111 ;;
	10) 	convertf -p par.PED.EIGENSTRAT.111.raw ;;
	11) 	convertf -p par.PED.EIGENSTRAT.278 ;;
	12) 	convertf -p par.PED.EIGENSTRAT.278.raw ;;
	13) 	convertf -p parfiles-2/par.PED.EIGENSTRAT.merge.389 ;;
	14) 	convertf -p parfiles-2/par.PED.EIGENSTRAT.merge.438.975 ;;
	15) 	convertf -p par.PED.EIGENSTRAT.aut.hapmap.EA ;;
        *) echo "INVALID NUMBER!" ;;
esac

case $NUM in
	1) ids=hapmap-only-founders ;; #aut-n-hapmap ;;
	2) ids=aut-n-hapmap-founders;;
	3) ids=aut-n-hapmap-EA-founders;;
	4) ids=hapmap-EA;;
	5) ids=all-aut-founders;;
	6) ids=aut-n-hapmap-chn-founders;;
	7) ids=hapmap-chn-only;;

        8) ids=157-94 ;;
	9) ids=111 ;;
	10) ids=111-raw ;;
	11) ids=278 ;;
	12) ids=278-raw ;;
	13) ids=merge389 ;;
	14) ids=merge-438-975 ;;
	15) ids=aut-n-hapmap-EA;;
        *) echo "INVALID NUMBER!" ;;
esac

#mergeit -p par.merge
fn1=convertFormatOutput/out-$ids
fn2=out/pca-$ids

smartpca.perl \
	-i $fn1.eigenstratgeno \
	-a $fn1.snp \
	-b $fn1.ind \
	-k 10 \
	-o $fn2.pca \
	-p $fn2.plot \
	-e $fn2.eval \
	-l $fn2.log \
	-m 5 \
	-t 2 \
	-s 6.0 \




