arg1<-commandArgs(trailingOnly = T)
fn<-paste("com-mark-",arg1[1],".txt",sep="")
print(fn)

com1<-read.csv(fn,stringsAsFactors=F,sep=" ",header=F)

str1<-com1[,5]
str2<-com1[,6]
str3<-com1[,8]
str4<-com1[,9]


ibs1<-((str1==str3)&(str2!=str4))|((str1!=str3)&(str2==str4))|((str2==str3)&(str1!=str4))|((str2!=str3)&(str1==str4))
ibs2<-((str1==str3)&(str2==str4))|((str2==str3)&(str1==str4))

ibs<-rep(0,nrow(com1))
ibs[ibs2]<-2
ibs[ibs1]<-1

indmis<- which(!is.na(com1[,7])&ibs==0)
#indmis<- which(com1[,7]!=com1[,4])
print(com1[indmis,])

