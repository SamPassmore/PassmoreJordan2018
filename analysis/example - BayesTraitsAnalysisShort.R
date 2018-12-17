############################################################################
require(coda)
library(excdr)

### Load BayesTraits runs (we ran each chain three time)
## You will need to modify the log file from bayes trait.
## - First there is some information about the run above the header that does not load properly into R.
##    You need to delete this.
## - Second, there is an apostrophe (') at the end of all of hte entries in the "Model String" column  that you need to delete
##  (find and replace works for this)
## Diagnostics
Run1 <- read.bayestraits("results/co-evolutionary/run-1/austronesian-iroquois-cross.cousinmarriage.permitted-dep1.Log.txt")
Run2 <- read.bayestraits("results/co-evolutionary/run-2/austronesian-iroquois-cross.cousinmarriage.permitted-dep2.Log.txt")
Run3 <- read.bayestraits("results/co-evolutionary/run-3/austronesian-iroquois-cross.cousinmarriage.permitted-dep3.Log.txt")

## Trim burnin if relevant
# Run1 <- Run1[which(Run1$Iteration > 5000000), ]
# Run2 <- Run2[which(Run2$Iteration > 5000000), ]
# Run3 <- Run3[which(Run3$Iteration > 5000000), ]


## Pool Chains
Runs <- rbind(Run1, Run2, Run3)

##### This is where we start comparing differences between two rates of interest
##### (for example in our paper: the rate of eolvution from small to big brains in stable (q13) versus variable environments(q24))
## Summary statistics for estimates of q13
mean(Runs$q13)
sd(Runs$q13)
## Summary statistics for estimates of q24
mean(Runs$q24)
sd(Runs$q24)
## Calculate differences between two rates at each step
CB <- Run1$q13 - Run1$q24
## Frequency of steps where rates were set to equal
CB.f <- length(CB[which(CB == 0)])/length(CB)
## This is where the bayesfactor is calculated based on the equation in the supplemental materials of Barbeitos
## (Also originally in Pagel's 2006 paper on reversible jump)
## ObservedDifferent/ObservedSame * ExpectedSame/ExpectedDifferent
## The expected values are calculated using the Stirling Numbers set. Barbeitos works through these for a number of
## conditions (independent vs dependent; two rates being the same or different). There may be other conditions of interest,
## but i can't really help you there
BF.1 <- ((1-CB.f)/CB.f)*(0.0408/0.9592)
## Repeat for additional runs
## Ultimately a Bayes factor > 3 as positive support; > 12 strong support
CB <- Run2$q13 - Run2$q24
CB.f <- length(CB[which(CB == 0)])/length(CB)
BF.2 <- ((1-CB.f)/CB.f)*(0.0408/0.9592)
CB <- Run3$q13 - Run3$q24
CB.f <- length(CB[which(CB == 0)])/length(CB)
BF.3 <- ((1-CB.f)/CB.f)*(0.0408/0.9592)
## Average BayesFactor. These should all be very similar unless something is wrong with your chain convergence.
mean(c(BF.1, BF.2, BF.3))

### Here is code for the diagnostics we used: Gelman and effective sample size
### Gelman
idx = 8:15
Run.list <- list()
Run.list[[1]] <- as.mcmc(Run1[, idx])
Run.list[[2]] <- as.mcmc(Run2[, idx])
Run.list[[3]] <- as.mcmc(Run3[, idx])

gelman.diag(Run.list)

effectiveSize(Run1[, idx])
effectiveSize(Run2[, idx])
effectiveSize(Run3[, idx])

