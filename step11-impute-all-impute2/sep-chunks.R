arg1 <- commandArgs(trailingOnly = TRUE)
print(arg1)

from<-as.numeric(arg1[2])
to<-as.numeric(arg1[3])+1
num<-as.numeric(arg1[4])

if(num%in%c(3,5)){
	Interval=1e6
}else{
	Interval=3e6
}


seq1<-round(seq(from,to,len=ceiling((to-from)/Interval+1)))
print(seq1)

start<-seq1[-length(seq1)]
end<- seq1[-1]-1

mat<-cbind(start,end)

print(mat)

write.table(mat,file=arg1[1],quote=F,row.names=F,col.names=F,sep="\t")
