#!/bin/bash

dir1=/psychipc01/disk1/users/pkchen/autism_b37_pstrnd/pca-analysis/convertFormatOutput

for i in `ls *pca`
do
	root1=`echo $i|cut -d"." -f1`
	echo $root1
	covfn=$root1.cov

	root2=`echo $root1|cut -d"-" -f2-`
	echo $root2

	indfile=$dir1/out-$root2.ind
	ls $indfile

	cnti=`cat $indfile |wc -l`

	for j in `ls ../../pca-analysis/all-plink-files-after-pruning/*[0-9]*fam`
	do
		cntj=`cat $j |wc -l`
		if [ $cnti -eq $cntj ]; then
			echo $j $'\t' $cntj

        		echo "C1 C2 C3 C4 C5 C6 C7 C8 C9 C10" > $covfn

	 		cat $i |sed 1,11d >> $covfn

			echo "FID IID"> famind.txt
			cut -d" " -f1-2 $j >> famind.txt

        		paste famind.txt $covfn > tmp.txt
	        	mv tmp.txt $covfn
	        	sedline $covfn
	        	sed -i 's/\t\t/\t/g' $covfn
			break
		fi
	done

done


