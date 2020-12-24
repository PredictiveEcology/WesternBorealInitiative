## NOTE: DEM raster fires (*.asc) need to be created on Windows for use with ClimateNA
stopifnot(Sys.info()["sysname"] == "Windows")

source("studyAreas/00_WB_BCR.R")

#install_github("PredictiveEcology/climateData@development")

library("climateData")

buffProvs <- 21*60 ## 21 arc mins
buffTerrs <- 40*60 ## 40 arc mins

# Western Boreal ------------------------------------------------------------------------------

## Provinces

id <- which(provs == "British Columbia")
wb1 <- provs[-id] # omit BC here; will use higher res DEM for those.
dem_wb1 <- lapply(wb1, function(prov) {
  makeClimateDEM(
    studyArea = studyArea[studyArea$NAME_1 == prov, ],
    arcSecRes = c(180, 180),
    bufferArcSec = buffProvs,
    DEMdestinationPath = "studyAreas/data",
    destinationPath = "studyAreas/data",
    filename2 = prov
  )
})

wb2 <- provs[id] # BC
dem_wb2 <- lapply(wb2, function(prov) {
  makeClimateDEM(
    studyArea = studyArea[studyArea$NAME_1 == prov, ],
    arcSecRes = c(60, 60),
    bufferArcSec = buffProvs,
    DEMdestinationPath = "studyAreas/data",
    destinationPath = "studyAreas/data",
    filename2 = prov
  )
})

## Territories

id <- which(terrs == "Yukon")
wb3 <- terrs[-id] # omit YT here; will use higher res DEM for those.
dem_wb3 <- lapply(wb1, function(terr) {
  makeClimateDEM(
    studyArea = studyArea[studyArea$NAME_1 == terr, ],
    arcSecRes = c(180, 180),
    bufferArcSec = buffTerrs,
    DEMdestinationPath = "studyAreas/data",
    destinationPath = "studyAreas/data",
    filename2 = terr
  )
})

wb4 <- terrs[id] # YT
dem_wb4 <- lapply(wb2, function(terr) {
  makeClimateDEM(
    studyArea = studyArea[studyArea$NAME_1 == terr, ],
    arcSecRes = c(60, 60),
    bufferArcSec = buffTerrs,
    DEMdestinationPath = "studyAreas/data",
    destinationPath = "studyAreas/data",
    filename2 = terr
  )
})

# Ontario -------------------------------------------------------------------------------------

ON <- canProvs[canProvs$NAME_1 == "Ontario", ] %>% as_Spatial(.)

dem_on <- makeClimateDEM(
  studyArea = ON,
  arcSecRes = c(180, 180),
  bufferArcSec = buffProvs,
  DEMdestinationPath = "studyAreas/data",
  destinationPath = "studyAreas/data",
  filename2 = "Ontario"
)
