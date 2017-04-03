####################################################

import os, sys
from qgis.analysis import QgsRasterCalculator, QgsRasterCalculatorEntry,  QgsZonalStatistics

# Add polygon layer 

#specify polygon shapefile vector
polygonLayer = QgsVectorLayer('/Users/asiraj/Dropbox/GoFlex/DataNow/Admin_units/asia_admin0.shp', 'zonepolygons', "ogr") 
  

vtypes = ["cumI_asia_repl_", "cumBI_asia_repl_"]
sufs = ["I","BI"]

rplst = range (1,1001,1)
rng = range(0,2,1)

for vtype in rng :
	for repl in rplst :  
		# Add raster 1
		rasterFilePath = '/Users/asiraj/Dropbox/zika_asia/outputas2/'+ vtypes[vtype] + str(repl) +'.bil'
		zoneStat = QgsZonalStatistics (polygonLayer, rasterFilePath, sufs[vtype]+str(repl), 1, QgsZonalStatistics.Sum)
		zoneStat.calculateStatistics(None)
		print(vtype)
		print(repl)
	


