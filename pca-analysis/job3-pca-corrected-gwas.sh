#!/bin/bash
#PBS -q default
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=63:30:00
#PBS -N Greetings 
#PBS -j oe


cd $PBS_O_WORKDIR
cd /psychipc01/disk1/users/pkchen/autism_b37_pstrnd/pca-analysis
#
echo `pwd`

#echo /software/plink --noweb --bfile ../step6-convert-to-vcf/step6-b37-157sporadics-94controls-370K --recode --out step6-b37-157sporadics-94controls-370K

fn1=out-hapmap
fn2=out/aut-only
smartpca.perl \
	-i $fn1.eigenstratgeno \
	-a $fn1.snp \
	-b $fn1.ind \
	k 4 \
	o $fn2.pca \
	p $fn2.plot \
	e $fn2.eval \
	l $fn2.log \
	m 5 \
	t 2 \
	s 6.0

#convertf -p par.PED.EIGENSTRAT
#parfile
