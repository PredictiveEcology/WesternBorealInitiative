source("studyAreas/00_WB_BCR.R")

ab <- provinces[provinces$NAME_1 == "Alberta", ]
bcabnt <- provinces[provinces$NAME_1 %in% c("British Columbia", "Alberta", "Northwest Territories"), ]

png("figures/sbw_ecoregions_map.png", width = 1000, height = 800, type = "cairo")
plot(bcabnt)
plot(ecoregions[ecoregions$REGION_ID %in% c(72), ], add = TRUE, col = "goldenrod") ## Hay River Lowland
dev.off()

## study areas
studyAreaSBW <- postProcess(ecoregions[ecoregions$REGION_ID %in% c(72), ], studyArea = ab) ## TODO: use sf
studyAreaSBWLarge <- buffer(studyAreaSBW, 10000) ## 10 km buffer

png("figures/sbw_studyArea.png", width = 1000, height = 800, type = "cairo")
plot(studyArea)
plot(studyAreaSBW, add = TRUE, col = "lightblue")
plot(studyAreaSBWLarge, add = TRUE)
dev.off()
