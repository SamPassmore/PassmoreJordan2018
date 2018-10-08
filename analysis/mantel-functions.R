library(vegan)
## Analyses and organises the analyses of binary kin terms with a mantel test
## output is a matrix
pretty_mantel = function(m1, m2_list){
  mantel = lapply(m2_list, function(x) mantel.test(m1, x)[c('z.stat', 'p')])
  mantel_table = do.call(rbind, lapply(mantel, unlist))
  mantel_table = cbind(mantel_table, bonferroni =  p.adjust(mantel_table[,"p"], 
                                     method = "bonferroni", n = nrow(mantel_table)))
  rownames(mantel_table) = gsub('Nice_Kinterms', '', rownames(mantel_table))
  mantel_table
}

## Analyses nd organises partial mantel tests of binary kin terms
## output is a matrix
pretty_partialmantel = function(x,y_list,z){
  mantel = lapply(y_list, function(y) mantel.partial(x, y, z)[c('statistic', 'signif')])
  mantel_table = do.call(rbind, lapply(mantel, unlist))
  mantel_table = cbind(mantel_table, bonferroni =  p.adjust(mantel_table[,"signif"], 
                                     method = "bonferroni", n = nrow(mantel_table)))
  rownames(mantel_table) = gsub('Nice_Kinterms', '', rownames(mantel_table))
  mantel_table
}

create_geo_matrix = function(d){
  sp::spDists(cbind(d$Lat,d$Long), longlat = TRUE)
}

create_phy_matrix = function(tr){
  cophenetic(tr)
}

## Creates a square 'distance' matrix for each binary kin-term. 
## Output is a list
create_binary_matrix = function(d){
  binary_variables = model.matrix(~0+name, data = d)
  available_kinterms = colSums(binary_variables) > 0
  binary_variables = binary_variables[,available_kinterms]
  variable_names = colnames(binary_variables)
  
  d = cbind(d, binary_variables)
  
  kinship_matrices = lapply(d[,variable_names], function(x) 
    sp::spDists(x = cbind(x, x))) 
  kinship_matrices = lapply(kinship_matrices, function(x) ifelse(x > 0, 1, 0))
  
  kinship_matrices
}
