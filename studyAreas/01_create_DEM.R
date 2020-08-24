## NOTE: DEM raster fires (*.asc) need to be created on Windows for use with ClimateNA
stopifnot(Sys.info()["sysname"] == "Windows")

source("studyAreas/00_WB_BCR.R")

install_github("PredictiveEcology/climateData@development")

library("climateData")

# Western Boreal ------------------------------------------------------------------------------

ids <- which(WB %in% c("British Columbia", "Yukon"))
wb1 <- WB[-ids] # omit BC and YT here; will use higher res DEM for those.
dem_wb1 <- lapply(wb1, function(prov) {
  makeClimateDEM(
    studyArea = studyArea[studyArea$NAME_1 == prov, ],
    arcSecRes = c(180, 180),
    bufferArcSec = 180,
    DEMdestinationPath = "studyAreas/data",
    destinationPath = "studyAreas/data",
    filename2 = prov
  )
})

wb2 <- WB[ids] # BC and YT
dem_wb2 <- lapply(wb2, function(prov) {
  makeClimateDEM(
    studyArea = studyArea[studyArea$NAME_1 == prov, ],
    arcSecRes = c(60, 60),
    bufferArcSec = 60,
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
