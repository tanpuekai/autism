arg1 <- commandArgs(trailingOnly = TRUE)

tab1<-read.table(arg1[1],header=T)
#print(head(tab1))

tab2<-tab1[tab1$info<0.6,]

#print(head(tab2))
if(nrow(tab2)>0){
	for(i in 1:nrow(tab2)){
		cat(c(as.character(tab2$rs_id[i]),"\n"))
	}
}



