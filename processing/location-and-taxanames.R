library(purrr)
library(dplyr)
library(stringr)

geo_files = list.files('data/anc-state/', pattern = "locations", 
                 full.names = TRUE)

geo = map(geo_files, read.csv)

idx_files = list.files('~/Google Drive/UniWork/d-place/Phylogeny_to_Data/', pattern = "(austronesian|bantu|utoaztecan)", full.names = TRUE)

idx = map(idx_files, read.csv)

idx = map(idx, function(x) {
  x$xd_id = str_extract(x$xd_id, "[^,$]*")
  x
  }) # get first xd_id
## merge files together

merged = map2(geo, idx, function(x, y) left_join(x, y, by = c("Cross.dataset.id" = "xd_id")))

# I know xd1293 is linked to Opata & Edueve. These are very closely related langauges so it
# doesn't really matter which of these are included. I take the first one (Opata)
merged = map(merged, function(x) x[!duplicated(x$Cross.dataset.id),])

# check 
map2(merged, geo, function(x, y) nrow(x) == nrow(y))

# make a datafram of tree tip labels, long & lat
out = map(merged, function(x) x[,c("Name_on_tree_tip", "Revised.latitude", "Revised.longitude")])

map2(out, geo_files, write.csv)

# and make one for IE
ie_phylo = read.csv('~/Google Drive/UniWork/d-place/Phylogeny_to_Data/phylogeny_indoeuropean_xdid_socid_links.csv') # dplace links to phylogenies

ie_bt = read.table('data/anc-state/indoeuropean.btdata', 
                      col.names = c("taxa", "terminology")) # BT data used
ie_location = read.csv('../Project_Kinshipsystems_ACE_Coevolution/Data/indo-european-kinship.csv', skip = 1) # location sdata

# merge bt info with phylogeny info
ie_data3 = left_join(ie_bt, ie_phylo, by = c("taxa" = "Name_on_tree_tip"))
nrow(ie_data3) == nrow(ie_bt)

# merge that with location stuff
ie_data4 = left_join(ie_data3, ie_location, by = c("xd_id" = "Cross.dataset.id"))
nrow(ie_data4) == nrow(ie_bt)

ie_out = ie_data4[,c("taxa", "Revised.latitude", "Revised.longitude")]

# note: these langauges don't have a location affiliated in d-place
ie_out[is.na(ie_out$Revised.latitude),]
# I will add these manually using the capital of these countries in Europe. 

write.csv(ie_out, 'data/anc-state/indoeuropean_locations.csv')

