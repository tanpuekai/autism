arg1 <- commandArgs(trailingOnly = TRUE)

tab1<-read.table(arg1[1],stringsAsFactors=F,sep=" ")
tab2<-tab1[!is.na(tab1$V8),]
str1<-tab2[,5]==tab2[,10] & tab2[,6]==tab2[,11]
str2<-tab2[,5]==tab2[,11]&tab2[,6]==tab2[,10]
table(str1,str2)
table(str1==F & str2==F)

tab3<-tab2[str1==T| str2==T,]
print(dim(tab3))

write.table(tab3,file=arg1[1],quote=F,row.names=F,col.names=F,sep="\t")
