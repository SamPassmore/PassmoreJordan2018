rm(list = ls())

library(excdr)
library(stringr)

source('helper.R')

# identify all fossilized chain files
log_file_names = list.files("fossilize-bantu/", pattern = ".Log.txt",
                            recursive = TRUE, full.names = TRUE)

labels = str_extract(log_file_names, "([A-Z]{1}[a-z]+)")

# read in bantu results
fossilized = lapply(log_file_names, read.bayestraits)
names(fossilized) = labels

# plot MCMC chains
lapply(seq_along(fossilized), function(i){
  plot(fossilized[[i]]$Lh, type = 'l', main = labels[i])
})

lapply(seq_along(fossilized), function(i){
  l = mcmc(fossilized[[i]]$Lh)
  acf(l, main =  labels[i])
})

# average likelihood across all models
mean_likelihood = lapply(fossilized, function(x) mean(x$Lh)) %>%
  unlist()
mean_likelihood * -2

# get stones files
stone_file_names = list.files("fossilize-bantu/", pattern = ".Stones.txt",
                            recursive = TRUE, full.names = TRUE)

marg_likelihoods = lapply(stone_file_names, get_marginal_likelihood) %>%
  unlist()
names(marg_likelihoods) = labels

# BF between all fossilized results
outer(marg_likelihoods, marg_likelihoods, function(x,y) (-2 * (x - y)))
