#!/usr/bin/env nextflow

process TRIM {
    label 'process_medium'
    container 'ghcr.io/bf528/trimmomatic:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(name), path(read)
    path(adapters)

    output:
    tuple val(name), path("${name}_trimmed.fastq.gz"), emit: trimmed_reads
    tuple val(name), path("*.log"), emit: log

    script:
    """
    mkdir -p tmp
    export _JAVA_OPTIONS="-Djava.io.tmpdir=\${PWD}/tmp -Xmx2g"

    trimmomatic SE -threads ${task.cpus} \
        ${read} \
        ${name}_trimmed.fastq.gz \
        ILLUMINACLIP:${adapters}:2:30:10 \
        LEADING:3 \
        TRAILING:3 \
        SLIDINGWINDOW:4:15 \
        MINLEN:20 \
        2> ${name}_trimmomatic.log
    """

    stub:
    """
    touch ${name}_stub_trim.log
    touch ${name}_stub_trimmed.fastq.gz
    """
}