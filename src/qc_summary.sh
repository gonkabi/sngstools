### qc_raw.sh  ###
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
cat $1 | while read line; do echo "$2$line*";done > tmp.txt
list=(`cat tmp.txt | xargs`)
echo ${list[@]} | sed 's/ /\n/g' | grep zip > tmp.txt

multiqc --file-list tmp.txt -o $3 -n $4
rm tmp.txt

## Log %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo "=== Information ==="
date
pwd
qstat
echo "==================="
