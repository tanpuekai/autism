arg1 <- commandArgs(trailingOnly = TRUE)

bim1<-read.table(arg1[1],stringsAsFactors=F)
dup<-names(which(table(bim1[,2])>1))
if(length(dup)>0){
	for(i in 1:length(dup)){
		cat(c(dup[i],"\n"))
	}
}
#write.table(dup,file=arg1[2],quote=F,row.names=F,col.names=F)
