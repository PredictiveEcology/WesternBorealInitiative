library(Require)
Require(c("googledrive", "networkD3", "readxl"))
finfo <- drive_download(file = as_id("1_WETMmM7SCiHYjo6GhJtrCVnHxBywan9twM0pdRWR3Q"),
                        path = file.path(tempdir(), "project_dependencies.xlsx"),
                        overwrite = TRUE) ## always fetch most recent version
wbi_deps <- read_excel(finfo$local_path)

nodes <- unique(data.frame(name = c(wbi_deps$from, wbi_deps$to),
                           type = c(wbi_deps$fromType, wbi_deps$toType)))
wbi_deps$IDsource <- match(wbi_deps$from, nodes$name) - 1 ## zero-indexed
wbi_deps$IDtarget <- match(wbi_deps$to, nodes$name) - 1 ## zero-indexed
sankeyNetwork(Links = wbi_deps,
              Nodes = nodes,
              Source = "IDsource",
              Target = "IDtarget",
              Value = "weight",
              NodeID = "name",
              NodeGroup = "type",
              fontSize = 16,
              fontFamily = "Arial")

## for customization tips/trick, see
## https://www.r-graph-gallery.com/322-custom-colours-in-sankey-diagram.html
