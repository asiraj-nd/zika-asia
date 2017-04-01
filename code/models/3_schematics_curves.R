setwd("../../code")

x = 1:100

Robind = cbind(x/10,1.2*(1-exp(-0.06*x)))
AR.approx = approxfun(Robind[,1],Robind[,2])

Reff = c(1, 0.95,0.9,0.85,0.8,0.75,0.7,0.65,0.6,0.55,0.5,0.45,0.4)
palette_l<-length(Reff) # number of gradiants
colfunc <- colorRampPalette(c("brown", "orange"))
legend_image <- as.raster(matrix(colfunc(palette_l), ncol=1))
allARs <- NULL
for (kk in 1:length(Reff)) {
  allARs = cbind(allARs,AR.approx(Robind[,1]*Reff[kk]))
}

png(file=paste("../../output/Figure2.png", sep=""),width=6, height=4.5, units=c("in"), res=150)
 plot((x/10)[-(1:2)],AR.approx(Robind[,1])[-(1:2)], ylim = c(0.08,1.19), type='l', col.axis='white',lwd=2, xlab="", ylab="",col="brown")
 for (kk in 2:length(Reff)) {
   lines((x/10)[-(1:2)],AR.approx(Robind[,1]*Reff[kk])[-(1:2)], lwd=2, col=legend_image[kk])
 }
 mtext(expression('R'[0]),1,line=3,cex=1.5)
 mtext("AR",2,line=1.5,at=0.75,las=1, cex=2)
 box(,lwd=2)
 lines((x/10)[-(1:2)],AR.approx(Robind[,1])[-(1:2)], lwd=2, col="black")
 mtext("low",1,line=1,at=0.5, las=1, cex=1.5, col="orange")
 mtext("high",1,line=1,at=9.0, las=1, cex=1.5, col="brown")
 arrows(1, 0.1, 9, 0.1)
dev.off()



