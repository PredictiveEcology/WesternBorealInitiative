source("studyAreas/00_WB_BCR.R")

## used for birds and caribou RSF
bcr6_nt1 <- prepInputs(
  url = "https://drive.google.com/file/d/1RPfDeHujm-rUHGjmVs6oYjLKOKDF0x09/",
  targetFile = "NT1_BCR6.shp", alsoExtract = "similar",
  targetCRS = targetCRS, ## TODO: doesn't work on Windows
  fun = "sf::st_read",
  cacheRepo = cPath,
  destinationPath = dPath
) %>%
  as_Spatial(.)

png("figures/bcr6_nt1.png", width = 1000, height = 800, type = "cairo")
plot(studyArea)
plot(bcr6_nt1, add = TRUE, col = "lightblue")
dev.off()
