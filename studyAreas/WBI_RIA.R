source("studyAreas/00_WB_BCR.R")

## carbon + harvesting
ria <- Cache(
  prepInputs,
  url = "https://drive.google.com/file/d/1LxacDOobTrRUppamkGgVAUFIxNT4iiHU/",
  cachePath = cPath,
  destinationPath = dPath,
  targetCRS = targetCRS
) %>%
  st_as_sf(.) %>%
  .[.$TSA_NUMBER %in% c("40", "08", "41", "24", "16"),] %>%
  sf::st_buffer(., 0) %>%
  as_Spatial(.) %>%
  aggregate(.) %>%
  st_as_sf(.)

ria_wb <- st_intersection(st_as_sf(studyArea), ria)

png("figures/RIA.png", width = 1000, height = 800, type = "cairo")
plot(studyArea)
plot(as_Spatial(ria_wb), add = TRUE, col = "darkgreen")
dev.off()
