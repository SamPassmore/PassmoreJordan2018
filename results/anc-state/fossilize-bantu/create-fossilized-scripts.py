import csv
from nexus import NexusReader

dir = '/Users/sp16194/Desktop/Projects_Git/terminology-anc-state'

# get phylogeny
def get_taxa(kc):
  tree = NexusReader(dir+f'/data/{kc}.bttrees')
  taxa = []
  for t in tree.taxa:
      taxa.append(t)
  taxa_str = ' '.join(taxa)
  return taxa_str


with open(dir + "/kincodes") as file:
    reader = csv.reader(file, delimiter='\t')
    codes = {}
    for row in reader:
        codes[row[0]] = row[1]

# fossilized possibilities
fossilize = [1,2,4,5,6,7,8]

# read in iteration and sampling settings
args = [1000000000, 50000]

# BT arguments
iterations = 1000000000
sample = 50000

for f in fossilize:
    print(f)
    part_1 = f'''#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=99:00:00
#PBS -o /panfs/panasas01/arch/sp16194/terminology-anc-state/fossilize-bantu/logs/bantu-{codes[str(f)]}-fossilize-output.txt
#PBS -e /panfs/panasas01/arch/sp16194/terminology-anc-state/fossilize-bantu/logs/bantu-{codes[str(f)]}-fossilize-error.txt

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

BayesTraitsV3 data2/bantu.bttrees data2/bantu.btdata << ANSWERS
1;
2;
Iterations {args[0]}
Sample {args[1]}
RevJump exp 10
Stones 100 1000
'''
    taxa_str = get_taxa("bantu")
    part_2 = f'''AddTag root {taxa_str}
Fossil Node01 root {f}
'''
    part_3 = f'''LogFile fossilize-bantu/output/{codes[str(f)]}_$DATE;
run;
ANSWERS'''
    job_file = part_1+part_2+part_3
    with open(f"/Users/sp16194/Desktop/Projects_Git/terminology-anc-state/fossilize-bantu/jobs/job-bantu-{codes[str(f)]}.sh", "w") as text_file:
        print(job_file, file=text_file)
