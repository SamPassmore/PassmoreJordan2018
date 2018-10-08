phylo.d_wrapper = function(d, tr){
  require(excdr)
  require(caper)
  
  # make binary variables
  binary_vars = model.matrix(~0+name, data = d) %>% 
    as.data.frame()
  # only keep with more than 1 occurance
  binary_vars = binary_vars[,colSums(binary_vars) > 1]
  # attach taxa
  binary_vars$taxa = d$taxa
  
  # calcualte phylo.d
  r = map(colnames(binary_vars)[-ncol(binary_vars)],
          function(x) {
            phylo.d2(binary_vars, tr)
          })
}


phylo.d2 = function(d, tr){
  library(caper)
  data = d
  
  data$name = ifelse(data$name == "Mixed or variant", "Mixed", as.character(data$name))
  
  ## Make binary variables
  binary_vars = model.matrix(~0+name, data = data)
  available_kinterms = colSums(binary_vars) %>% 
    subset(., . > 0) %>% 
    names()
  binary_vars = cbind(binary_vars, taxa = data$taxa %>% as.character()) %>%
    as.data.frame()
  
  #tree = makeditree(obj$tree)
  empty_row = rep(NA, 5)
  results = list()
  
  if('nameEskimo' %in% available_kinterms){    
    results[[1]] = phylo.d(data = binary_vars, phy = tr, names.col = taxa,
                           binvar = nameEskimo) %>%
      format_phylo.d(.)
  } else {
    results[[1]] = empty_row
  }
  
  if('nameHawaiian' %in% available_kinterms){
    results[[2]] = phylo.d(binary_vars,tr,taxa,nameHawaiian) %>%
      format_phylo.d(.)
  } else {
    results[[2]] = empty_row
  }
  
  if('nameIroquois' %in% available_kinterms){
    results[[3]] = phylo.d(binary_vars,tr,taxa,nameIroquois) %>%
      format_phylo.d(.)
  } else {
    results[[3]] = empty_row
  }
  if('nameOmaha' %in% available_kinterms){
    results[[4]] = phylo.d(binary_vars,tr,taxa,nameOmaha) %>%
      format_phylo.d(.)
  } else {
    results[[4]] = empty_row
  }
  
  if('nameSudanese' %in% available_kinterms){
    results[[5]] = phylo.d(binary_vars,tr,taxa,nameSudanese) %>%
      format_phylo.d(.)
  } else {
    results[[5]] = empty_row
  }
  
  if('nameMixed' %in% available_kinterms){
    results[[6]] = phylo.d(binary_vars,tr,taxa,nameMixed) %>%
        format_phylo.d(.)
  } else {
    results[[6]] = empty_row
  }
  
  if('nameCrow' %in% available_kinterms){
    results[[7]] = phylo.d(binary_vars,tr,taxa,nameCrow) %>%
      format_phylo.d(.)
  } else {
    results[[7]] = empty_row
  }
  
  if('nameDescriptive' %in% available_kinterms){
    results[[8]] = phylo.d(binary_vars,tr,taxa,nameDescriptive) %>%
      format_phylo.d(.)
  } else {
    results[[8]] = empty_row
  }
  
  results = results %>% do.call(rbind, .)
  dimnames(results) = list(c('Eskimo', 'Hawaiian', 'Iroquois', 'Omaha', 'Sudanese',
                             'Mixed', 'Crow', 'Descriptive'),
                           c('Absent', 'Present', 'D_Estimate', 'Brownian_Prob', 'Random_Prob'))
  results[!is.na(results[,1]),]
}

## Organises Phylo-d output for a summary table 
## Output is a vector 
format_phylo.d = function(x){
  if(class(x) != 'try-error')
    c(
      Absent = x$StatesTable[1],
      Present = x$StatesTable[2],
      EstimateD = x$DEstimate,
      BrownianProb = x$Pval0,
      RandomProb = x$Pval1
    )
  else{
    rep(NA, 5)
  }
}

pretty_signal_summary = function(pd, mg, mlg, gpm, pm, ppm){
  pd_tble = pd %>% .[!is.na(pd[,1]),] %>%
    .[order(rownames(.)),c(1:5)]
  rownames(pd_tble) = paste0("name", rownames(pd_tble))
  
  mg_tble = mg[order(rownames(mg)),1:3]
  colnames(mg_tble) = paste0('MG_', colnames(mg_tble))
  
  
  mlg_tble = mlg[order(rownames(mlg)), 1:3]
  colnames(mlg_tble) = paste0('MLG_', colnames(mlg_tble))
  
  pm_tble = pm[order(rownames(pm)),1:3]
  colnames(pm_tble) = paste0('MP_', colnames(pm_tble))
  
  gpm = gpm[order(rownames(gpm)),]
  colnames(gpm) = paste0('GM_G_CtlP_', colnames(gpm))
  
  ppm = ppm[order(rownames(ppm)),]
  colnames(ppm) = paste0('PM_P_CtlG_', colnames(ppm))
  
  data.frame(pd_tble, mg_tble, mlg_tble, gpm, pm_tble, ppm)
}

summary.signal_tests = function(s){
  library(plyr)
  summary.mean = aaply(laply(s, as.matrix), c(2,3), mean)
  summary.median = aaply(laply(s, as.matrix), c(2,3), median)
  summary.sd = aaply(laply(s, as.matrix), c(2,3), sd)
  list(mean = summary.mean, median = summary.median, sd = summary.sd)
}

signal_tests = function(d, tr){
  
  rownames(d) = d$taxa
  d$name = droplevels(d$name)
  
  ## Checks
  if(!all(d$taxa %in% tr$tip.label))
    stop('data and tree taxa don\'t match')
  
  ## Phylo-d 
  #pd = phylo.d_wrapper(d, tr)
  pd = phylo.d2(d, tr)
  
  ## Mantel inputs
  kinship_matrix = create_binary_matrix(d)
  geographic_matrix = create_geo_matrix(d)
  loggeographic_matrix = log(geographic_matrix)
  loggeographic_matrix[loggeographic_matrix == -Inf] = 0
  phylogenetic_matrix = create_phy_matrix(tr)
  
  ## Mantel Geographic
  mg = pretty_mantel(geographic_matrix, kinship_matrix)
  mlg = pretty_mantel(loggeographic_matrix, kinship_matrix)
  
  ## Mantel Phylogenetic
  mp = pretty_mantel(phylogenetic_matrix, kinship_matrix)
  
  ## Partial Mantel log-Geo controlling for Phylogeny
  pmg = pretty_partialmantel(loggeographic_matrix, kinship_matrix, phylogenetic_matrix)
  
  ## Partial Mantel Phylogeny controling for log-Geographic
  pmp = pretty_partialmantel(phylogenetic_matrix, kinship_matrix, loggeographic_matrix)
  
  pretty_signal_summary(pd, mg, mlg, pmg, mp, pmp)
}

makeditree = function(tree){
  require(ape)
  if(!is.binary.tree(tree))
    tree = multi2di(tree, random=FALSE)
  if(!is.rooted(tree))
    warning('Tree is still unrooted after making dichotomous')  
  
  ## Add a small amount to any zero-length tree branches 
  tree$edge.length[tree$edge.length == 0] = .001
  
  tree
}