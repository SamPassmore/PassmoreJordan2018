library(igraph)
library(ggraph)
library(scales)

# == Functions == #
## The plotting function
eqarrowPlot <- function(graph, layout, 
                        edge.lty=rep(1, ecount(graph)),
                        edge.arrow.size=rep(1, ecount(graph)),
                        vertex.shape="circle",
                        edge.curved=autocurve.edges(graph), 
                        edge.width=rep(1, ecount(graph)),
                        edge.color = rep("black", ecount(graph)), ...) {
        plot(graph, edge.lty=0, edge.arrow.size=0, layout=layout,
             vertex.shape="none", edge.width = 0, edge.color = "black")
        for (e in seq_len(ecount(graph))) {
                graph2 <- delete.edges(graph, E(graph)[(1:ecount(graph))[-e]])
                plot.igraph(graph2, edge.lty=edge.lty[e], edge.arrow.size=edge.arrow.size[e],
                     edge.curved=edge.curved[e], edge.width = edge.width[e], edge.color = edge.color[e], layout=layout, vertex.shape="none",
                     vertex.label=NA, add=TRUE, ...)
        }
        plot(graph, edge.lty=0, edge.arrow.size=0, layout=layout,
             vertex.shape=vertex.shape, add=TRUE, ...)
        invisible(NULL)
}


t = read.csv('results/transition-rates/austronesian.csv')

kincodes = read.csv('data/kincodes', header = FALSE)

colnames(t) = c("transition", 1:(ncol(t)-2), "Z")
transitions = t[,2:ncol(t)]
nonzero = rowSums(transitions[,-ncol(transitions)], na.rm = TRUE)
percent = transitions$Z / rowSums(transitions, na.rm = TRUE)

t2 = data.frame(transition = t$transition, 
                parameterized = nonzero,
                zero = transitions$Z,
                percentage = percent)

t2 = t2[order(t2$percentage, decreasing = FALSE),]
rownames(t2) = NULL

t2$from = substr(t2$transition, 2, 2)
t2$to = substr(t2$transition, 3, 3)

t3 = as.matrix(t2[,c("from", "to")])

ntwrk = graph_from_edgelist(t3)


# weights to be above
above = 0.75
# scales 
#edge_weight = scales::rescale(t2$percentage, c(0, 2), range(t2$percentage))
edge_weights = t2$percentage
# scale alpha for all values above 
# edge_colour = rep(0, nrow(t2))
# edge_colour[t2$percentage > above] = scales::rescale(t2$percentage[t2$percentage > above], c(0.5, 1), 
#                                                      range(t2$percentage[t2$percentage > above]))
# 
# # edges

# E(ntwrk)$color = alpha("grey80", alpha = 0) # only colour edges > 0.5
# E(ntwrk)$color[t2$percentage > above] = alpha("red", alpha = (scales::rescale(t2$percentage[t2$percentage > above], c(0.5, 1), 
#                                                                                range(t2$percentage[t2$percentage > above]))))
# 
# # replace names
labels = data.frame(V1 = as.numeric(V(ntwrk)$name))
new_names = dplyr::left_join(labels, kincodes, "V1")
V(ntwrk)$label = as.character(new_names$V2)

# layout 
l <- layout_in_circle(ntwrk)
#l <- layout_with_r(ntwrk)
#V(ntwrk)$color = "black"

weights = ifelse(edge_weights > above, edge_weights, 0)
weights2 = weights
weights2[weights > above] = rescale(weights[weights > above], to = c(1, 3))

E(ntwrk)$weight = weights

eqarrowPlot(ntwrk,
            l,
            #edge.color = weights,
            edge.arrow.size = weights2,
            vertex.shape = "none", 
            edge.width = weights2,
            edge.curved = rep(0.2, length(weights)),
            edge.color = alpha("black", alpha = weights)
        )

plot(ntwrk, 
     vertex.label.family = "sans", 
     vertex.shape = "none",
     edge.arrow.size = 1,
     edge.width =  E(ntwrk)$weight, 
     layout=l)

# tkplot(ntwrk, 
#      vertex.label.family = "sans", 
#      vertex.shape = "none",
#      edge.arrow.size = 0.5,
#      edge.curved = 0.2,
#      edge.width = (edge_weight), 
#      layout=l)
# 
