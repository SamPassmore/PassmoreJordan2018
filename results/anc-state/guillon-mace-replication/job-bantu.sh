#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=90:00:00
#PBS -o logs/bantu-output.txt
#PBS -e logs/bantu-error.txt

# Define working directory
export WORK_DIR=$HOME/terminology-anc-state/guillon-mace-replication/

# Change into working directory
cd $WORK_DIR

# record some potentially useful details about the job:
echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`
echo PBS job ID is $PBS_JOBID
echo This jobs runs on the following machines: echo `cat $PBS_NODEFILE | uniq`

module load apps/bayestraits-3

datetime=$(date +%d-%b-%Y-%H_%M)

output=$(basename $data)
output="${output%.*}"


HOME=$(pwd)

# Ancestral state
BayesTraitsV3 $HOME/bantu.bttrees $HOME/bantu.btdata << ANSWERS
1
2
Stones 100 1000
RevJump uniform 0 100
Iterations 1000000000
Sample 50000
LogFile $HOME/bt-output/$output_$datetime-uniform100
EqualTrees 2000
run
ANSWERS
    
