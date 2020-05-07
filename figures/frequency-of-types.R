library(dplyr)
library(patchwork)

files = list.files('data/anc-state/', pattern = '*.btdata', full.names = TRUE)

d = lapply(files, read.csv, header = FALSE, sep = "\t")
n = lapply(d, nrow) %>% unlist()

d = do.call(rbind, d)
d$Language.Family = rep(c("Austronesian", "Bantu", "Uto-Aztecan"), times = n)

kincodes = read.csv('data/kincodes', header = FALSE)

d = left_join(d, kincodes, by = c("V2"="V1"))
d$V2 = factor(d$V2)

p1 = ggplot(d, aes(x = V2.y, fill = Language.Family, group = Language.Family)) + 
  geom_bar() + 
  facet_wrap(~Language.Family) + 
  ggtitle('Counts by language family') + 
  xlab('') + theme(legend.position = "none", axis.text.x = element_text(angle = 90, hjust = 1))

d2 = d %>% 
  group_by(Language.Family, V2.y) %>% 
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

p3 = ggplot(d2, aes(y = freq, x = V2.y, fill = Language.Family, group = Language.Family)) + 
  geom_bar(stat = 'identity', position = 'dodge') +
  ggtitle("Relative frequency")  + 
  xlab('') + ylab('Percent of total by Language family') +
  theme(legend.position = "none")

p1 / p3
