library(ape)
library(phytools)
library(bayestraitr)

uto = read.nexus('data/anc-state/utoaztecan.bttrees')

# make a consensus tree for simulating
uto_con = phytools::consensus.edges(uto)
uto_con = pbtree(n=300,scale=1)

# transitions to aa or bb are high, but all other transition unlikely
# see http://blog.phytools.org/2014/12/simulating-correlated-evolution-of.html
#Q<-matrix(c(0,0.4,0.4,0,2,0,0,2,2,0,0,2,0,0.4,0.4,0),4,4,byrow=TRUE)
 Q<-matrix(c(0,1.5,1.5,0,2,0,0,2,2,0,0,2,0,1.5,1.5,0),4,4,byrow=TRUE)
dimnames(Q) = list(c("aa","ab","ba","bb"),
                   c("aa","ab","ba","bb"))
diag(Q) = -rowSums(Q)
Q

## random single trait
Q<-matrix(c(-1,1,1,-1),2,2)
rownames(Q)<-colnames(Q)<-letters[1:2]

# # get rates from strongest co-evo result Crow & matrilineal
# new_q = bt_read.log('results/co-evolutionary/run-1/austronesian-crow-matrilineal-dep1.Log.txt')
# 
# v = colMeans(new_q[,8:15])

sims = sim.history(uto_con, Q, nsim = 100, message=TRUE)

lapply(sims, function(x) table(x$states))

# trait 1
t1 = mergeMappedStates(sims,c("aa","ab"),"a")
t1 = mergeMappedStates(t1,c("ba","bb"),"b")
# trait 2
t2 = mergeMappedStates(sims,c("aa","ba"),"a")
t2 = mergeMappedStates(t2,c("ab","bb"),"b")

t1$states<-getStates(t1,"tips")
t2$states<-getStates(t2,"tips")
