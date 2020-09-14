### Snakefile: sngstools ###
## Setting ############################################
TARGET_SRR = "data/raw/target_srr.txt"
NUM_ARRAY = "1-3"
NUM_SLOT = 4

## Rule ###############################################
rule download_sra: # use prefetch
    input:
        target = TARGET_SRR
    params:
        array = NUM_ARRAY,
        jobname = "download_sra"
    shell:
        "qsub -t {params.array} -N {params.jobname} ./src/download_sra.sh {input.target}"

rule dump_sra2fastq: # use fasterq-dump, pigz
    input:
        target = TARGET_SRR
    params:
        array = NUM_ARRAY,
        slot = NUM_SLOT,
        jobname = "dump_sra2fastq",
        home_path = "/home/bminfob/"
    shell:
        "qsub -t {params.array} -pe def_slot {params.slot} -N {params.jobname} ./src/dump_sra2fastq.sh {input.target} {params.slot} {params.home_path}"

rule qc_raw: # use fastqc
    input:
        target = TARGET_SRR
    params:
        array = NUM_ARRAY,
        slot = NUM_SLOT,
        jobname = "qc_raw",
        indir_path = "/home/bminfob/ncbi/public/fastq/",
        outdir_path = "/home/bminfob/ncbi/public/result_fastqc/"
    shell:
        "qsub -t {params.array} -pe def_slot {params.slot} -N {params.jobname} ./src/qc_raw.sh {input.target} {params.slot} {params.indir_path} {params.outdir_path}"

rule qc_summary: # use multiqc
    input:
        target = TARGET_SRR
    params:
        jobname = "qc_summary",
        #indir_path = "/home/bminfob/ncbi/public/result_fastqc/",
        #outdir_path = "/home/bminfob/ncbi/public/result_fastqc/",
        #outfile_name = "multiqc_report"
        indir_path = "output/trim_fastq/fastqc/",
        outdir_path = "output/trim_fastq/fastqc/",
        outfile_name = "trim_multiqc_report"
    shell:
        "qsub -N {params.jobname} ./src/qc_summary.sh {input.target} {params.indir_path} {params.outdir_path} {params.outfile_name}"

rule trim_fastq: # use trimmomatic (with -phred33)
    input:
        target = TARGET_SRR
    params:
        array = NUM_ARRAY,
        slot = NUM_SLOT,
        jobname = "trim_fastq",
        indir_path = "/home/bminfob/ncbi/public/fastq/",
        outdir_path = "output/trim_fastq/",
        seq_type = "PE", # set {PE or SE}
        trim_param = "LEADING:30 TRAILING:30 SLIDINWINDOW:4:20 MINLEN:30"
    shell:
        "qsub -t {params.array} -pe def_slot {params.slot} -N {params.jobname} ./src/trim_fastq.sh {input.target} {params.indir_path} {params.outdir_path} {params.seq_type} {params.slot} {params.trim_param}"

rule qc_trim: # use fastqc
    input:
        target = TARGET_SRR
    params:
        array = NUM_ARRAY,
        slot = NUM_SLOT,
        jobname = "qc_trim",
        indir_path = "output/trim_fastq/fastqc/",
        outdir_path = "output/trim_fastq/fastqc/",
        select_file = "trim-paired" # set {SE:trim, PE:trim-paired or trim-unpaired}
    shell:
        "qsub -t {params.array} -pe def_slot {params.slot} -N {params.jobname} ./src/qc_trim.sh {input.target} {params.slot} {params.indir_path} {params.outdir_path} {params.select_file}"
