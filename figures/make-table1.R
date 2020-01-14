## make table 1
library(bayestraitr)
library(snakecase)
library(reshape2)

files = list.files('results/co-evolutionary/run-1/', pattern = "Stones.txt", full.names = TRUE)

hypotheses = str_remove(files, "-[a-z]{3,5}1.Stones.txt") %>% 
  basename(.) %>%
  unique(.)


table_long = matrix(NA, ncol = 3, nrow = length(hypotheses))
for(i in 1:length(hypotheses)){
  h = hypotheses[i]
  
  # read files
  dep_file = files[str_detect(files, paste0(h, "-dep"))] %>% 
    bt_read.stones(.)
    
  indep_file = files[str_detect(files, paste0(h, "-indep"))] %>% 
    bt_read.stones(.)
  
  ## bayes factor
  bf = 2 * (indep_file$marginal_likelihood - dep_file$marginal_likelihood)
  
  # manipulate hypothesis string
  hypothesis_bits = str_split(h, "-") %>% unlist()
  language_family = hypothesis_bits[1]
  terminology = hypothesis_bits[2]
  social_structure = hypothesis_bits[3]
  
  h2 = paste0(to_upper_camel_case(terminology), " & ", to_upper_camel_case(social_structure, sep_out = " "))
  
  row = c(language_family = language_family,
                 hypothesis = h2,
                 BayesFactor = round(bf, 3))
  
  
  table_long[i,] = row
}
table_long = as.data.frame(table_long, stringsAsFactors = FALSE)
colnames(table_long) = c("language_family", "Hypothesis", "BayesFactor")
table_long$BayesFactor = as.numeric(table_long$BayesFactor)

table_wide = reshape(table_long, idvar = "Hypothesis", timevar = "language_family", direction = 'wide')
View(table_wide)
colnames(table_wide)[2:4] = c("Austronesian", "Bantu", "Uto-Aztecan")

write.csv(table_wide, 'results/co-evolutionary/table-1.csv', row.names = FALSE,quote = FALSE, na = "")

  
