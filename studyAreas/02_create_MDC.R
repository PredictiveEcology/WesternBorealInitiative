source("studyAreas/01_create_DEM.R")

#install_github("PredictiveEcology/climateData@development")

library("climateData")

climateDataDir <- normalizePath("~/data/climate/ClimateNA_data")

# Western Boreal ------------------------------------------------------------------------------

## Provinces
mdc_wb1 <- lapply(c(provs, terrs), function(x) {
  dir1 <- file.path(climateDataDir, "historic_1991-2019", x)
  mdc1 <- makeMDC(inputPath = dir1, years = 1991:2019)
  writeRaster(mdc1, file.path("studyAreas/data", paste0("MDC_historic_1991-2019_", x, ".grd")), overwrite = TRUE)

  dir2 <- file.path(climateDataDir, "future_2011-2100", "CCSM4_RCP45", x)
  mdc2 <- makeMDC(inputPath = dir2, years = 2011:2100)
  writeRaster(mdc2, file.path("studyAreas/data", paste0("MDC_CCSM4_RCP45_", x, ".grd")), overwrite = TRUE)

  dir3 <- file.path(climateDataDir, "future_2011-2100", "CCSM4_RCP85", x)
  mdc3 <- makeMDC(inputPath = dir3, years = 2011:2100)
  writeRaster(mdc3, file.path("studyAreas/data", paste0("MDC_CCSM4_RCP85_", x, ".grd")), overwrite = TRUE)
})

# Ontario -------------------------------------------------------------------------------------

dir1 <- file.path(climateDataDir, "historic_1991-2019", "Ontario")
mdc1 <- makeMDC(inputPath = dir1, years = 1991:2019)
writeRaster(mdc1, file.path("studyAreas/data", paste0("MDC_historic_1991-2019_", "Ontario", ".grd")), overwrite = TRUE)

dir2 <- file.path(climateDataDir, "future_2011-2100", "CCSM4_RCP45", "Ontario")
mdc2 <- makeMDC(inputPath = dir2, years = 2011:2100)
writeRaster(mdc2, file.path("studyAreas/data", paste0("MDC_CCSM4_RCP45_", "Ontario", ".grd")), overwrite = TRUE)

dir3 <- file.path(climateDataDir, "future_2011-2100", "CCSM4_RCP85", "Ontario")
mdc3 <- makeMDC(inputPath = dir3, years = 2011:2100)
writeRaster(mdc3, file.path("studyAreas/data", paste0("MDC_CCSM4_RCP85_", "Ontario", ".grd")), overwrite = TRUE)
