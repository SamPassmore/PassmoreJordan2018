plot.mcmcchain = function(log, main = ""){
  #log$group = ifelse(log$Lh > group, 1, 2)
  
  p1 = ggplot(log, aes(x = Iteration, y = Lh)) +
    geom_line() + ggtitle(main)
  
  p1b = ggplot(log, aes(x = Lh)) +
    geom_histogram() + ggtitle('Likelihood histogram')

  # root_cols = str_detect(colnames(log), "^Root|group")
  # roots = melt(log[,root_cols], id.vars = "group")
  # 
  # p3 = ggplot(roots, aes(y = value, x = variable)) +
  #   geom_boxplot() + ggtitle('Root Prob.')
  
  grid.arrange(p1, p1b, ncol = 1)
}
