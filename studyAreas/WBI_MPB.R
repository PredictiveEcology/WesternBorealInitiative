source("studyAreas/00_WB_BCR.R")

png("figures/mpb_ecoregions_map.png", width = 1000, height = 800, type = "cairo")
plot(studyArea)
plot(ecoregions[ecoregions$REGION_ID %in% c(112), ], add = TRUE, col = "goldenrod") ## Wabasca Lowland
plot(ecoregions[ecoregions$REGION_ID %in% c(122, 124, 126), ], add = TRUE, col = "darkgreen") ## Mid-Boreal Uplands
plot(ecoregions[ecoregions$REGION_ID %in% c(120), ], add = TRUE, col = "darkred") ## Western Alberta Upland
dev.off()

## study areas
studyAreaMPB <- ecoregions[ecoregions$REGION_ID %in% c(112, 122, 124, 126), ] %>%
  aggregate(.) %>%
  st_as_sf(.)
studyAreaMPBFit <- ecoregions[ecoregions$REGION_ID %in% c(120), ] %>% st_as_sf(.)

png("figures/mpb_studyArea.png", width = 1000, height = 800)
plot(studyArea)
plot(studyAreaMPB, add = TRUE, col = "lightblue")
#plot(studyAreaMPBFit, add = TRUE, col = "purple")
dev.off()
