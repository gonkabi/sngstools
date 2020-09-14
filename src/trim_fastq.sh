### trim_fastq.sh  ###
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
mkdir -p log
mkdir -p $3

if [ $4 = "PE" ]; then
    INPUT_FORWARD=$2$ID_SRR".sra_1.fastq.gz"
    INPUT_REVERSE=$2$ID_SRR".sra_2.fastq.gz"
    OUTPUT_FORWARD_PAIRED=$3$ID_SRR"_trim-paired_1.fastq.gz"
    OUTPUT_REVERSE_PAIRED=$3$ID_SRR"_trim-paired_2.fastq.gz"
    OUTPUT_FORWARD_UNPAIRED=$3$ID_SRR"_trim-unpaired_1.fastq.gz"
    OUTPUT_REVERSE_UNPAIRED=$3$ID_SRR"_trim-unpaired_2.fastq.gz"
    trimmomatic $4 -phred33 -threads $5 -summary ./log/trimmomatic_summary.txt $INPUT_FORWARD $INPUT_REVERSE $OUTPUT_FORWARD_PAIRED $OUTPUT_FORWARD_UNPAIRED $OUTPUT_REVERSE_PAIRED $OUTPUT_REVERSE_UNPAIRED $6
else
    INPUT=$2$ID_SRR".sra.fastq.gz"
    OUTPUT=$3$ID_SRR"_trim.fastq.gz"
    trimmomatic $4 -phred33 -threads $5 -summary ./log/trimmomatic_summary.txt $INPUT $OUTPUT $6
fi

## Log %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo "=== Information ==="
date
pwd
qstat
echo "==================="
