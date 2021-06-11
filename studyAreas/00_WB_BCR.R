library(Require)
Require(c("sf", "sp", "raster", "RColorBrewer", "reproducible"))

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
                         filename2 = NULL, overwrite = TRUE) %>% ## TODO: selfintersection issues
  as_Spatial(.)

## combine NT and NU in shapefile
studyAreaCombined <- studyArea[, "NAME_1"]
ids <- which(studyAreaCombined[["NAME_1"]] %in% c("Northwest Territories", "Nunavut"))
studyAreaCombined[["NAME_1"]][ids] <- "Northwest Territories & Nunavut"
studyAreaCombined <- raster::aggregate(studyAreaCombined, by = "NAME_1")
plot(studyAreaCombined)

shapefile(studyAreaCombined, "studyAreas/WB_BCR.shp", overwrite = TRUE)
zip(file.path("studyAreas/WB_BCR.zip"), list.files("studyAreas", pattern = "^WB_BCR", full.names = TRUE))

## basic plot
colours <- RColorBrewer::brewer.pal(length(studyAreaCombined[["NAME_1"]]), "Spectral")
plot(as_Spatial(canProvs))
plot(studyAreaCombined, col = colours, add = TRUE)

# nicer plot ----------------------------------------------------------------------------------

Require(c("ggplot2", "ggspatial"))

alpha <- 0.3
gg_wbi <- ggplot(provsWB[-which(provsWB$NAME_1 == "Nunavut"), ]) +
  geom_sf(fill = "white", colour = "black", alpha = alpha) +
  theme_bw() +
  annotation_north_arrow(location = "bl", which_north = "true",
                         pad_x = unit(0.25, "in"), pad_y = unit(0.25, "in"),
                         style = north_arrow_fancy_orienteering) +
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Western Boreal Initiative Study Areas") +
  geom_sf(data = st_as_sf(studyAreaCombined), fill = colours, colour = "black", alpha = alpha)
## TODO: need legend

ggsave(gg_wbi, filename = "figures/WBI_studyArea_gg.png", width = 12, height = 8)
