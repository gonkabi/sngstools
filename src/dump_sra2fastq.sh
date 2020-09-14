### dump_sra2fastq.sh  ###
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
INPUT=$3"ncbi/public/sra/"$ID_SRR".sra"
OUTDIR=$3"ncbi/public/fastq/"
FASTQ_FILE=$OUTDIR$ID_SRR"*.fastq"

fasterq-dump $INPUT -O $OUTDIR -e $2
pigz -p $2 $FASTQ_FILE

## Log %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo "=== Information ==="
date
pwd
qstat
echo "==================="
