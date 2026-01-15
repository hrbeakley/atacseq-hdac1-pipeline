#!/usr/bin/env nextflow

process BOWTIE2_BUILD {
    label 'process_high'
    container 'ghcr.io/bf528/bowtie2:latest'

    input:
    path(consensus)

    output:
    tuple val("${consensus.baseName}"), path("bowtie2_index/")

    shell:
    """ 
    mkdir bowtie2_index
    bowtie2-build --threads $task.cpus $consensus bowtie2_index/${consensus.baseName}
    """
    stub:
    """
    mkdir bowtie2_index
    """
}