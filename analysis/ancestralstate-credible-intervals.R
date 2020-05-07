# credible intervals for ancestral states

library(bayestraitr)
library(bayestestR)
library(stringr)


get_ci = function(log){
  # get ancestral columns
  idx = str_detect(colnames(log), "^R")
  
  apply(log[,idx], 2, ci, method = "HDI")
}

## an
an = bt_read.log('results/anc-state/austronesian/run_1.Log.txt')
get_ci(an)

# bt
bt = bt_read.log('results/anc-state/bantu/run_1.Log.txt')
get_ci(bt)

# ua
ua = bt_read.log('results/anc-state/utoaztecan/run_1.Log.txt')
get_ci(ua)
