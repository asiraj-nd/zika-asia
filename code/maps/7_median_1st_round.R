#.libPaths("/afs/crc.nd.edu/user/a/asiraj/R/gdal")
library(rgdal)
.libPaths("/afs/crc.nd.edu/user/a/asiraj/raster")
library(raster)
setwd("/afs/crc.nd.edu/user/a/asiraj/zika/code/maps")
source("0_numfunctions.R")

n.cores <- 100
n.lines <- 100
seqP <- seq(1,n.lines,n.lines/n.cores)
xx <- as.numeric(Sys.getenv("SGE_TASK_ID"))
row.num <- seqP[xx] 

#row.num<- row.num+30

skiper<- c(seq(0,2222220,22222)[1:100],2222220)
allsum_cumI<- NULL
allsum_cumBI<- NULL
allsum_R0<- NULL
allsum_AR<- NULL

remer = c(56,60:64, 70:100)

print("median of ten cumI, PI and BI values...")

#row.num=1

#row.num = remer[row.num]

for (repl in (1:1000)) {

  resf = paste("../../output2/R0_asia_repl_",repl,".bil",sep="")
  allsum_R0<- cbind(allsum_R0,as.vector(unlist(as.matrix(raster(resf),ncol=nx,nrow=ny)))[(skiper[row.num]+1):skiper[row.num+1]])

  resf = paste("../../output2/AR_asia_repl_",repl,".bil",sep="")
  allsum_AR<- cbind(allsum_AR,as.vector(unlist(as.matrix(raster(resf),ncol=nx,nrow=ny)))[(skiper[row.num]+1):skiper[row.num+1]])

  resf = paste("../../outputas/cumI_asia_repl_",repl,".bil",sep="")
  allsum_cumI<- cbind(allsum_cumI,as.vector(unlist(as.matrix(raster(resf),ncol=nx,nrow=ny)))[(skiper[row.num]+1):skiper[row.num+1]])

  resf = paste("../../outputas/cumBI_asia_repl_",repl,".bil",sep="")
  allsum_cumBI<- cbind(allsum_cumBI,as.vector(unlist(as.matrix(raster(resf),ncol=nx,nrow=ny)))[(skiper[row.num]+1):skiper[row.num+1]])               

} ### loop through all replicates 


allmed_R0 <- apply(allsum_R0,1,median, na.rm=T)
allmed_AR <- apply(allsum_AR,1,median, na.rm=T)
allmed_cumI <- apply(allsum_cumI,1,median, na.rm=T)
allmed_cumBI <- apply(allsum_cumBI,1,median, na.rm=T)

remove(allsum_R0)
remove(allsum_AR)
remove(allsum_cumI)
remove(allsum_cumBI)

write.csv(allmed_R0,paste("../../output2/R0_asia_med_",row.num,"_1.csv",sep=""), row.names=F, quote=F)
write.csv(allmed_AR,paste("../../output2/AR_asia_med_",row.num,"_1.csv",sep=""), row.names=F, quote=F)
write.csv(allmed_cumI,paste("../../outputas/cumI_asia_med_",row.num,"_1.csv",sep=""), row.names=F, quote=F)
write.csv(allmed_cumBI,paste("../../outputas/cumBI_asia_med_",row.num,"_1.csv",sep=""), row.names=F, quote=F)

