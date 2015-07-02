arg1 <- commandArgs(trailingOnly = TRUE)

all<-read.table(arg1[1],header=T,stringsAsFactors=F)

for(i in 1:22){
	allchr<-all[all[,1]==i,]
	snps<-allchr[,2]
	ind12<-match(unique(snps),snps)
	all2<-allchr[ind12,]
	all3<-all2[order(all2[,3]),]
	if(i==1){allnew<-all3}else{
		allnew<-rbind(allnew,all3)
	}
}
allnew2<-allnew[allnew$P<0.1,]
write.table(allnew2,file=arg1[2],quote=F,row.names=F,sep="\t")
