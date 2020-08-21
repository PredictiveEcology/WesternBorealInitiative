## NOTE: DEM raster fires (*.asc) need to be created on Windows for use with ClimateNA
stopifnot(Sys.info()["sysname"] == "Windows")

source("studyAreas/00_WB_BCR.R")

install_github("PredictiveEcology/climateData@development")

library("climateData")

# Western Boreal ------------------------------------------------------------------------------

dem_wb <- lapply(WB, function(prov) {
  makeClimateDEM(
    studyArea = studyArea[studyArea$NAME_1 == prov, ],
    arcSecRes = c(180, 180),
    bufferArcSec = 180,
    DEMdestinationPath = "studyAreas/data",
    destinationPath = "studyAreas/data",
    filename2 = prov
  )
})

# Ontario -------------------------------------------------------------------------------------

ON <- canProvs[canProvs$NAME_1 %in% "Ontario", ] %>% as_Spatial(.)

dem_on <- makeClimateDEM(
  studyArea = ON,
  arcSecRes = c(180, 180),
  bufferArcSec = 180,
  DEMdestinationPath = "studyAreas/data",
  destinationPath = "studyAreas/data",
  filename2 = "Ontario"
)
