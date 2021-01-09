library(reproducible)
library(sf)
library(sp)
library(raster)

dPath <- tempdir()

dem <- prepInputs(url = "https://drive.google.com/file/d/121x_CfWy2XP_-1av0cYE7sxUfb4pmsup",
                  destinationPath = dPath,
                  fun = "raster::raster")

dem.grd <- writeRaster(dem, file.path(dPath, "dem.grd"))
dem.saga <- RSAGA::rsaga.import.gdal(file.path(dPath, "dem.grd"), file.path(dPath, "dem.sgrd"))

RSAGA::rsaga.wetness.index(file.path(dPath, "dem.sgrd"), file.path(dPath, "swi.sgrd"))
