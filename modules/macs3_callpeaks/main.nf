process CALLPEAKS {
    label 'process_high'
    conda 'envs/macs3_env.yml'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(name), path(bam), path(bai)

    output:
    tuple val(name), path("${name}_peaks.narrowPeak"), emit: peaks
    path("${name}_macs3.log"), emit: log


    shell:
    """
    macs3 callpeak \
        -t ${bam} \
        -f BAM \
        -g mm \
        -n ${name} \
        --nomodel \
        --keep-dup auto \
        --extsize 147 \
        -q 0.01 \
        2> ${name}_macs3.log
    """
}
