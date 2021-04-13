# source("studyAreas/WBI_RIA.R")
# source("studyAreas/WBI_MPB.R")
# source("studyAreas/WBI_SBW.R")
# source("studyAreas/caribou_metaherds.R")

Require("ggmap")
Require("ggspatial")

cols.bord <- c("blue", "brown", "purple", "darkgreen", "magenta") ## TODO: tweak colours
cols.fill <- c("lightblue", "brown", "purple", "darkgreen", "pink") ## TODO: tweak colours

png("figures/all_studyAreas.png", width = 1200, height = 800)
plot(studyArea)
plot(bcr6_nt1, add = TRUE, col = cols.fill[1])  ## caribou RSF
plot(studyAreaMPB, add = TRUE, col = cols.fill[2])  ## MPB
plot(studyAreaSBW, add = TRUE, col = cols.fill[3]) ## SBW
plot(ria, add = TRUE, col = cols.fill[4])       ## carbon + harvesting
plot(metaHerds, add = TRUE, col = cols.fill[5])      ## caribou lambda
dev.off()

## ggplot version
alpha <- 0.5
gg_all <- ggplot(provsWB[-which(provsWB$NAME_1 == "Nunavut"), ]) +
  geom_sf(fill = "white", colour = "black", alpha = alpha) +
  theme_bw() +
  annotation_north_arrow(location = "bl", which_north = "true",
                         pad_x = unit(0.25, "in"), pad_y = unit(0.25, "in"),
                         style = north_arrow_fancy_orienteering) +
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Western Boreal Initiative Study Areas") +
  geom_sf(data = st_as_sf(studyArea), fill = "grey", colour = "black", alpha = alpha) +
  geom_sf(data = bcr6_nt1, fill = cols.fill[1], colour = cols.bord[1], alpha = alpha) +
  geom_sf(data = studyAreaMPB, fill = cols.fill[2], colour = cols.bord[2], alpha = alpha) +
  geom_sf(data = studyAreaSBW, fill = cols.fill[3], colour = cols.bord[3], alpha = alpha) +
  geom_sf(data = ria, fill = cols.fill[4], colour = cols.bord[4], alpha = alpha) +
  geom_sf(data = metaHerds, fill = cols.fill[5], colour = cols.bord[5], alpha = alpha)# +
  # scale_fill_manual(name = "Study Area", values = cols.fill,
  #                   guide = guide_legend(override.aes = list(shape = rep(15, length(cols.fill)),
  #                                                            color = cols.fill, alpha = alpha, size = 8)))
  ## TODO: need legend

ggsave(gg_all, filename = "figures/all_studyAreas_gg.png", width = 12, height = 8)
