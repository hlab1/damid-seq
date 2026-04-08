#!/bin/bash

#SBATCH --job-name=weh_matched_single
#SBATCH --time=05:00:00
#SBATCH --signal=USR2
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --mem=16000
#SBATCH --account=torch_pr_132_general
#SBATCH --output=slurm_logs/slurm-%A.out

module purge
module load snakemake/8.13 anaconda3/2025.06

snakemake -p -j3 -k \
    --sdm conda apptainer --apptainer-args '-B $TMPDIR:/mnt' \
    --configfile config/config_weh_matched_single.yaml
