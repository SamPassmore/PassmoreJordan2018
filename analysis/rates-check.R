#devtools::install_github('SamPassmore/excdr')

library(bayestraitr)
library(stringr)
library(ape)

an_log = bt_read.log('results/anc-state/austronesian/scale_trees1.Log.txt')

idx = str_detect(colnames(an_log), "q")
rates = apply(an_log[,idx], 2, median)

conversion = as.numeric(attributes(an_log)$settings$`Scale Tree:`)
mean(an_log$`Global Rate`) / conversion

# The trees used in this analyses stated out as
# 1 = 1000 years
# And then were divided by a constant of 100 so
# 1 = 10 000
# To get this to 1 = 1 year we would need to multiply by 1000 * 100
constant = 1000 * 100

# Email from A. Meade says as branch lengths are doubled, rates are halved
# In this case branch lengths have been reduced by constant, therefore rates should increase by that constant
# So to get rates to equate to branch lengths they need to be divided by the constant and then multiplied by years?
sort((rates / constant) * 10000)

## AN important rates are Eskimo to Hawaiian (34) & 
# Hawaiian to Iroquois (45)
sort((rates / constant) * 10000)[c("q34", "q45")]

## Bantu there were no important transistion (but have a look anyway)

bt_log = bt_read.log('results/anc-state/bantu/scale_trees1.Log.txt')
bt_tr = read.nexus('data/anc-state/bantu.bttrees')
bt_tr$tree.555480000.61472.749694$edge.length %>% max(.)
bt_dplace = read.nexus('https://raw.githubusercontent.com/D-PLACE/dplace-data/master/phylogenies/dunn_et_al2011_utoaztecan/posterior.trees')
# original tree is 1 = 100 years
# the is divided by 100 
# so constant is 
constant = 100 * 100


idx = str_detect(colnames(bt_log), "q")
rates = apply(bt_log[,idx], 2, median)
sort((rates / constant) * 10000)

## UA important rates were Hawaiian to Iroquois (45), 
# Hawaiian to Eskimo (43) & Hawaiian to Crow (41)
ua_log = bt_read.log('results/anc-state/utoaztecan/scale_trees1.Log.txt')
#ua_log = bt_read.log('../terminology-anc-state/bt-output/utoaztecan/.Log.txt')

#ua_tr = read.nexus('data/anc-state/utoaztecan.bttrees')
ua_tr = read.nexus('../terminology-anc-state/data/utoaztecan-2.bttrees')
ua_dplace = read.nexus('https://raw.githubusercontent.com/D-PLACE/dplace-data/master/phylogenies/dunn_et_al2011_utoaztecan/posterior.trees')

# If I use the new analyses w/ the DPLACE tree
# The dplace tree is 
# 1 = 1000 years
# Then I divided by 100 so
# 1 = 10 000 years
# So to go back
constant = 100 * 1000

idx = str_detect(colnames(ua_log$output), "q")
rates = apply(ua_log$output[,idx], 2, median)
sort((rates / constant) * 10000) %>% sort(.)
sort((rates / constant) * 10000)[c("q45", "q43", "q41")] %>% 
  sort(.)

plot(ua_log$output$`Global Rate` %>% sort(.))

median(ua_log$output$`Global Rate` / constant) * 10000


## Global rates per 1000 years?
conversion = as.numeric(attributes(an_log)$settings$`Scale Tree:`)
mean(an_log$`Global Rate`) / conversion

conversion = as.numeric(attributes(bt_log)$settings$`Scale Tree:`)
mean(bt_log$`Global Rate`) / conversion

conversion = as.numeric(attributes(ua_log)$settings$`Scale Tree:`)
mean(ua_log$`Global Rate`) / conversion
