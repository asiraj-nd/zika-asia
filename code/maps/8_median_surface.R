.libPaths("/afs/crc.nd.edu/user/a/asiraj/R/gdal")
#library(rgdal)
.libPaths("/afs/crc.nd.edu/user/a/asiraj/raster")
library(raster)
setwd("/afs/crc.nd.edu/user/a/asiraj/zika/code/maps")
source("0_numfunctions.R")

tenth<-seq(0,1000,10)
n.cores <- 1
n.lines <- 1
#seqP <- seq(1,n.lines,n.lines/n.cores)
#xx <- as.numeric(Sys.getenv("SGE_TASK_ID"))
#row.num <- seqP[xx] 

print("median of ten cumI, PI and BI values...")

allmed_R0<- NULL
allmed_AR<- NULL
allmed_cumI<- NULL
allmed_cumBI<- NULL

for (repl in (1:100)) {
        allmed_R0<- c(allmed_R0,as.vector(unlist(read.csv(paste("../../output2/R0_asia_med_",repl,"_1.csv",sep=""), header=T))))
        allmed_AR<- c(allmed_AR,as.vector(unlist(read.csv(paste("../../output2/AR_asia_med_",repl,"_1.csv",sep=""), header=T))))
        allmed_cumI<- c(allmed_cumI,as.vector(unlist(read.csv(paste("../../outputas/cumI_asia_med_",repl,"_1.csv",sep=""), header=T))))
        allmed_cumBI<- c(allmed_cumBI,as.vector(unlist(read.csv(paste("../../outputas/cumBI_asia_med_",repl,"_1.csv",sep=""), header=T))))

}
length(allmed_R0)

write.csv(allmed_R0,paste("../../output2/R0_asia_med_",row.num,"_0.csv",sep=""), row.names=F, quote=F)
write.csv(allmed_AR,paste("../../output2/AR_asia_med_",row.num,"_0.csv",sep=""), row.names=F, quote=F)
write.csv(allmed_cumI,paste("../../outputas/cumI_asia_med_",row.num,"_0.csv",sep=""), row.names=F, quote=F)
write.csv(allmed_cumBI,paste("../../outputas/cumBI_asia_med_",row.num,"_0.csv",sep=""), row.names=F, quote=F)


  ####### # R0
print("generatng mean R0 map...")
  outdf1 = paste("../../output2/R0_asia_median_1k",sep="")
  output2_5_asia(allmed_R0,outdf1)

  ######## # Attack rate
print("generatng mean AR map...")
  outdf1 = paste("../../output2/AR_asia_median_1k",sep="")
  output2_5_asia(allmed_AR,outdf1)

  ###### # Infecteds
print("generatng mean Infecteds map...") 
  outdf1 = paste("../../outputas/cumI_asia_median_1k",sep="")
  output2_5_asia(allmed_cumI,outdf1)  

  ###### # births by infected
print("generating mean Infected births map...") 
  outdf1 = paste("../../outputas/cumBI_asia_median_1k",sep="")
  output2_5_asia(allmed_cumBI,outdf1)


