library(excdr)
library(stringr)
library(dplyr)
library(tidyr)

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

an = read.bayestraits(filename = 'results/anc-state/austronesian/scale_trees1.Log.txt')
# check mcmc chain
plot(tail(an$Lh, 10000), type = 'l')
# seems fine
an_ms = modelstring_frequencies(tail(an, 10000))
write.csv(an_ms, 'results/transition-rates/austronesian-st.csv')

# get the rates
idx_rates = str_detect(colnames(an), "q")
hist_data = an[,idx_rates] %>% gather() 
ggplot(gather(hist_data), aes(value)) + 
  geom_histogram(bins = 10) + 
  facet_wrap(~key, scales = 'free_x')
apply(an[,idx_rates], 2, summary)

# top 10 frequent models 
an$`Model string` %>% 
  table() %>% 
  sort(decreasing = TRUE) %>%
  head(., 10)

bt = read.bayestraits('results/anc-state/bantu/scale_trees1.Log.txt')
plot(bt$Lh, type = 'l')
bt_ms = modelstring_frequencies(tail(bt, 10000))
write.csv(bt_ms, 'results/transition-rates/bantu-st.csv')

bt$`Model string` %>% 
  table() %>% 
  sort(decreasing = TRUE) %>%
  head(., 10)

#ua = read.bayestraits('results/anc-state/utoaztecan/26-Oct-2017-09_54.Log.txt')
ua = bt_read.log('results/anc-state/utoaztecan/scale_trees1.Log.txt')
plot(ua$Lh, type = 'l')
ua_ms = modelstring_frequencies(tail(ua, 10000))
write.csv(ua_ms, 'results/transition-rates/utoaztecan-st.csv')

ua$`Model string` %>% 
  table() %>% 
  sort(decreasing = TRUE) %>%
  head(., 10)

