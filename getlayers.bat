@echo off
echo Preparing to fetch city boundaries ...
wget -O cities.zip ftp://pbcgis:sigcbp@ftp.co.palm-beach.fl.us/PZB/CITY_BNDRY.zip
"D:\Program Files\7-Zip\7z.exe" -y e cities.zip
ogr2ogr -f "ESRI Shapefile" -sql "SELECT muniname as fname, fcode as FNUM from CITY_BNDRY" cityslice.shp CITY_BNDRY.shp

echo Getting neighborhoods ...
wget -O neighborhoods.zip ftp://pbcgis:sigcbp@ftp.co.palm-beach.fl.us/PZB/NEIGHBORHOOD.zip
"D:\Program Files\7-Zip\7z.exe" -y e neighborhoods.zip
ogr2ogr -f "ESRI Shapefile" -sql "SELECT FNAME as fname, 90 as FNUM from NEIGHBORHOOD WHERE FNAME='ACREAGE NEIGHBORHOOD PLAN'" neighslice.shp neighborhood.shp

echo Combining stuff ...
ogr2ogr -f "ESRI Shapefile" merge.shp cityslice.shp
ogr2ogr -f "ESRI Shapefile" -update -append merge.shp neighslice.shp

ogr2ogr -f KML CityFinderMerged.kml merge.shp
echo .
echo .
echo Your turn!
echo Upload CityFinderMerged.kml to replace all layers of
echo https://fusiontables.google.com/data?docid=14zwHSYdwduglA9Osu1aEIMT3XPW6sNM7W21zX4SW#map:id=3

