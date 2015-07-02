#!/bin/bash
#PBS -q default
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
#PBS -l walltime=148:30:00
#PBS -N Greetings
#PBS -j oe


cd $PBS_O_WORKDIR
echo `pwd`

#fn=`ls ../step1-remove-102snps/*.bim`
fn=`ls ../step2-b-correct-mis/*.bim`

files=($fn)
len1=${#files[@]}


for k in {0..4}
do

	fnk=${files[$k]}
	echo "****************"
	echo "fnk="$fnk
	echo "****************"

	awk -F "/" '{print "chr"$1}'  $fnk> bim.txt

	cnt=1

	
	for i in $(seq 1 22)
	do
		cat bim.txt |grep "chr$i"$'\t' >tmp.txt
		sort -k 2,2 tmp.txt > A.txt

		cat ../../beagle/1000genome-ref/ALL.chr"$i".phase1_release_v3.20101123.filt.markers|grep rs> tmp2.txt
	
		sort tmp2.txt > B.txt

		join -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 2.2 2.3 2.4 2.5 -1 2 -2 1 A.txt B.txt> com-mark-"$i".txt
		Rscript miss-strand.R $i
#	while read line
#	do
#		let cnt=cnt+1
#		name=$line
#		cat tmp.markers|grep $line >> commark-chr$i.txt
#		if [ $(($cnt % 500)) == 0 ]; then
#			echo chr$i $'\t' $cnt
#		fi
#	done < tmp2.txt
	done
	echo $cnt
done
#ALL.chr22.phase1_release_v3.20101123.filt.markers
