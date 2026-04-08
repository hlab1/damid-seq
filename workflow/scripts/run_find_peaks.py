"""
find_peaks perl script will call peak on DamID bedgraph files.
Problems:
1. find_peaks will create a folder with date/time in name
2. find_peaks will create this folder in the current working directory
   (out dir cannot be specified)

Solution:
1. Run find_peaks from output dir
2. Use glob to find files
3. Move files to parent dir

--> Use absolute paths for input and output files 
"""
import glob
import os
from snakemake.shell import shell

# Get current working dir
cwd = os.getcwd()

# Get arguments from snakemake
find_peaks = f"{cwd}/{snakemake.input['fp']}/find_peaks"
fdr = snakemake.params["fdr"]
frac = snakemake.params["frac"]
min_count = snakemake.params["mc"]
min_quant = snakemake.params["mq"]
n = snakemake.params["n"]
step = snakemake.params["step"]
up = snakemake.params["up"]
outdir = snakemake.params["outdir"]
log = os.path.relpath(snakemake.log[0],outdir)
bedgraph = os.path.relpath(snakemake.input["bg"],outdir)
gff = os.path.relpath(snakemake.output["gff"],outdir)
data = os.path.relpath(snakemake.output["data"],outdir)

# Make and move to output dir
os.makedirs(outdir, exist_ok=True)
os.chdir(outdir)

sample = os.path.basename(bedgraph).replace("-vs-Dam-norm.gatc.bedgraph","")

# Run find_peaks
shell(
    "perl {find_peaks} "
    "--fdr={fdr} "
    "--frac={frac} "
    "--min_count={min_count} "
    "--min_quant={min_quant} "
    "--n={n} "
    "--step={step} "
    "--unified_peaks={up} "
    "{bedgraph} "
    "> {log} 2>&1 "
    )

# Locate GFF and data files and move to output dir (parent dir)
print(os.getcwd())
print(outdir)
print(f"peak_analysis.{sample}*/{sample}*.peaks.gff")
print(gff)
gff_temp = glob.glob(f"peak_analysis.{sample}*/{sample}*.peaks.gff") # peak file
print(gff_temp)
assert len(gff_temp) == 1, "No or more than one gff file found"
data_temp = glob.glob(f"peak_analysis.{sample}*/{sample}*-data") # data file
assert len(data_temp) == 1, "No or more than one data file found"

# Rename and move files
shell(
    f"mv {gff_temp[0]} {gff} && "
    f"mv {data_temp[0]} {data}"
    )

# Remove empty dir
empty_dir = os.path.dirname(gff_temp[0])
os.rmdir(empty_dir)

# Go back to original working dir
os.chdir(cwd) # Is this needed?

