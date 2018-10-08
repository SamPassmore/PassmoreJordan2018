library(excdr)
library(stringr)
library(dplyr)

modelstring_frequencies = function(results){
  # get column names
  cn_results = colnames(results)
  # find transition columns
  #q = results[,str_detect(cn_results, "q")] 
  
  # get model string and seperate it out
  ms = results$`Model string` %>% 
    str_remove('[\']') %>% 
    trimws() %>% 
    str_split('\\s') %>% 
    do.call(rbind, .) 
  # then get counts of estimates for each parameter
  ms2 = list()
  for(i in 1:ncol(ms)){
    ms2[[i]] = table(ms[,i])
  }
  
  # possible states for this lang-fam
  states = lapply(ms2, names) %>% 
    unlist() %>% 
    unique() %>% 
    sort()
  # build a matrix of posible states
  occurances = matrix(NA, nrow = length(ms2), ncol = length(states))
  dimnames(occurances) = list(cn_results[str_detect(cn_results, "q")], states)
  
  # fill matrix
  for(i in seq_along(ms2)){
    row = ms2[[i]]
    occurances[i,names(row)] = row
  }
  occurances  
}

an = read.bayestraits(filename = 'results/anc-state/austronesian/26-Oct-2017-09_53.Log.txt')
# check mcmc chain
plot(tail(an$Lh, 10000), type = 'l')
# seems fine
an_ms = modelstring_frequencies(tail(an, 10000))
write.csv(an_ms, 'results/transition-rates/austronesian.csv')

# top 10 frequent models 
an$`Model string` %>% 
  table() %>% 
  sort(decreasing = TRUE) %>%
  head(., 10)

bt = read.bayestraits('results/anc-state/bantu/26-Oct-2017-09_53.Log.txt')
plot(bt$Lh, type = 'l')
bt_ms = modelstring_frequencies(tail(bt, 10000))
write.csv(bt_ms, 'results/transition-rates/bantu.csv')

bt$`Model string` %>% 
  table() %>% 
  sort(decreasing = TRUE) %>%
  head(., 10)

ua = read.bayestraits('results/anc-state/utoaztecan/26-Oct-2017-09_54.Log.txt')
plot(ua$Lh, type = 'l')
ua_ms = modelstring_frequencies(tail(ua, 10000))
write.csv(ua_ms, 'results/transition-rates/utoaztecan.csv')

ua$`Model string` %>% 
  table() %>% 
  sort(decreasing = TRUE) %>%
  head(., 10)


# ie = read.bayestraits('bt-output/indoeuropean/20-Jul-2018-10_00.Log.txt')
# plot(ie$Lh, type = 'l')
# ie_ms = modelstring_frequencies(tail(ie, 1000))
# write.csv(ie_ms, 'transition-rates/ie.csv')


ie$`Model string` %>% 
  table() %>% 
  sort(decreasing = TRUE) %>%
  head(., 10)

## merge all together

