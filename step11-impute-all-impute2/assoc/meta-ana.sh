#!/bin/bash

NUM=2;

case $NUM in
        1) /software/plink --noweb --meta-analysis final-imputed-157sporadics-94controls-370K-all-chr.new.assoc.assoc \
		final-imputed-111trios-660K-all-chr.new.tdt.assoc --out meta-157-94-vs-111 ;; 
        2) /software/plink --noweb --meta-analysis final-imputed-157sporadics-94controls-370K-all-chr.new.assoc.assoc \
		final-imputed-278trios-370K-all-chr.new.tdt.assoc --out meta-157-94-vs-278 ;;
        3) /software/plink --noweb --meta-analysis final-imputed-157sporadics-94controls-370K-all-chr.new.assoc.assoc \
		final-imputed-111trios-660K-all-chr.new.tdt.assoc \ 
		final-imputed-278trios-370K-all-chr.new.tdt.assoc --out meta-157-94-vs-111-278 ;;
        4) /software/plink --noweb --meta-analysis final-imputed-157sporadics-94controls-370K-all-chr.new.assoc.assoc \
		final-imputed-merge-438-975-all-chr.new.assoc.assoc --out meta-157-94-vs-438-975 ;;
        *) echo "INVALID NUMBER!" ;;
esac


