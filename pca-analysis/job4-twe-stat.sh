#!/bin/bash


NUM=9;

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

fn1=out/pca-$ids
fn2=twe-out/twe-$ids

twstats -t /home/pkchen/EIG6.0beta/POPGEN/twtable \
	-i $fn1.eval \
	-o $fn2.out 





