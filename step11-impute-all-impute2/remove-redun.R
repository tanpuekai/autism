arg1 <- commandArgs(trailingOnly = TRUE)

all0<-read.table(arg1[1],header=T,stringsAsFactors=F)

snps<-all0[,2]

print(table(is.na(snps)))

unqsnps<-unique(snps[!is.na(snps)])
print(table(is.na(unqsnps)))
ind12<-match(unqsnps,snps)

all2<-all0[ind12,]
all3<-all2[order(all2[,3]),]
all4<-all3[all3$P<1&all3$P>1e-10,]
all5<-all4[all4$OR<6 & all4$OR > 1/6,]
all6<-all5[!is.na(all5[,3]),]
write.table(all6,file=arg1[1],quote=F,row.names=F,sep="\t")
