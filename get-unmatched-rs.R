arg1 <- commandArgs(trailingOnly = TRUE)

#print(arg1[1])

com1<-read.csv(arg1[1],stringsAsFactors=F,sep="\t",header=F)
cat(c("\n\n numbers of matched and unmatched rs:",sum(com1[,9]=="")," vs. ",sum(com1[,9]!="")),"\n")

s1<-com1[,5]==com1[,10] & com1[,6]==com1[,11]
s2<-com1[,5]==com1[,11] & com1[,6]==com1[,10]
indf<-which(s1==F & s2 ==F)

table(s1,s2)
print(length(indf))

rs1<-com1[com1[,9]=="",2]
rs2<-com1[indf,2]
print(table(rs1%in%rs2))
print(setdiff(rs2,rs1)[1:30])

fn<-paste("excld-",arg1[1],sep="")
write.table(rs2,file=fn,quote=F,row.names=F,col.names=F)

#ref<-com1[com1[,9]!="",9:10]
#fn<-paste("ref-",arg1[1],sep="")
#write.table(ref,file=fn,quote=F,row.names=F,col.names=F)
