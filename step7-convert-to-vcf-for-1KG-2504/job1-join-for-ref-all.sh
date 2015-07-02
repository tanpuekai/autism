#!/bin/bash


#sort -k 3,3 /psychipc01/disk1/users/pkchen/1000genome/release-2013-may-2/ref-allele-2013-may-02.txt > B.txt


for i in `ls ../step2-b-correct-mis/step1-*980*.bim`
do
	echo $i
	root0=`echo $i|cut -d"/" -f3|cut -d "-" -f2-`
	echo $root0
	if [ "a" = "b" ]; then
		sort -k 2,2 $i > A.txt
		join -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 2.1 2.2 2.3 2.4 2.5 -1 2 -2 3 A.txt B.txt> table-"$root0".txt
		sedline  table-"$root0".txt
	fi
	cat table-"$root0".txt|grep rs > tmp.txt
	mv tmp.txt  table-"$root0".txt 
	Rscript ../get-unmatched-rs.R  table-"$root0".txt 
done
