library(ape)
library(phytools)

bantu = read.nexus("data/anc-state/bantu.bttrees")

tr = bantu[[1]]

d = read.table('data/co-evo/bantu-iroquois-cross.cousinmarriage.preferred.btdata', row.names = 1)
d$col = ifelse(rowSums(d) == 2, "red", "white")
d$pch_value = ifelse(rowSums(d[,1:2]) == 2, 21, 22)

tr %>% 
  ladderize() %>%
  plot(cex = 0.4)
nodelabels(node = 78)
tiplabels(bg = d$col, pch = d$pch_value)

lat.long<-read.csv("data/anc-state/bantu_locations.csv", row.names = 2)
lat.long = lat.long[,2:3]
obj<-phylo.to.map(tr,lat.long,plot=FALSE, rotate = TRUE)
plot(obj,type="direct",asp=1.3,mar=c(0.1,0.5,3.1,0.1), 
     ylim = c(-35, 9), xlim = c(9, 40), fsize = 0.2, pch = d$pch_value)
nodelabels(pch = 19, cex = 1, node = 78)
nodelabels(pch = 19, cex = 1, node = 70, col = "blue")
