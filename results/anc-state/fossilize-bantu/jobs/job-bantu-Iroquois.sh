#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=99:00:00
#PBS -o /panfs/panasas01/arch/sp16194/terminology-anc-state/fossilize-bantu/logs/bantu-Iroquois-fossilize-output.txt
#PBS -e /panfs/panasas01/arch/sp16194/terminology-anc-state/fossilize-bantu/logs/bantu-Iroquois-fossilize-error.txt

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
Iterations 1000000000
Sample 50000
RevJump exp 10
Stones 100 1000
AddTag root Tiv_Tivoid A24_Duala A75a_Fang_Bitam C41_Ngombe C61_Mongo C83_Bushong D211_Kango D24_Songola B85d_Nsongo B86_Dinga B84_Mbunda H31_Yaka H32_Suku H41_Mbala L11_Pende L35_Sanga L41_Kaonde L52_Lunda K11_Ciokwe K14_Lwena K21_Lozi R11_Umbundu R31_Herero JD53_Shi JD62_Rundi JD66_Kiha JE11_Runyoro JE15_Luganda JE16_Lusoga JE22_Haya JE24_Kerebe JE31_Lumasaaba JE31c_Bukusu E51_Kikuyu E622A_Kimochi E71A_Upper_Pokomo E72a_Giryama F21_Sukuma F23_Sumbwa F32_Nyaturuwil G11_Gogo G12_Kagulu G32_Kwere G34_Nguungulu G35_Luguru G61_Sangu G62_Hehe G63_Bena M11_Pimbwe M13_Fipa M31_Nyakyusa M42_Bemba M41_Taabwa M52_Lala M54_Lamba M64_Tonga N12_Ngoni N21_Tumbuka_Malawi N31_Chewa N42_Kunda P21_Yao P23_Simakonde S11_Shona S21_Venda S31_Tswana S41_Xhosa S42_Zulu S44_Ndebele S53_Tsonga
Fossil Node01 root 5
LogFile fossilize-bantu/output/Iroquois_$DATE;
run;
ANSWERS
