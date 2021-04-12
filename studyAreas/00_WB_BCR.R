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
                  #targetCRS = targetCRS, ## TODO: fails on Windows
                  targetFile = "gadm36_CAN_1_sp.rds", ## TODO: this will change as GADM data update
                  cacheRepo = cPath,
                  destinationPath = dPath) %>%
  st_as_sf(.) %>%
  st_transform(., targetCRS)

provs <- c("British Columbia", "Alberta", "Saskatchewan", "Manitoba")
terrs <- c("Yukon", "Northwest Territories", "Nunavut")
WB <- c(provs, terrs)

ecoregions <- prepInputs(url = "http://sis.agr.gc.ca/cansis/nsdb/ecostrat/region/ecoregion_shp.zip",
                         targetFile = "ecoregions.shp", alsoExtract = "similar",
                         targetCRS = targetCRS, ## TODO: doesn't work on Windows
                         fun = "sf::st_read",
                         cacheRepo = cPath,
                         destinationPath = dPath) %>%
  as_Spatial(.)

bcrWB <- bcrshp[bcrshp$BCR %in% c(4, 6:8), ]
provsWB <- canProvs[canProvs$NAME_1 %in% WB, ]

studyArea <- postProcess(provsWB, studyArea = bcrWB, useSAcrs = TRUE, cacheRepo = cPath,
                         filename2 = NULL, overwrite = TRUE) %>%
  as_Spatial(.)

plot(as_Spatial(canProvs))
plot(studyArea, col = "lightblue", add = TRUE)

shapefile(studyArea, "studyAreas/WB_BCR.shp", overwrite = TRUE)
#zip(file.path("studyAreas/WB_BCR.zip"), list.files("studyAreas", pattern = "WB_BCR")) ## TODO

if (FALSE) { # This will produce a sort of nice-ish map of the study area
  library(ggmap)  # you may have to use install.packages to install it first

  ## TODO: what is `sa2`?
  bigger <- raster::buffer(as(extent(sa2), "SpatialPolygons") , 1)
  b <- bbox(bigger)
  saGMap <- get_map(location = b)

  ggmap(saGMap) +
    geom_polygon(data = fortify(sa2),
                 aes(long, lat, group = group),
                 fill = "orange", colour = "red", alpha = 0.2) +
    theme_bw() #+
    #coord_proj(proj="albers", x = 50, y = 65) # Didn't reproject the basemap!
}
