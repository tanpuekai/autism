arg0 <- commandArgs(trailingOnly = TRUE)

arg1<-arg0[-length(arg0)]
fn<-arg0[length(arg0)]

L1<-rep(list(0),length(arg1))
for(i in 1:length(L1)){
	bim1<-read.table(arg1[i],stringsAsFactors=F)
	L1[[i]]<-bim1
}

L2<-rep(list(0),length(L1))
for(i in 1:length(L2)){
	bim1<-L1[[i]]
	tab1<-which(table(bim1[,2])>1)
	n1<-names(tab1)
	L2[[i]]<-n1
}
dupgene<-unique(unlist(L2))
#print(dupgene)

L3<-list(0)
for(i in 1:(length(L1)-1)){
	bim1<-L1[[i]]
	bim1<-bim1[!bim1[,2]%in%dupgene,]
	for(j in (i+1):length(L1)){
		bim2<-L1[[j]]
		bim2<-bim1[!bim2[,2]%in%dupgene,]
#		print(bim1[1:5,])
#		print(bim2[1:5,])
		rs12<-intersect(bim1[,2],bim2[,2])

		ind12<-match(rs12,bim1[,2])
		ind22<-match(rs12,bim2[,2])
		mat<-bim1[ind12,]==bim2[ind22,]
		s1<-apply(mat,1,sum)
		inds1<-which(s1!=ncol(mat))
		L3[[length(L3)+1]]<-rs12[s1[inds1]]
	}
}
#print(unlist(L3))

dupgene<-unique(c(dupgene,unlist(L3)))

if(length(dupgene)>0){
	for(i in 1:length(dupgene)){
		cat(c(dupgene[i],"\n"))
	}
	write.table(dupgene,file=fn,quote=F,row.names=F,col.names=F)
}

