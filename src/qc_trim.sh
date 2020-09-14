### qc_trim.sh  ###
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
FASTQ_FILE=$3$ID_SRR"_"$5"*.fastq.gz"

mkdir -p $4
fastqc -t $2 --nogroup -o $4 $FASTQ_FILE

## Log %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo "=== Information ==="
date
pwd
qstat
echo "==================="
