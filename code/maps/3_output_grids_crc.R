library(rgdal)
library(raster)
setwd("/afs/crc.nd.edu/user/a/asiraj/zika/code/maps")
source("0_numfunctions.R")

pop2015<- read.csv("../../data/wpopgpw_asia2015.csv",header=T)
newgrid<- as.vector(unlist(read.csv("../../generated/se_asia_serial.csv", header=T)[,1]))
#################################
print("reading births raster...")

resf  = paste("../../data/global_asia_births_2_5m.csv",sep="")
globalbirths = read.csv(resf, header=T)
print(dim(globalbirths))

n.cores <- 1000
n.lines <- 1000
seqP <- seq(1,n.lines,n.lines/n.cores)
xx <- as.numeric(Sys.getenv("SGE_TASK_ID"))
row.num <- seqP[xx] 

for (repl in row.num:row.num) {
  ###### assemble R0 from chunks
  allR0i<- NULL
  print("assembling R0s...")
  for (i in 1:8){
     R0vec <- as.vector(unlist(read.csv(paste("../../generated/repl_",repl,"_R0x",i,".csv",sep=""),header=T)))
     allR0i<-c(allR0i, R0vec)
    print(c("repl:",repl,"R0 chunk:",i, "max:", max(R0vec, na.rm=T)))
  }
  allR0<- matrix(NA,4320,8640)
  allR0[newgrid]<- allR0i

  ###### assemble AR from cluster
  print("assembling ARs...")
  allARi<- NULL
  for (i in 1:8){
     ARvec = as.vector(unlist(read.csv(paste("../../generated/repl_",repl,"_ARx",i,".csv",sep=""),header=T)))
     allARi<-c(allARi, ARvec)
     print(c("repl:",repl,"AR chunk:",i, max(ARvec,na.rm=T)))
  }
  allAR<- matrix(NA,4320,8640)
  allAR[newgrid]<- allARi

  globalR0 <- allR0
  globalAR <- allAR 
  ########
  ##### map of R0
  print("generating R0 maps...") 
  outdf1 = paste("../../output_intrim/R0_asia_repl_",repl,sep="")
  output_2_5_asia(asia_extent(globalR0),outdf1)
 
  ##### map of AR
  print("generating AR maps...") 
  outdf1 = paste("../../output_intrim/AR_asia_repl_",repl,sep="")
  output2_5_asia(asia_extent(globalAR),outdf1)
  
  ###### # Infecteds
  print("generatng Infecteds map...") 
  outdf1 = paste("../../output_grid/cumI_asia_repl_",repl,sep="")
  output2_5_asia(asia_extent(globalAR)*  asia_extent(pop2015),outdf1)

  ###### # births by infected
  print("generating infected births map...") 
  outdf1 = paste("../../output_grid/cumBI_asia_repl_",repl,sep="")
  output_2_5_asia( asia_extent(globalAR)* asia_extent(globalbirths),outdf1)
  
} ### loop through all replicates 
  
