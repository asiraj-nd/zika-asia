set.seed(123)
library(geoR)

library(rgdal)
library(raster)
library(fields)

setwd ("~/Dropbox/zika_asia/code/maps")
source("0_numfunctions.R")

world25 = read.csv(paste("../../data/wpopgpw_asia2015.csv",sep=""),header=T)
asia2_5(world25,paste("../../data/wpopAsia_gpw_2_5m",sep=""),-180,90,8640,4320)
popf<- paste("../../data/serial_2_5min.bil",sep="")

ny=1155
nx=1924
xll = 60.87816
maxy = 37.09018

allecon<- matrix(as.vector(unlist(read.csv("../../data/Gecon_lat_lon.csv", header=T)[,-1])),27445,8)
head(allecon)
allecon[which(is.na(allecon[,3])),3]<-0 
allecon[which(is.na(allecon[,4])),4]<-0 
grdpop<-aggregate(allecon[,3],list(lat=allecon[,1], lon=allecon[,2]), FUN=sum)
grdecon<-aggregate(allecon[,4],list(lat=allecon[,1], lon=allecon[,2]), FUN=sum)

dim(grdpop)
grid.y<- seq(-90,89)
grid.x<- seq(-180,179) 
ecogrid<- matrix(NA,nrow=180,ncol=360)
for (i in 1: (dim(grdecon)[1])) {
  mxloc<- c(which(grid.y == grdecon[i,1]), which(grid.x== grdecon[i,2]))
  ecogrid[mxloc[1], mxloc[2]]<- grdecon[i,3]
}
ecogrid<-ecogrid[180:1,]
ecogrid[which(is.na(ecogrid))]<-0


### population
###### note that the econgrid product used 2005 GPW estimates 
popf = paste("../../data/glp05ag.bil",sep="")   ### gridded population GPW estimates (2005)
pop2005 <- as.matrix(raster(popf),ncol=nx,nrow=ny)
dim(pop2005)

### standardize world grid
pop2005<- rbind(matrix(NA,120,8640),pop2005)
pop2005<-rbind(pop2005, matrix(NA,768,8640))
dim(pop2005)

### aggregate population to match econgrid (1deg) resolution
pop2005crs<-glbcoarser(pop2005,24,2)

## convert Gecon to per capita (in 2005 $US)
econ_pc<- (ecogrid*10^9 / pop2005crs)
econ_pc[which(econ_pc==Inf)]<-0

### resample to 2.5 min resolution
ecopcpp<-nearestnb(econ_pc)

################
###### Asia extents
contf = paste("../../data/country_code_2_5min.tif",sep="")   ### gridded national codes SEDAC
country <- as.matrix(raster(contf),ncol=nx,nrow=ny)
country<- rbind(matrix(NA,120,8640),country)
country<-rbind(country, matrix(NA,720,8640))

# cnty = c("BGD","BRN","IDN", "IND", "KHM", "LAO", "LKA", "MMR", "MYS", "PAK", "PHL", "SGP", "THA", "TLS", "VNM")
secnt = c(22, 39, 267, 274, 43, 132, 213, 261, 145, 178, 272, 206, 273, 222, 262)  # SEDAC codes for 15 Asian countries
country[which(!country%in%secnt)]<-NA # limit to 15 countries

#### grid serial for asia
newgrid<- which(!is.na(country))
length(newgrid)

#### generate the large matrix of covariates
grid.x= seq(-180,180,0.041666667)
grid.y = seq(-90,90,0.041666667)
allcontent<- cbind(expand.grid((grid.y[4320:1]),grid.x)[,2:1], NA, NA)[newgrid,]
for (mon in 1:12) {
  climf = paste("../../data/tmean",mon,".bil",sep="") #wclim
  climdata <- as.matrix(raster(climf),ncol=nx,nrow=ny)
  climdata<-rbind(climdata, matrix(NA,720,8640))
  dim(climdata)
  climdata<- climdata/10  # convert to oC
  allcontent<- cbind(allcontent,as.vector(unlist(climdata))[newgrid])
}
allcontent<- data.frame(cbind(allcontent, as.vector(unlist(ecopcpp))[newgrid]))
allcontent[which(allcontent[,17]<0),17]<-0
length(which(allcontent[,17]==0))

##### East Timore and Myanmar missing GDP values  
#### data obtained from CIA https://www.cia.gov/library/publications/the-world-factbook/geos/xx.html
#### and http://www.indexmundi.com/g/g.aspx?v=67&c=re&l=en
gdp_pcpppextra<- matrix(as.vector(unlist(read.csv("../../data/extra_gdp_values.csv", header=TRUE))),2,3)
for(gd in 1:length(gdp_pcpppextra[,1])) {
  cntgrd<- which(country==gdp_pcpppextra[gd,2])
  ecopcpp[cntgrd]<- gdp_pcpppextra[gd,3]
}
ecopcpp[which(ecopcpp==Inf)]<-0
allcontent<- data.frame(cbind(allcontent, as.vector(unlist(ecopcpp))[newgrid]))
allcontent[which(allcontent[,17]<0),17]<-0

names(allcontent)<- c('lon', 'lat', 'aegypti','albopictus', 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','gdp_pcppp2005')
write.csv(allcontent,"../../generated/allcovs_asia_compact.csv", row.names=F, quote=F)

dim(allcontent)
