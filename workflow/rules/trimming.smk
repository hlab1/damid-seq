if paired_end:
    rule trim_galore_pe:
        input:
            r1="{analysis_dir}/reads/{dir}/{sample}_R1_001.fastq.gz", 
            r2="{analysis_dir}/reads/{dir}/{sample}_R2_001.fastq.gz",
        output:
            r1="{analysis_dir}/results/trimmed/{dir}/{sample}_1.fastq.gz",
            r2="{analysis_dir}/results/trimmed/{dir}/{sample}_2.fastq.gz",
            flag=touch("{analysis_dir}/results/trimmed/{dir}/{sample}.flag"),
        threads: config["resources"]["trim"]["cpu"],
        resources:
            runtime=config["resources"]["trim"]["time"],
        params:
            paired=True,
            extra="--illumina -q 20",
        log:
            "{analysis_dir}/logs/trim_galore/{dir}/{sample}.log",
        conda:
            "../envs/trim.yaml"
        script:
            "../scripts/trim_galore.py"
else:
    rule trim_galore_se:
        input:
            r1="{analysis_dir}/reads/{dir}/{sample}.fastq.gz",
        output:
            r1="{analysis_dir}/results/trimmed/{dir}/{sample}.fastq.gz",
            flag=touch("{analysis_dir}/results/trimmed/{dir}/{sample}.flag"),
        threads: config["resources"]["trim"]["cpu"],
        resources:
            runtime=config["resources"]["trim"]["time"],
        params:
            paired=False,
            extra="--illumina -q 20",
        log:
            "{analysis_dir}/logs/trim_galore/{dir}/{sample}.log",
        conda:
            "../envs/trim.yaml"
        script:
            "../scripts/trim_galore.py"

        
