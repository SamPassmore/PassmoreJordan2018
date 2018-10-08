#!/usr/bin/env Rscript
library(excdr)
library(purrr)
library(ape)
library(dplyr)
library(geiger)
library(ggplot2)
library(ggmap)

# source helper files
source('analysis/mantel-functions.R')
source('analysis/signal-functions.R')

# get the location of the data files
signal_datafiles = list.files('data/anc-state/', pattern = "*.btdata", full.names = TRUE)
signal_treefiles = list.files('data/anc-state/', pattern = "*.bttrees", full.names = TRUE)
signal_locationfiles = list.files('data/anc-state/', 
                                  pattern = "*locations.csv", full.names = TRUE)

# There should be a data, tree, and location file for each language family
length(signal_datafiles) == length(signal_datafiles) 
length(signal_datafiles) == length(signal_locationfiles)
length(signal_datafiles)

# read data
data = map(signal_datafiles, read.table, 
           col.names = c("taxa", "terminology"))
names(data) = basename(signal_datafiles)
trees = map(signal_treefiles, read.nexus)
trees = map(trees, function(t) t[is.rooted.multiPhylo(t)])
trees = map(trees, function(t) map(t, makeditree))
names(trees) = basename(signal_treefiles)
locations = map(signal_locationfiles, read.csv)

# merge data with human readable labels for kin terminologies
kincodes = read.table('data/kincodes', sep = ",", col.names = c("code", "name"))
data = map(data, function(x) left_join(x, kincodes, by = c("terminology" = "code")))

# merge with latitude & longitude 
data = map2(data, locations, function(x, y) left_join(x, y, 
                                                     by = c("taxa" = "Name_on_tree_tip")))
# only take 1000 trees
set.seed(1990)
trees = map(trees, sample, size = 1000)

# austronesian
print("Running Austronesian....")
an_signal = map(trees$austronesian.bttrees, 
                function(t) signal_tests(data$austronesian.btdata, t))

summary = summary.signal_tests(an_signal)
write.csv(summary[[1]], 'results/signal-results/an-mean.csv')
write.csv(summary[[2]], 'results/signal-results/an-median.csv')
write.csv(summary[[3]], 'results/signal-results/an-sd.csv')

# bantu
print("Running Bantu....")
bt_signal = map(trees$bantu.bttrees, 
                function(t) signal_tests(data$bantu.btdata, t))

summary = summary.signal_tests(bt_signal)
write.csv(summary[[1]], 'results/signal-results/bt-mean.csv')
write.csv(summary[[2]], 'results/signal-results/bt-median.csv')
write.csv(summary[[3]], 'results/signal-results/bt-sd.csv')

# utoaztecan
print("Running Uto-Aztecan....")
ua_signal = map(trees$utoaztecan.bttrees, 
                function(t) signal_tests(data$utoaztecan.btdata, t))

summary = summary.signal_tests(ua_signal)
write.csv(summary[[1]], 'results/signal-results/ua-mean.csv')
write.csv(summary[[2]], 'results/signal-results/ua-median.csv')
write.csv(summary[[3]], 'results/signal-results/ua-sd.csv')
beep(3)
# indo-european
# print("Running Indo-European....")
# ie_signal = map(trees$indoeuropean.bttrees, 
#                 function(t) signal_tests(data$indoeuropean.btdata, t))
# 
# summary = summary.signal_tests(ie_signal)
# write.csv(summary[[1]], 'results/signal-results/ie-mean2.csv')
# write.csv(summary[[2]], 'results/signal-results/ie-median2.csv')
# write.csv(summary[[3]], 'results/signal-results/ie-sd2.csv')
