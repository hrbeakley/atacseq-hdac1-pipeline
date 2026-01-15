#!/usr/bin/env nextflow

process SAMTOOLS_IDX {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(samplename), path(bam)

    output:
    tuple val(samplename), path(bam), path("*.bai"), emit: index

    script:
    """
    samtools index $bam
    """

    stub:
    """
    touch ${samplename}.sorted.bam.bai
    """
}