#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=99:00:00
#PBS -o /panfs/panasas01/arch/sp16194/terminology-anc-state/fossilize-uto/logs/utoaztecan-Iroquois-fossilize-output.txt
#PBS -e /panfs/panasas01/arch/sp16194/terminology-anc-state/fossilize-uto/logs/utoaztecan-Iroquois-fossilize-error.txt

# Define working directory
export WORK_DIR=$HOME/terminology-anc-state/

# Change into working directory
cd $WORK_DIR

# record some potentially useful details about the job:
echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`
echo PBS job ID is $PBS_JOBID
echo This jobs runs on the following machines: echo `cat $PBS_NODEFILE | uniq`

module load apps/bayestraits-3

DATE=`date '+%Y-%m-%d_%H:%M:%S'`

BayesTraitsV3 data2/utoaztecan.bttrees data2/utoaztecan.btdata << ANSWERS
1;
2;
Iterations 1000000000
Sample 50000
RevJump exp 10
Stones 100 1000
AddTag root Cahuilla Chemehuevi ClassicalAztec Comanche Cupeno Hopi Huichol Kawaiisu Luiseno Mono NorthernPaiute NorthernTepehuan Opata Pannamint PapagoPima Serrano Shoshoni_GosiuteDialect SouthernPaiute SouthernUte Tarahumara Tubatulabel Yaqui
Fossil Node01 root 3
LogFile fossilize-uto/output/Iroquois_$DATE;
run;
ANSWERS
