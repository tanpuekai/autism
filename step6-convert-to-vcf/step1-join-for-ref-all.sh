#!/bin/bash


#sort -k 3,3 ref-allele-2010-11-23.txt > B.txt


for i in `ls *.bim`
do
	sort -k 2,2 $i > A.txt
	join -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 2.1 2.2 2.3 2.4 2.5 -1 2 -2 3 A.txt B.txt> table-"$i".txt
	Rscript ../get-unmatched-rs.R  table-"$i".txt 
	echo $i
done
