if (!require("Require")) {install.packages("Require"); require("Require")}
Require(c("data.table", "googledrive","data.tree", "treemap", "DiagrammeR",
          "googlesheets4", "networkD3", "ClustOfVar", "cluster", "ggraph", "collapsibleTree",
          "RColorBrewer"))

gs4_auth("eliotmcintire@gmail.com")

ss <- gs4_get(as_id("https://docs.google.com/spreadsheets/d/1IB1N2GEotMcwtzaOxVU52AY8YGtOx4MOIbXuqltFsbQ/edit?usp=sharing"))
llOrig <- range_read(ss, sheet = "Task Entry", range = "A2:T")
topLevel <- as.data.table(range_read(ss, sheet = "Statuses", range = "b1:d"))


ll <- as.data.frame(lapply(llOrig, function(x) substr(x, 1, 30)))
colnames(ll) <- colnames(llOrig)
ll <- as.data.table(ll)

WBI <- copy(ll)
WBI <- WBI[!is.na(WBI$`Deliverable Item`)]
WBI <- rbindlist(list(WBI, topLevel), use.names = TRUE, fill = TRUE)
colOrder <- c("Deliverable Item", "Parent Group", "Contract Name", "Source")# "Contractor")#,

prepareCT <- function(dt, colOrder, topName = "WBI", attributes = TRUE, ...) {
  colOrder <- rev(colOrder)

  dtOrig <- copy(dt)
  dt <- data.table(from = character(), to = character())
  attrColNames <- NULL
  if (isTRUE(attributes)) {
    attrColNames <- setdiff(colnames(dtOrig), colOrder)
    dt <- cbind(dt, dtOrig[0][, ..attrColNames])
  }
  for (i in seq(length(colOrder) - 1)) {
    co <- c(colOrder[(i):(i+1)])
    co2 <- c(co, attrColNames)
    dups <- duplicated(dtOrig[, ..co])
    nas <- apply(dtOrig[, ..co], 1, function(x) any(is.na(x)))
    dt <- rbindlist(list(dt, dtOrig[!dups & !nas][, ..co2]), use.names = FALSE)
  }

  # Make 1 entry with NA with topName
  createTopLevelWBINA <- data.table(`from` = NA, `to` = topName)#, Contractor = "SamAndEliot")

  # Create full dataset
  dt <- rbindlist(list(dt, createTopLevelWBINA), use.names = TRUE, fill = TRUE)

  # remove cases where the 2 columns are identical
  dt1 <- dt[!apply(dt[, c("from", "to")], 1, function(x) length(unique(x))==1)]

  dt1[]
}


dt1 <- prepareCT(WBI, colOrder)
dt1[]

dt1[is.na(Contractor), Contractor := "Sam and Eliot"]

dt1[, Color := colorspace::rainbow_hcl(length(unique(Contractor)))[as.integer(factor(Contractor))]]
setnames(dt1, "Contractor", "Responsible")
dt1[Responsible == "Alex Chubaty", email := "achubaty@for-cast.ca"]
dt1[Responsible == "Eliot McIntire", email := "eliotmcintire@gmail.com"]
dt1[Responsible == "Tati Micheletti", email := "tati.micheletti@gmail.com"]

# levels(dt1$Color) <- colorspace::rainbow_hcl(5)
dt1[, url := paste0("https://0.gravatar.com/avatar/",
                        sapply(email, digest::digest, algo = "md5", serialize = FALSE),"=180")]
dt1[Responsible == "Greg Paradis", url := "https://0.academia-photos.com/7428022/2721223/18069935/s200_gregory.paradis.jpg"]
dt1[, tooltip := paste0("Responsible:",Responsible, "<br><img src='",url, "'>")]

dt1[, Amount:=as.integer(dt1$`Amount (without ICR)`)/10000]
dt1[is.na(Amount), Amount := 1]
collapsibleTreeNetwork(dt1, collapsed = TRUE, fill = "Color",
                       nodeSize = "Amount",
                       tooltipHtml = "tooltip",
                       attribute = "Responsible")

if (FALSE) {
  # dt1 <- dtOrig[, c("Deliverable Item", "Contractor")][dt, on = c("Deliverable Item" = "to")]
  # dt2 <- dtOrig[, c("Deliverable Item", "Contractor")][dt, on = c("Deliverable Item" = "from")]
  # dt1 <- na.omit(rbindlist(list(dt1, dt2), use.names = FALSE))

  # collapsedTree requires 1st 2 columns only -- should be named "from" and "to" probably
  setcolorder(WBI, c("Parent Group", "Deliverable Item"))

  createTopLevelWBINA <- data.table(`Parent Group` = NA, `Deliverable Item` = "WBI", Contractor = "SamAndEliot")
  TopLevel2 <- data.table(`Parent Group` = "WBI", `Deliverable Item` = na.omit(unique(WBI$Source)))
  # WBI <- rbindlist(list(WBI, createTopLevelWBINA, TopLevel2), fill = TRUE)

  # collapsibleTreeNetwork(WBI, collapsed = TRUE)
  # WBI[`Parent Group` == "NA", `Parent Group` := NA]

  # Move Contracts into place
  WBIContracts <- unique(WBI[, c("Contract Name", "Source")])
  setnames(WBIContracts, new = c("Deliverable Item", "Parent Group"), c("Contract Name", "Source"))
  WBI <- rbindlist(list(WBI, WBIContracts), fill = TRUE)



  createEliotSamNearTop <- data.table(`Contractor` = c("Eliot", "Eliot", "Sam"), `Deliverable Item` = c("NRCan", "NSERC", "ECCC"))



  # WBI <- rbindlist(list(WBI, TopLevel2), fill = TRUE)
  createEliotSamNearTop[WBI, on = c("Deliverable Item" = "Parent Group")]
  WBI3 <- WBI[, ..notContractor][createEliotSamNearTop, on = c("Parent Group" = "Deliverable Item")]
  WBI4 <- na.omit(rbindlist(list(WBI, WBI3), use.names = TRUE, fill = TRUE), cols = "Contractor")
  WBI5 <- rbindlist(list(WBI4, createTopLevelWBINA, TopLevel2), use.names = TRUE, fill = TRUE)

  # org$Manager %in% org$Employee
  WBI5[!WBI5$`Parent Group` %in% WBI5$`Deliverable Item`]


  WBI5$Contractor <- as.integer(factor(WBI5$Contractor))
  # setorder(WBI, "Parent Group")
  # WBI2 <- as.data.frame(WBI[grepl("^WBI$", `Parent Group`) | grepl("^WBI$" , `Deliverable Item`), c("Parent Group", "Deliverable Item")])
  collapsibleTreeNetwork(WBI5, collapsed = TRUE)
















  collapsibleTreeNetwork(WBI[grepl("WBI$", `Parent Group`) | grepl("WBI$" , `Deliverable Item`), c("Parent Group", "Deliverable Item", "Contractor")], attribute = "Contractor")

  collapsibleTreeNetwork(WBI,
                         aggFun = mean, attribute = "Contractor")

  #for (contractor in unique(bb$Contractor)) {
  #ll <- bb[Contractor == contractor]
  #pt <- list()
  #cc <- bb[!grepl("Contract Administration", `Parent Task`)]
  (p <- collapsibleTreeSummary(WBI, c("Source", "Contractor",  "Parent Group", "Deliverable Item"),
                               collapsed = FALSE,
                               attribute = "Contractor"
                               #                     fill = "green",
                               #                   fillByLevel = TRUE)
  ))
  p

  while (any(unique(ll$`Parent Task`) %in% ll$`Deliverable Item`)) {
    count <- count + 1
    pt[[count]] <- unique(ll$`Parent Task`)
    ll <- ll[!`Deliverable Item` %in% pt[[count]]]
  }

  # ll$pathString <- paste("WBI", ll$`Source`, ll$Contractor, ll$`Contract Name`, ll$`Parent Task`, ll$`Deliverable Item`, sep = "/")
  ll$pathString <- paste("WBI", ll$`Source`, ll$`Parent Task`, ll$`Deliverable Item`, sep = "/")
  pp <- as.Node(ll)
  print(diagonalNetwork( ToListExplicit(pp, unname = TRUE), fontSize = 14, nodeColour = rainbow(4)[2:3]))



  ll$pathString <- paste("WBI", ll$`Source`, ll$Contractor, ll$`Contract Name`, ll$`Parent Task`, ll$`Deliverable Item`, sep = "/")
  ll$pathString <- paste("WBI", ll$`Source`, ll$`Parent Task`, ll$`Deliverable Item`, sep = "/")
  pp <- as.Node(ll)
  diagonalNetwork( ToListExplicit(pp, unname = TRUE), fontSize = 14, nodeColour = rainbow(4)[2:3])

  # print(pp)
  print(pp, limit = 130)
  # plot(pp)

  ## Hierarchical Clustering
  rr <- ll[, c("Parent Task", "Deliverable Item", "Source")]
  rr <- rbindlist(list(rr, ll[, c("Contractor", "Parent Task", "Source")]), use.names = F)
  # rr <- rbindlist(list(rr, ll[, c("Contractor", "Source")]), use.names = F)
  rr <- rbindlist(list(rr, data.frame("WBI", unique(ll[, c("Contractor", "Source")]))), use.names = FALSE)
  rr <- unique(rr)

  vertices2 <- data.table(name = c(rr$`Parent Task`, rr$`Deliverable Item`),
                          group = rr$Source)
  vertices2 <- unique(vertices2, by = "name")
  rr$to <- match(rr$`Parent Task`, vertices2$name) - 1
  rr$from <- match(rr$`Deliverable Item`, vertices2$name) - 1

  mygraph <- graph_from_data_frame(rr, vertices = vertices2)
  clus <- cluster_edge_betweenness(mygraph)
  mem <- membership(clus)
  ggraph(mygraph, layout = 'dendrogram') +
    geom_edge_diagonal() +
    geom_node_text(aes( label=name, filter=leaf, color=group) , angle=90 , hjust=1, nudge_y=-0.1) +
    # geom_node_point(aes(filter=leaf, size=value, color=group) , alpha=0.6) +
    ylim(-.6, NA) +
    theme(legend.position="none")

  # ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  #   geom_conn_bundle(data = get_con(from = from, to = to), alpha=0.2, colour="skyblue", tension = 0) +
  #   geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05)) +
  #   theme_void()

  ggraph(mygraph, layout = 'dendrogram') +
    geom_edge_elbow2(aes(colour = Source))

  qq <- ll[Source != "NSERC",c("Source", "Parent Task", "Deliverable Item")]
  hc <- hclustvar(X.quali = qq)
  dend <- as.dendrogram(hc)
  par(mar=c(7,3,1,1))  # Increase bottom margin to have the complete label
  plot(dend)


  dd <- igraph_to_networkD3(mygraph, group = mem)
  diagonalNetwork(dd)
  ######## Find multiple roots
  #which(sapply(sapply(V(mygraph),
  #                    function(x) neighbors(mygraph,x, mode="in")), length) == 0)

  plot(mygraph)
  plot(mygraph,  edge.arrow.size=0, vertex.size=3)


  ggraph(mygraph, layout = 'dendrogram', circular = FALSE) +
    geom_edge_link() +
    theme_void()

  ggraph(mygraph, layout = 'dendrogram', circular = FALSE) +
    geom_edge_diagonal(alpha=0.1) +
    geom_conn_bundle(data = get_con(from = c(18,20,30), to = c(19, 50, 70)), alpha=1, width=1, colour="skyblue", tension = 1) +
    theme_void()

  ppNetwork <- ToDataFrameNetwork(pp, "name")
  simpleNetwork(ppNetwork[-3], fontSize = 12)

  ppList <- ToListExplicit(pp, unname = TRUE)
  radialNetwork(ppList)

  diagonalNetwork(ppList)


  #### SANKEY for modules
  Require(c("googledrive", "networkD3", "readxl"))
  finfo <- drive_download(file = as_id("1_WETMmM7SCiHYjo6GhJtrCVnHxBywan9twM0pdRWR3Q"),
                          path = file.path(tempdir(), "project_dependencies.xlsx"),
                          overwrite = TRUE) ## always fetch most recent version
  wbi_deps <- read_excel(finfo$local_path)

  nodes <- unique(data.frame(name = c(wbi_deps$from, wbi_deps$to),
                             type = c(wbi_deps$fromType, wbi_deps$toType)))
  wbi_deps$IDsource <- match(wbi_deps$from, nodes$name) - 1 ## zero-indexed
  wbi_deps$IDtarget <- match(wbi_deps$to, nodes$name) - 1 ## zero-indexed
  sankeyNetwork(
    Links = wbi_deps,
    Nodes = nodes,
    Source = "IDsource",
    Target = "IDtarget",
    Value = "weight",
    NodeID = "name",
    NodeGroup = "type",
    fontSize = 16,
    fontFamily = "Arial",
    iterations = 64 ## default 32
  )

  rrSankey <- rr[`Parent Task` != "WBI"]
  vertices2 <- data.table(name = c(rrSankey$`Parent Task`, rrSankey$`Deliverable Item`),
                          group = rrSankey$Source)
  vertices2 <- unique(vertices2)#, by = "name")
  rrSankey$to <- match(rrSankey$`Parent Task`, vertices2$name) - 1
  rrSankey$from <- match(rrSankey$`Deliverable Item`, vertices2$name) - 1
  rrSankey$weight <- 1


  sankeyNetwork(
    Links = rrSankey,
    Nodes = vertices2,
    Source = "to",
    Target = "from",
    Value = "weight",
    NodeID = "name",
    NodeGroup = "group",
    fontSize = 16,
    fontFamily = "Arial",
    iterations = 64 ## default 32
  )



  range_write(ss, data = hists2, range = "A2", sheet = "Historical")
  message(paste0("open ", ss$spreadsheet_url))

  st <- data.frame(time = as.character(Sys.time()))
  range_write(ss, data = st, range = "A8", sheet = "Summary", col_names = FALSE)

}
