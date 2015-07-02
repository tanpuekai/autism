#!/bin/bash
#PBS -q high_serial 
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
#PBS -l walltime=63:30:00
#PBS -N J6reeting
#PBS -j oe
#PBS -t 1-22


cd $PBS_O_WORKDIR
cd /psychipc01/disk1/users/pkchen/autism_b37_pstrnd/step11-impute-all-impute2
echo `pwd`

gtool=/home/pkchen/gtools/gtool

ids111=111trios-660K 
ids278=278trios-370K 



if [ -d assoc/$ids111 ]; then
        echo "Directory assoc/$ids111 exists.";
else
        mkdir assoc/$ids111 
        echo "Directory assoc/$ids111 was created.";
fi


if [ -d assoc/$ids278 ]; then
        echo "Directory assoc/$ids278 exists.";
else
        mkdir assoc/$ids278 
        echo "Directory assoc/$ids278 was created.";
fi

for chr in  $(seq $PBS_ARRAYID $PBS_ARRAYID) #{1..22}
#for chr in  {1..1}
do
	for seg in {1..7}
	do
		for ids in {$ids111,$ids278}
		do
			echo doing: $chr, $seg, $ids
			prefix=outped-new/$ids/out-$ids.chr$chr.seg$seg

			if [ ! -f $prefix.fam ]; then
				echo "$prefix".fam does not exist
				continue
			fi

			outgwas=assoc/$ids/$ids-chr$chr-seg$seg
#			mergetarget=temp/tmp-abc$PBS_JOBID
		
#			rm $mergetarget.missnp


#			/software/plink --noweb --bfile $prefix --exclude  temp/tmp-bim-$PBS_JOBID.txt --make-bed --out $mergetarget
#			if [ -f $mergetarget.missnp ]; then
#				echo "******re-doing merging by excluding missnp*****"
#				/software/plink --noweb --bfile $prefix --exclude $mergetarget.missnp --make-bed --out $mergetarget
#			fi

			/software/plink --noweb --bfile $prefix --tdt --ci 0.95 --out $outgwas
			/software/plink --noweb --bfile $prefix --assoc --ci 0.95  --out $outgwas

			sedline $outgwas.tdt
			echo "sed -i 's/^0\t/$chr\t/g' $outgwas.tdt"
			echo "sed -i 's/^0\t/$chr\t/g' $outgwas.tdt" |sh

			sedline $outgwas.assoc
			echo "sed -i 's/^0\t/$chr\t/g' $outgwas.assoc"
			echo "sed -i 's/^0\t/$chr\t/g' $outgwas.assoc" |sh
		done
#		exit
#		break
	done
#	break
done

