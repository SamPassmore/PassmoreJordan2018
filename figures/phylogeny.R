library(phytools)
library(ape)

# here is code to create mirrored phylogenies with tips plotted
text_cex = 0.6

# read data + trees
d = read.table('data/co-evo/austronesian-iroquois-cross.cousinmarriage.preferred.btdata')
t = read.nexus('data/co-evo/austronesian-iroquois-cross.cousinmarriage.preferred.bttrees')
tree = t[[1]]
tree = ladderize(tree) # make tree look nice

# Red if present, otherwise white
d[,2:3] = apply(d[,2:3], 2, function(c) ifelse(c == 1, "#E41A1C", "white"))

# save as pdf
pdf('figures/austronesian-iroquoi-crosscousinmarriage.preferred.pdf')
rownames(d) = d[,1]
d = d[tree$tip.label,]
par(mar = rep(0, 4))
# layout organise the plot into thirds
layout(matrix(1:3,1,3),widths=c(0.39,0.20,0.39))
# plot the first tree + labels
plot(tree,lwd=6, show.tip.label = FALSE, no.margin = TRUE)
tiplabels(node = d[,2], pch = 21, bg = d[,2], col = "black", cex = 1.5)
# move to the next plot
plot.new()
# size that plot appropriately
plot.window(xlim=c(-0.1,0.1),
            ylim=get("last_plot.phylo",envir=.PlotPhyloEnv)$y.lim)
par(cex=0.6)
# plot the taxa names
text(rep(0,length(tree$tip.label)),1:Ntip(tree),
     gsub("_"," ", rev(tree$tip.label)),font=1)
# plot the thrid tree in new section
plot(tree,lwd=6, show.tip.label = FALSE, direction = 'leftwards', no.margin = TRUE)
tiplabels(node = d[,2], pch = 21, bg = d[,3], col = "black", cex = 1.5)
dev.off() # save

# Second is plots with two taxa points
## a4 size
width = 8.3
height = 11.7

d = read.table('data/co-evo/bantu-iroquois-cross.cousinmarriage.preferred.btdata',row.names = 1)
d = apply(d, 2, function(c) ifelse(c == 1, "#E41A1C", "white"))

t = read.nexus('data/co-evo/bantu-iroquois-cross.cousinmarriage.preferred.bttrees')
tree = t[[1]]
tree = ladderize(tree) # make tree look nice

# nice tiplabels
tree$tip.label = str_replace(tree$tip.label, ".*_", "")
tree$tip.label[1] = "Tiv Tivoid" # exception to the above rule

offset = 4000000
pdf('figures/bantu-iroquoi-crosscousinmarriage.preferred.pdf', width = width * 0.66, height = height * 0.66)
plot(tree,lwd=6, show.tip.label = TRUE, type = "phylogram", label.offset = offset, 
     cex = 0.5, font = 1, no.margin = TRUE)
tiplabels(node = d[,1], pch = 21, bg = d[,1], col = "black", cex = 1)
tiplabels(node = d[,2], pch = 22, bg = d[,2], col = "black", cex = 1, offset = offset * 2/3)
dev.off()

## uto-aztecan
d = read.table('data/co-evo/uto-iroquois-cross.cousinmarriage.preferred.btdata',row.names = 1)
d = apply(d, 2, function(c) ifelse(c == 1, "#E41A1C", "white"))

t = read.nexus('data/co-evo/uto-iroquois-cross.cousinmarriage.preferred.bttrees')
tree = t[[1]]
tree = ladderize(tree) # make tree look nice

new_tips = read.csv('figures/uto-tiplabels.csv', stringsAsFactors = FALSE)
tree$tip.label = new_tips$new

offset = 0.005
pdf('figures/uto-iroquoi-crosscousinmarriage.preferred.pdf', width = width * 0.5, height = height / 3)
p = plot(tree,lwd=6, show.tip.label = TRUE, type = "phylogram", label.offset = offset, 
     cex = 0.5, font = 1, align.tip.label = TRUE, no.margin = TRUE)
tiplabels(node = d[,1], pch = 21, bg = d[,1], col = "black", cex = 1, align.tip.label = TRUE)
tiplabels(node = d[,2], pch = 22, bg = d[,2], col = "black", cex = 1, offset = offset * 5/6)
dev.off()

# austronesian
d = read.table('data/co-evo/austronesian-iroquois-cross.cousinmarriage.preferred.btdata',row.names = 1)
d = apply(d, 2, function(c) ifelse(c == 1, "#E41A1C", "white"))

t = read.nexus('data/co-evo/austronesian-iroquois-cross.cousinmarriage.preferred.bttrees')
tree = t[[1]]
tree = ladderize(tree) # make tree look nice

new_tips = read.csv('figures/aust-tiplabels.csv', stringsAsFactors = FALSE)
tree$tip.label = new_tips$new

offset = 280
pdf('figures/austronesian-iroquoi-crosscousinmarriage.preferred-twopoint.pdf', width = width * 0.8, height = height * 0.9)
p = plot(tree,lwd=9, show.tip.label = TRUE, type = "phylogram", label.offset = offset, 
         cex = 0.5, font = 1, align.tip.label = TRUE, no.margin = FALSE)
tiplabels(node = d[,1], pch = 21, bg = d[,1], col = "black", cex = 1, align.tip.label = TRUE)
tiplabels(node = d[,2], pch = 22, bg = d[,2], col = "black", cex = 1, offset = offset * 2/3)
dev.off()