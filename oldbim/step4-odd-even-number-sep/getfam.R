arg1<-commandArgs(trailingOnly = T)

fam<-read.table(arg1[1],stringsAsFactors=F,sep=" ")
print(arg1[1])
print(dim(fam))
ids<-fam[,2]

ids.double<-rep("",nrow(fam)*2)
ids.double[seq(1,length(ids.double),by=2)]<-ids
ids.double[seq(2,length(ids.double),by=2)]<-ids
ids.double<-c("I","id",ids.double)

res<-rbind(ids.double,ids.double)
print(dim(res))
write.table(res,file="ids.double.txt",quote=F,row.names=F,col.names=F)
