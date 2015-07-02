
args <- commandArgs(trailingOnly = TRUE)
fnfam<-args[1]

print(fnfam)
fam<-read.table(fnfam,sep=" ")

nlines<-nrow(fam)
famnames<-unique(as.character(fam[,1]))
print(famnames[1:10])
nfam<-length(famnames)
print(nfam)

intfam<-ceiling(nfam/3)
for(i in 1:3){
	from<- (i-1)*intfam+1
	to<-min(i*intfam,nfam)
	indfromto<-seq(from,to)
	namei<-famnames[indfromto]
	print(indfromto)
	print(namei)
	fami<-fam[fam[,1]%in%namei,]
	write.table(fami,file=paste("fami-",i,".fam",sep=""),quote=F,row.names=F,col.names=F)
}

