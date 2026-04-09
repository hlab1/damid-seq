#!/bin/bash

#SBATCH --job-name=weh_non-matched_single
#SBATCH --time=08:00:00
#SBATCH --signal=USR2
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16000
#SBATCH --account=torch_pr_132_general
#SBATCH --output=slurm_logs/slurm-%A.out

module purge
module load snakemake/8.13 anaconda3/2025.06

snakemake -p -j8 -k \
    --sdm conda apptainer --apptainer-args '-B $TMPDIR:/mnt' \
    --configfile config/config_weh_non-matched_single.yaml
