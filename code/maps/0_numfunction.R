####################################################
generate.Header<-function(nx,ny,minlon,maxlat,txt,cellWidth) {
  A1=c("ENVI description", "=", "{File Resize Result, x resize factor: 1.000000, y resize factor: 1.000000. [Sun Nov 05 11:08:48 2012]}")
  A2=c("samples", "=",nx)
  A3=c("lines", "=",ny)
  A4=c("bands",  "=",1)
  A5=c("header offset",  "=",0)
  A6=c("file type", "=","ENVI Standard")
  A7=c("data type", "=",4)
  A8=c("interleave", "=","bsq")
  A9=c("sensor type", "=","Unknown")
  A10=c("byte order ", "=",0)
  A11=c("x start", "=",1)
  A12=c("y start", "=",1)
  A13=c("map info", "=",paste("{Geographic Lat/Lon, 1.0000, 1.0000,", minlon, ",",maxlat,",", cellWidth,",", cellWidth,", WGS-84, units=Meters}",sep=""))
  A14=c("wavelength units", "=","Unknown")
  A15=c("data ignore value", "=",-9.99900000e+003)
  A16=c("band names", "=","{Resize (Band 1:tmin_1.bil)}")
  write.table(rbind(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16), txt, sep=" ",col.names=F,row.names=F, quote=F)
  return(0)
  }



glbcoarser<- function(gmx,rt,aggrg) {
  gx<-dim(gmx)/rt
  shrinkmx<-matrix(NA,gx[1],gx[2])
  for (i in 0:(gx[1]-1))
    for (j in 0:(gx[2]-1)) { 
      if (aggrg==1 & any(!is.na(gmx[(1:rt)+i*rt,(1:rt)+j*rt]))) shrinkmx[i+1, j+1]<- mean(gmx[(1:rt)+i*rt,(1:rt)+j*rt],na.rm=T)
      if (aggrg==2 & any(!is.na(gmx[(1:rt)+i*rt,(1:rt)+j*rt]))) shrinkmx[i+1, j+1]<- sum (gmx[(1:rt)+i*rt,(1:rt)+j*rt],na.rm=T)
    }
  return(shrinkmx)
}


### reampling econ by nearest neighborhood 
nearestnb<- function(mxd) {
  ecogridmx<- matrix(NA,nrow=180, ncol=8640)
  for (jj in 0:359)
    ecogridmx[,(1:24)+jj*24]<- rep(mxd[,jj+1],24)
  ecogridxmx<- matrix(NA,4320,8640)
  for (ii in 0:179)
    ecogridxmx[(1:24)+ii*24,]<- matrix(rep(ecogridmx[ii+1,],24),24,8640,byrow=T)
  return(ecogridxmx)
} 

output2_5_asia<- function (mx,outdf1) {
  outdf = paste(outdf1,".bil",sep="")
  writeBin(as.numeric(as.vector(t(mx))), outdf, size = 4)
  print(outdf)
  nx<-1924
  ny<-1155
  maxlat<- 37.09018
  minlon<- 60.87816
  txt<-paste(outdf1,".hdr",sep="")
  cellWidth<-0.041666667
  generate.Header(nx,ny,minlon,maxlat,txt,cellWidth)
}


