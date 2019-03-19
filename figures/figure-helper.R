kinship_to_colours = function(codes){
  plyr::mapvalues(codes, from = 1:8, 
            to = c(
              "#E41A1C",
              "#377EB8",
              "#4DAF4A", 
              "#984EA3",
              "#FF7F00",
              "#FFFF33", 
              "#A65628",
              "#F781BF"
            )
  )
}

mirrored_phylogeny = function(d, tree, title = ""){
  rownames(d) = d[,1]
  d[,2:3] = apply(d[,2:3], 2, function(c) ifelse(c == 1, "#E41A1C", "white"))
  d = d[tree$tip.label,]
  par(mar = rep(0, 4))
  # layout organise the plot into thirds
  layout(matrix(1:3,1,3),widths=c(0.39,0.20,0.39))
  # plot the first tree + labels
  plot(tree,lwd=6, show.tip.label = FALSE, no.margin = TRUE)
  tiplabels(node = d[tree$tip.label,2], pch = 21, bg = d[tree$tip.label,2], col = "black", cex = 1.5)
  # move to the next plot
  plot.new()
  # size that plot appropriately
  plot.window(xlim=c(-0.1,0.1),
              ylim=get("last_plot.phylo",envir=.PlotPhyloEnv)$y.lim)
  
  mtext(text = title, outer = TRUE, font = 1, line = -1)
  par(cex=0.6)
  # plot the taxa names
  text(rep(0,length(tree$tip.label)),1:Ntip(tree),
       gsub("_"," ", tree$tip.label[tree$edge[tree$edge<tree$Nnode]]),font=1)
  # plot the thrid tree in new section
  plot(tree,lwd=6, show.tip.label = FALSE, direction = 'leftwards', no.margin = TRUE)
  tiplabels(node = d[,2], pch = 21, bg = d[,3], col = "black", cex = 1.5)
}
