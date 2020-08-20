library(magrittr)
library(sf)
library(sp)
library(raster)
library(reproducible)

bcrzip <- "https://www.birdscanada.org/download/gislab/bcr_terrestrial_shape.zip"

cPath <- "studyAreas/cache"
dPath <- "studyAreas/data"
targetCRS <- paste("+proj=lcc +lat_1=49 +lat_2=77 +lat_0=0 +lon_0=-95",
                   "+x_0=0 +y_0=0 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0")

bcrshp <- Cache(prepInputs,
                url = bcrzip,
                cacheRepo = cPath,
                destinationPath = dPath,
                targetCRS = targetCRS,
                fun = "sf::st_read")

canProvs <- Cache(prepInputs,
                  "GADM",
                  fun = "base::readRDS",
                  dlFun = "raster::getData",
                  country = "CAN", level = 1, path = dPath,
                  targetCRS = targetCRS,
                  targetFile = "gadm36_CAN_1_sp.rds", ## TODO: this will change as GADM data update
                  cacheRepo = cPath,
                  destinationPath = dPath) %>%
  st_as_sf(.)

bcrWB <- bcrshp[bcrshp$BCR %in% c(4, 6:8), ]
provsWB <- canProvs[canProvs$NAME_1 %in% c("British Columbia", "Alberta", "Saskatchewan", "Manitoba",
                                           "Yukon", "Northwest Territories", "Nunavut"), ]

studyArea <- postProcess(provsWB, studyArea = bcrWB, useSAcrs = TRUE, cacheRepo = cPath,
                         filename2 = NULL, overwrite = TRUE) %>%
  as_Spatial(.)

plot(studyArea)

shapefile(studyArea, "studyAreas/WB_BCR.shp")
#zip(file.path("studyAreas/WB_BCR.zip"), list.files("studyAreas", pattern = "WB_BCR")) ## TODO
