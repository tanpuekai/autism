dir1<-dir(path = "../step1-remove-102snps",pattern=".bim")
print(dir1)

mis1<-read.table("../step2-a-check-strand/mis-by-1.txt",stringsAsFactors=F,sep="\t")
mis2<-read.table("../step2-a-check-strand/mis-by-2.txt",stringsAsFactors=F,sep="\t")
misp<-read.table("../step2-a-check-strand/mis-by-pos.txt",stringsAsFactors=F,sep="\t")

	print(mis1[1:5,])
	print(mis2[1:5,])
	print(misp[1:5,])

agtc<-c("A","G","T","C")
tcag<-c("T","C","A","G")

for(i in 1:length(dir1)){
	bim1<-read.table(paste( "../step1-remove-102snps/",dir1[i],sep=""),stringsAsFactors=F,sep="\t")
	indm2<-which(bim1[,2]%in%mis2[,3])
	str1<-bim1[indm2,5]
	str2<-bim1[indm2,6]

	str3<-tcag[match(str1,agtc)]
	str4<-tcag[match(str2,agtc)]

	bim1[indm2,5]<-str3
	bim1[indm2,6]<-str4

	indmp<-which(bim1[,2]%in%misp[,3])
	ind12<-match(bim1[indmp,2],misp[,3])
	bim1[indmp,4]<-bim1[indmp,4]+1

	write.table(bim1,file=dir1[i],quote=F,row.names=F,col.names=F,sep="\t")
}
