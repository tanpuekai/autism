#!/bin/bash
#PBS -q default
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
#PBS -l walltime=148:30:00
#PBS -N Greetings
#PBS -j oe

cd $PBS_O_WORKDIR
echo `pwd`



#sort -k 3 ../chr-1-X.rs.2010.txt -o ref-2010.txt
#sort -k 3 ../chr-1-X.rs.2014.txt -o ref-2014.txt




for i in `ls ../step2-b-correct-mis/*bim`
do
	echo $i
	root1=`echo $i|cut -d"." -f1-3`
	echo $root1
	root2=`echo $root1|cut -d"/" -f3,4|cut -d "-" -f2-`
	echo $root2
#	echo $root2|cut -d"-" -f3-10

	echo $root2.markers
#########
	sort -k 2 $root1.bim > A.txt

	join -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 2.1 2.2 2.3 2.4 2.5 -1 2 -2 3 A.txt ref-2010.txt> table-"$root2".txt
	Rscript sep-odd-even.R table-"$root2".txt
	sed -n 1~2p  table-"$root2".txt|cut -f2 > $root2.odd.markers
	sed -n 2~2p  table-"$root2".txt|cut -f2 > $root2.even.markers
	cut -f9-10 table-"$root2".txt > ref-"$root2".txt

#######
#	sed -n 2~2p $i > tmp.txt
done
