if paired_end:
    rule fastqc:
        input:
            "{analysis_dir}/results/trimmed/{dir}/{sample}{end}.fastq.gz",
        output:
            html="{analysis_dir}/results/qc/fastqc/{dir}/{sample}{end}.html",
            zip="{analysis_dir}/results/qc/fastqc/{dir}/{sample}{end}_fastqc.zip"
        params:
            extra = "--quiet"
        log:
            "{analysis_dir}/logs/fastqc/{dir}/{sample}{end}.log"
        threads: config["resources"]["fastqc"]["cpu"]
        resources:
            runtime=config["resources"]["fastqc"]["time"],
            mem_mb = 2048,
        wrapper:
            f"{wrapper_version}/bio/fastqc"


    rule multiqc:
        input:
            expand("{analysis_dir}/results/qc/fastqc/{dir}/{sample}{end}_fastqc.zip", analysis_dir=config['analysis_dir'], dir=DIRS, sample=SAMPLES, end=["_1","_2"])
        output:
            r="{analysis_dir}/results/qc/multiqc/multiqc.html",
            d=directory("{analysis_dir}/results/qc/multiqc/"),
        params:
            extra="",  # Optional: extra parameters for multiqc
        threads: config["resources"]["fastqc"]["cpu"]
        resources:
            runtime=config["resources"]["fastqc"]["time"],
            mem_mb = 2048,
        log:
            "{analysis_dir}/logs/multiqc/multiqc.log"
        conda:
            "../envs/trim.yaml"
        shell:
            "multiqc " 
            "--force "
            "--outdir {output.d} "
            "--dirs " # Prepend directory to sample names
            "-n multiqc.html "
            "{params.extra} "
            "{input} "
            "> {log} 2>&1"
else:
    rule fastqc:
        input:
            "{analysis_dir}/results/trimmed/{dir}/{sample}.fastq.gz"
        output:
            html="{analysis_dir}/results/qc/fastqc/{dir}/{sample}.html",
            zip="{analysis_dir}/results/qc/fastqc/{dir}/{sample}_fastqc.zip"
        params:
            extra = "--quiet"
        log:
            "{analysis_dir}/logs/fastqc/{dir}/{sample}.log"
        threads: config["resources"]["fastqc"]["cpu"]
        resources:
            runtime=config["resources"]["fastqc"]["time"],
            mem_mb = 2048,
        wrapper:
            f"{wrapper_version}/bio/fastqc"


    rule multiqc:
        input:
            expand("{analysis_dir}/results/qc/fastqc/{dir}/{sample}_fastqc.zip", analysis_dir=config['analysis_dir'],dir=DIRS, sample=SAMPLES)
        output:
            r="{analysis_dir}/results/qc/multiqc/multiqc.html",
            d=directory("{analysis_dir}/results/qc/multiqc/"),
        params:
            extra="", # Optional: extra parameters for multiqc
        threads: config["resources"]["fastqc"]["cpu"]
        resources:
            runtime=config["resources"]["fastqc"]["time"],
            mem_mb = 2048,
        log:
            "{analysis_dir}/logs/multiqc/multiqc.log"
        conda:
            "../envs/trim.yaml"
        shell:
            "multiqc " 
            "--force "
            "--dirs " # Prepend directory to sample names
            "--outdir {output.d} "
            "-n multiqc.html "
            "{params.extra} "
            "{input} "
            "> {log} 2>&1"
