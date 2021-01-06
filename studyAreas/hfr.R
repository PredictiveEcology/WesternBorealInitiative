source("studyAreas/00_WB_BCR.R")

## linked from https://cfs.nrcan.gc.ca/fc-data-catalogue/read/15
url <- paste0("https://apps-scf-cfs.rncan.gc.ca/opendata/Forest%20Change/",
              "Forest%20impact%20maps%20and%20data/Fire/Number%20of%20large%20fires/",
              "Reference%20Period/",
              "Number%20of%20large%20fires%20-%20Nombre%20de%20grands%20feux%20-%201981-2010%20-%20Shape.zip")

hfr <- prepInputs(url = url, destinationPath = dPath,
                  targetFile = "number_of_fires_1981_2010.shp", alsoExtract = "similar",
                  fun = "raster::shapefile") %>%
  spTransform(., crs(studyArea))

plot(studyArea)
plot(hfr, col = "NA", border = "blue", add = TRUE, )
