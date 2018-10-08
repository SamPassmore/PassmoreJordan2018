library(plyr)
library(dplyr)
library(purrr)

kinship_to_colours = function(codes){
  require(plyr)
  mapvalues(codes, from = 1:8, 
            to = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628","#F781BF"
            )
  )
}

an = read.csv('data/anc-state/austronesian_locations.csv')
bt = read.csv('data/anc-state/bantu_locations.csv')
ua = read.csv('data/anc-state/utoaztecan_locations.csv')

terminology_files = list.files('data/anc-state/', full.names = TRUE,
                               pattern = "*.btdata")
terminology_files = terminology_files[-3] # not IE
terminologies = map(terminology_files, read.table) %>%
  bind_rows()

location = rbind(an, bt, ua)
location = left_join(location, terminologies, by = c("Name_on_tree_tip" = "V1"))
location$colour = kinship_to_colours(location$V2)

pdf('figures/terminology-map.pdf', width = 9, height = 4)
pacific_worldmap(location$Lat, location$Long, group = location$colour)
dev.off()

