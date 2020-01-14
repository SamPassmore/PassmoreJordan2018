#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=01:00:00
#PBS -o logs/output.txt
#PBS -e logs/error.txt

for file in /home/user/*; do
  echo ${file##*/}
done

# Define working directory 
export WORK_DIR=$HOME/terminology-anc-state/fossilize-bantu/jobs

# Change into working directory 
cd $WORK_DIR

# record some potentially useful details about the job:
echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`
echo PBS job ID is $PBS_JOBID
echo This jobs runs on the following machines: echo `cat $PBS_NODEFILE | uniq`

FILES=ls 

for f in *.sh
do
    echo $f
    qsub $f
    sleep 20
done
