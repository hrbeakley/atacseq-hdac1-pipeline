#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    path(peaks)
    path(genome)

    output:
    path("${peaks.baseName}_motifs/")

    shell:
    """
    findMotifsGenome.pl $peaks $genome "${peaks.baseName}_motifs/" -size 200 -p $task.cpus
    """

}


