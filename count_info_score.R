
info<-read.table("INFO.txt",sep="\t")
cat("\t")
cat(nrow(info))
cat("\t")
cat(sum(info[,1]>0.6))
cat("\t")
cat(sum(info[,1]>0.8))
cat("\t")
cat(quantile(info[,1]))
cat("\n")

