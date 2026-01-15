#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/bowtie2:latest'

    input:
    tuple val(name), path(read)
    tuple val(consensus), path(index)

    output:
    tuple val(name), path("${name}.bam"), emit: bam
    tuple val(name), path("${name}_bowtie2.log"), emit: log

    shell:
    """ 
    bowtie2 \
        -p ${task.cpus} \
        --very-sensitive \
        -x bowtie2_index/${consensus} \
        -U ${read} \
        2> ${name}_bowtie2.log \
        | samtools view -@ 4 -bS -q 30 - \
        > ${name}.bam
    """
    stub:
    """
    touch ${name}.bam
    """
}