library(dplyr)
library(circlize)
library(RColorBrewer)
library(paletteer)
library(stringr)
source('figures/figure-helper.R')

kincodes = read.csv('data/kincodes', header = FALSE, stringsAsFactors = FALSE)
kincodes$cols = kinship_to_colours(kincodes$V1)
kincodes = kincodes[c(-2,-8),]

files = list.files('results/transition-rates/', pattern = "-st.csv", full.names = TRUE)
transition_matrix = list()
for(i in seq_along(files)){
  t = read.csv(files[i])
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
  
  transition_matrix[[i]] = t2
}

transition_matrix[[1]]$family = "austronesian"
transition_matrix[[2]]$family = "bantu"
transition_matrix[[3]]$family = "uto"

transition_matrix = do.call(rbind, transition_matrix)

set.seed(123)
data = data.frame(
  factor = rep(kincodes$V2, each = 10),
  x = rnorm(60), 
  y = runif(60, min = 79, max = 81)
)
data = left_join(data, kincodes, by = c("factor" = "V2"))

# Initialize the plot.
#cols = paletteer_d('palettetown', palette = 'quilava', n = 4)[2:4]
cols = c("black", "blue", "gray")
settings = data.frame(family = c("austronesian", "bantu", "uto"),
                      cols = cols,
                      height = c(5, 7.5, 10),
                      begin = c(0.65, 0.75, 0.85),
                      arrival = c(0.15, 0.25, 0.35))
rownames(settings) = settings$family

#pdf('figures/transition-network2.pdf')
par(mar = c(1, 1, 1, 1))
circos.par("points.overflow.warning" = FALSE)
circos.initialize(factors = data$factor, xlim = c(0, 1))
# Build the regions of track #1
circos.track(ylim = c(0, 1), panel.fun = function(x, y) {
  pos = circlize:::polar2Cartesian(circlize(CELL_META$xcenter, CELL_META$ycenter))
  circos.text(CELL_META$xcenter, CELL_META$cell.ylim[1] + uy(2, "mm"),
              CELL_META$sector.index, facing = "bending.inside", niceFacing = TRUE, cex = 1.5)
}, bg.border = 1, track.height = 0.15, bg.col = unique(data$cols))

add = 0
family = ""
# Add a link between a point and another
# transition_matrix = transition_matrix %>%
#   filter(family == "bantu")
for(i in 1:nrow(transition_matrix)){
  transition = transition_matrix$transition[i] %>% 
    str_extract_all("[0-9]") %>% 
    unlist()
  terminologies = kincodes[(transition),"V2"]
  
  if(family != transition_matrix$family[i])
    add = 0
  
  family = transition_matrix$family[i]
  colour = settings[family,"cols"] %>% as.character()
  height = settings[family,"height"] %>% as.numeric()
  start = settings[family,"begin"] %>% as.numeric()
  arrive = settings[family,"arrival"] %>% as.numeric()
  rate = 1 - transition_matrix$percentage[i]

  if(rate > .9){
    circos.link(sector.index1 = terminologies[1], start + add, sector.index2 = terminologies[2], arrive + add,
                col = colour, lwd = rate * 5, arr.width = 0.4, h = height,
                directional = 1)
    add = add + 0.05
    print(rate)
  }
}
#dev.off()

