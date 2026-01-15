#!/usr/bin/env nextflow

process ANNOTATE {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    path(peaks)
    path(ref)
    path(gtf)

    output:
    path("${peaks.baseName}_annotated.txt")

    shell:
    """
    annotatePeaks.pl $peaks $ref -gtf $gtf -cpu $task.cpus > "${peaks.baseName}_annotated.txt"
    """

}



