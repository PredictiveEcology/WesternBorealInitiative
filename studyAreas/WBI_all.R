# source("studyAreas/WBI_RIA.R")
# source("studyAreas/WBI_MPB.R")
# source("studyAreas/WBI_SBW.R")
# source("studyAreas/caribou_metaherds.R")

Require("ggmap")
Require("ggspatial")

url <- "https://raw.githubusercontent.com/tati-micheletti/host/master/stickers/moduleTable.csv"
hex <- read.csv(url)
cols <- hex[hex$module %in% c("birds", "MPB", "SBW", "harvest", "caribouLambda") & hex$parameter == "h_fill", ] %>%
  .[order(.$module), ] %>%
  `[[`("value")

#cols.bord <- c("blue", "brown", "purple", "darkgreen", "magenta") ## TODO: tweak colours
#cols.fill <- c("lightblue", "brown", "purple", "darkgreen", "pink") ## TODO: tweak colours

png("figures/all_studyAreas.png", width = 1200, height = 800)
plot(studyArea)
plot(bcr6_nt1, add = TRUE, col = cols[1])     ## caribou RSF
plot(studyAreaMPB, add = TRUE, col = cols[4]) ## MPB
plot(studyAreaSBW, add = TRUE, col = cols[5]) ## SBW
plot(ria_wb, add = TRUE, col = cols[3])       ## carbon + harvesting
plot(metaHerds, add = TRUE, col = cols[2])    ## caribou lambda
dev.off()

## ggplot version
alpha <- 0.3
gg_all <- ggplot(provsWB[-which(provsWB$NAME_1 == "Nunavut"), ]) +
  geom_sf(fill = "white", colour = "black", alpha = alpha) +
  theme_bw() +
  annotation_north_arrow(location = "bl", which_north = "true",
                         pad_x = unit(0.25, "in"), pad_y = unit(0.25, "in"),
                         style = north_arrow_fancy_orienteering) +
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Western Boreal Initiative Study Areas") +
  geom_sf(data = st_as_sf(studyArea), fill = "grey", colour = "black", alpha = alpha) +
  geom_sf(data = bcr6_nt1, fill = cols[1], colour = cols[1], alpha = alpha) +
  geom_sf(data = studyAreaMPB, fill = cols[4], colour = cols[4], alpha = alpha) +
  geom_sf(data = studyAreaSBW, fill = cols[5], colour = cols[5], alpha = alpha) +
  geom_sf(data = ria_wb, fill = cols[3], colour = cols[3], alpha = alpha) +
  geom_sf(data = metaHerds, fill = cols[2], colour = cols[2], alpha = alpha)# +
  # scale_fill_manual(name = "Study Area", values = cols,
  #                   guide = guide_legend(override.aes = list(shape = rep(15, length(cols)),
  #                                                            color = cols, alpha = alpha, size = 8)))
  ## TODO: need legend

ggsave(gg_all, filename = "figures/all_studyAreas_gg.png", width = 12, height = 8)
