### download_sra.sh ###
## Common Paramter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l os7
#$ -o log/
#$ -e log/

## Setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval "$(~/anaconda3/bin/conda shell.bash hook)"
conda activate ngs

## Execute %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ID_SRR=(`sed -n $SGE_TASK_ID"p" $1`)
prefetch $ID_SRR

## Log %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo "=== Information ==="
date
pwd
qstat
echo "==================="
