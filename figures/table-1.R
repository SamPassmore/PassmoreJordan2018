# make table 1
library(stringr)
library(excdr)
library(reshape2)

mcmc = read.csv('analysis/coevo-settings.csv', stringsAsFactors = FALSE)

stones_1 = list.files('results/co-evolutionary/run-1/', full.names = TRUE,
                      pattern = "*.Stones.txt")

results = matrix(NA, ncol = 2, nrow = nrow(mcmc))
for(i in 1:nrow(mcmc)){
  hypotheses = mcmc$job[i]
  
  idx = str_detect(stones_1, hypotheses)
  s1 = stones_1[idx]
  s1 = lapply(s1, read.stones)
  
  BF = 2 * (s1[[1]] - s1[[2]])
  
  results[i,] = c(hypotheses, round(BF, 2))
}

results = data.frame(hypotheses = as.character(results[,1]),
                        BF = as.numeric(results[,2]))
results$language.family = str_split(results$hypotheses, "-") %>% 
  sapply(extract2, 1)
results$hypotheses2 = str_split(results$hypotheses, "-", n = 2) %>% 
  sapply(extract2, 2) %>% 
  str_replace("-", " & ") %>% 
  str_replace("\\.", " ")

table1 = dcast(results[,2:4], hypotheses2 ~ language.family, value.var = "BF")
colnames(table1) = c("hypotheses", "AN", "BT", "UA")
write.csv(table1, file = "figures/table-1.csv", na = "", 
          row.names = FALSE)
