library(purrr)
library(ape)
library(stringr)

dplace = read.csv('https://raw.githubusercontent.com/D-PLACE/dplace-data/master/datasets/EA/societies.csv')

# terminological data
d_files = list.files('data/', pattern = "*.btdata", full.names = T)
d = map(d_files, read.table)
names(d) = basename(d_files)

# phylogeny to d-place data
link_files = list.files('~/Google Drive/UniWork/datasets/d-place/Phylogeny_to_Data/', 
                        pattern = "(austronesian|bantu|indoeuropean|utoaztecan)", full.names = TRUE)
link = map(link_files, read.csv)
# always take the first xd_id 
link2 = map(link, function(x){
  x$xd_id = str_extract(x$xd_id, "^([^,])+")
  x
})

# merge dplace and tree tip DF & make location files
for(i in seq_along(link2)){
  dplace2 = dplace
  dplace2 = left_join(dplace2, link2[[i]], 
                      by = c("xd_id"))
  locations = dplace2 %>%
    filter(Name_on_tree_tip %in% d[[i]]$V1) %>% 
    select(Name_on_tree_tip, Lat, Long)
 
  fname = paste0("data/",
    basename(d_files[[i]]) %>% 
                   tools::file_path_sans_ext(), "_locations.csv")
  write.csv(locations, fname)  
}


