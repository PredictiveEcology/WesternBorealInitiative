library(raster)
library(reproducible)

rasterOptions(default = TRUE)
options("rasterMaxMemory" = 5e12,
        "rasterTmpDir" = "/mnt/scratch")

dPath <- checkPath("~/Documents/DEMs", create = TRUE)

dem <- prepInputs(url = "https://drive.google.com/file/d/121x_CfWy2XP_-1av0cYE7sxUfb4pmsup",
                  destinationPath = dPath,
                  fun = "raster::raster")

tpi <- terrain(dem, "TPI", filename = file.path(dPath, "tpi.tif"))
