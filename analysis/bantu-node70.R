library(excdr)
library(stringr)
library(tidyr)

logs = read.bayestraits('results/co-evolutionary/bantu-node70/bantu-iroquois-cross.cousinmarriage.preferred-70recon-dep1.Log.txt')

idx_70 = str_detect(colnames(logs), "RecNode")

hist_data = logs[,idx_70] %>% gather() 
ggplot(gather(hist_data), aes(value)) + 
  geom_histogram(bins = 10) + 
  facet_wrap(~key, scales = 'free_x')
apply(an[,idx_rates], 2, summary)

logs[,idx_70] %>% 
  colMeans()
