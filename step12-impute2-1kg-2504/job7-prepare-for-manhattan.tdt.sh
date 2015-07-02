#!/bin/bash

NUM=1;

case $NUM in
        1) ids=merge-111-278 ;;
	2) ids=111trios-660K ;;
	3) ids=278trios-370K ;;
        *) echo "INVALID NUMBER!" ;;
esac

dir1=assoc/$ids

ext1=assoc #tdt
ext1=tdt

for chr in {1..22}
do
#	break
	echo $chr
	cat $dir1/*-chr$chr-seg*.$ext1|grep -v "NA"|grep "e-\|0\.000\|0\.00\|0\.0\|0\." > tmp.out0
	cat $dir1/*-chr$chr-seg*.$ext1|grep CHISQ|head -n 1 > tmp.header

	cat tmp.header tmp.out0 > $dir1/combine-chr$chr.$ext1
	Rscript remove-redun.R $dir1/combine-chr$chr.$ext1
#	sedline tmp.out
#	cut -f 1 tmp.out > tmp.chr
#	echo "sed -i 's/0/$chr/g' tmp.chr"
#	echo "sed -i 's/0/$chr/g' tmp.chr"|sh
#	cut -f2- tmp.out > tmp.other
#	paste tmp.chr tmp.other > $dir1/combine-chr$chr.$ext1
done

outfinal=assoc/final-imputed-$ids-all-chr.new.$ext1.assoc

cat $dir1/combine-chr{[1-9],??}.$ext1> $outfinal
cat $outfinal |grep CHISQ|head -n 1 > tmp.a
cat $outfinal |grep -v CHISQ > tmp.b
cat tmp.a tmp.b > $outfinal

exit

#cat $dir1/combine-chr?.$ext1|grep CHISQ|head -n 1
#cat $dir1/combine-chr?.$ext1|grep CHISQ|head -n 1 >$dir1/combine-all-chr.$ext1
#cat $dir1/combine-chr?.$ext1 $dir1/combine-chr??.$ext1|grep -v CHISQ |head
#cat $dir1/combine-chr?.$ext1 $dir1/combine-chr??.$ext1|grep -v CHISQ >> $dir1/combine-all-chr.$ext1
#Rscript sort-com.R $dir1/combine-all-chr.$ext1  assoc/final-imputed-$ids-all-chr.$ext1.assoc

