source("studyAreas/00_WB_BCR.R")

ab <- canProvs[canProvs$NAME_1 == "Alberta", ]
bcabnt <- canProvs[canProvs$NAME_1 %in% c("British Columbia", "Alberta", "Northwest Territories"), ]

png("figures/sbw_ecoregions_map.png", width = 1000, height = 800, type = "cairo")
plot(as_Spatial(bcabnt))
plot(ecoregions[ecoregions$REGION_ID %in% c(72), ], add = TRUE, col = "goldenrod") ## Hay River Lowland
dev.off()

## study areas
studyAreaSBW <- postProcess(ecoregions[ecoregions$REGION_ID %in% c(72), ], studyArea = ab) %>%
  st_as_sf(.)

png("figures/sbw_studyArea.png", width = 1000, height = 800, type = "cairo")
plot(studyArea)
plot(as_Spatial(studyAreaSBW), add = TRUE, col = "goldenrod")
dev.off()
