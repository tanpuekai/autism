#!/bin/bash

NUM=6;

case $NUM in
#        1) ids=111trios-660K ;;
        2) ids=157sporadics-94controls-370K ;;
 #       3) ids=278trios-370K ;;
        4) ids=49cases-660K ;;
        5) ids=980controls-610K ;;
	6) ids=merge-438-975 ;;
        *) echo "INVALID NUMBER!" ;;
esac
dir1=assoc/$ids
ext1=assoc
#ext1=logistic
echo doing $ids

for chr in {1..22}
do
	break
	echo $chr
	cat $dir1/$ids-chr$chr-seg*.$ext1|grep -v "NA"|grep "e-\|0\.000\|0\.00\|0\.0\|0\." > tmp.out0
	cat $dir1/$ids-chr$chr-seg*.$ext1|grep SNP|head -n 1 > tmp.header

	cat tmp.header tmp.out0 > $dir1/combine-chr$chr.$ext1
	Rscript remove-redun.R $dir1/combine-chr$chr.$ext1
	echo "sed -i 's/^0/$chr/g' $dir1/combine-chr$chr.$ext1"
	echo "sed -i 's/^0/$chr/g' $dir1/combine-chr$chr.$ext1"|sh
done

outfinal=final-assoc/final-imputed-$ids-all-chr.new.$ext1.assoc

cat $dir1/combine-chr{[1-9],??}.$ext1> $outfinal
#cat $dir1/combine-chr[6-7].$ext1> $outfinal
cat $outfinal |grep SNP|head -n 1 > tmp.a
cat $outfinal |grep -v SNP > tmp.b
cat tmp.a tmp.b > $outfinal

exit

#cat outgwas/combine-$ids-chr?.assoc|grep CHISQ|head -n 1
#cat outgwas/combine-$ids-chr?.assoc|grep CHISQ|head -n 1 >outgwas/combine-$ids-all.assoc
#cat outgwas/combine-$ids-chr?.assoc outgwas/combine-$ids-chr??.assoc|grep -v CHISQ |head
#cat outgwas/combine-$ids-chr?.assoc outgwas/combine-$ids-chr??.assoc|grep -v CHISQ >>outgwas/combine-$ids-all.assoc
#Rscript sort-com.R outgwas/combine-$ids-all.assoc  imputed-$ids.assoc

