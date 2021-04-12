source("studyAreas/00_WB_BCR.R")

## caribou lambda
metaHerds <- prepInputs(
  targetFile = "Enhanced_MetaHerds_20191029.shp",
  archive = "Johnsonetal2020_studyareas.zip",
  alsoExtract = "similar",
  url = "https://drive.google.com/file/d/1lH_Oy2pEHv9dtSsAXn-UrDHrW1aJOOCd",
  destinationPath = dPath,
  filename2 = NULL,
  targetCRS = targetCRS,
  studyArea = studyArea
) %>%
  intersect(., studyArea)

plot(studyArea)
plot(metaHerds, add = TRUE, col = "pink")
