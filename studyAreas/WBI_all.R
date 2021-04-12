# source("studyAreas/WBI_RIA.R")
# source("studyAreas/WBI_MPB.R")
# source("studyAreas/WBI_SBW.R")
# source("studyAreas/caribou_metaherds.R")

Require("ggmap")
Require("ggspatial")

png("figures/all_studyAreas.png", width = 1200, height = 800)
plot(studyArea)
plot(aggregate(bcr6_nt1), add = TRUE, col = "lightblue")  ## caribou RSF
plot(aggregate(studyAreaMPB), add = TRUE, col = "brown")  ## MPB
plot(studyAreaSBW, add = TRUE, col = "orange")            ## SBW
plot(aggregate(ria), add = TRUE, col = "darkgreen")       ## carbon + harvesting
plot(metaHerds, add = TRUE, col = "pink")                 ## caribou lambda
dev.off()

## ggplot version
gg_all <- ggplot(studyArea) +
  geom_polygon(data = fortify(studyArea),
               aes(long, lat, group = group),
               fill = "grey", colour = "black", alpha = 0.2) +
  geom_polygon(data = fortify(aggregate(bcr6_nt1)),
               aes(long, lat, group = group),
               fill = "lightblue", colour = "blue", alpha = 0.2) +
  geom_polygon(data = fortify(aggregate(studyAreaMPB)),
               aes(long, lat, group = group),
               fill = "brown", colour = "brown", alpha = 0.2) +
  geom_polygon(data = fortify(studyAreaSBW),
               aes(long, lat, group = group),
               fill = "orange", colour = "orange", alpha = 0.2) +
  geom_polygon(data = fortify(aggregate(ria)),
               aes(long, lat, group = group),
               fill = "darkgreen", colour = "darkgreen", alpha = 0.2) +
  geom_polygon(data = fortify(metaHerds),
               aes(long, lat, group = group),
               fill = "pink", colour = "magenta", alpha = 0.2) +
  ## TODO: add legend
  theme_bw()

ggsave(gg_all, filename = "figures/all_studyAreas_gg.png", width = 12, height = 8)
