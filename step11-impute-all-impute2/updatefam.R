arg1 <- commandArgs(trailingOnly = TRUE)

print(arg1)
sample1<-read.table(arg1[1],header=T,stringsAsFactors=F)
sample2<-read.table(arg1[2],header=T,stringsAsFactors=F)

fam1<-read.table(arg1[3],stringsAsFactors=F)

indv<-fam1[,1]
family<-fam1[,2]

fam1[,1]<-family
fam1[,2]<-indv

ind12<- match(indv,sample1[,2])
ind22<- match(indv,sample2[,2])

fam1[!is.na(ind12),3]<-sample1$father[ind12[!is.na(ind12)]]
fam1[!is.na(ind22),3]<-sample2$father[ind22[!is.na(ind22)]]

fam1[!is.na(ind12),4]<-sample1$mother[ind12[!is.na(ind12)]]
fam1[!is.na(ind22),4]<-sample2$mother[ind22[!is.na(ind22)]]

write.table(fam1,file=arg1[3],quote=F,row.names=F,col.names=F,sep="\t")
