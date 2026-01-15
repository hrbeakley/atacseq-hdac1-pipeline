#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    label 'process_medium'
    conda 'envs/deeptools_env.yml'
    // publishDir params.outdir, mode: 'copy'

    input:
    val(label)
    path(wt_bw)
    path(ko_bw)
    path(gain_bed)
    path(loss_bed)

    output:
    tuple val(label), path("${label}.matrix.gz")

    script:
    """
    computeMatrix reference-point \
        --referencePoint center \
        -b 1500 -a 1500 \
        -R ${gain_bed} ${loss_bed} \
        -S ${wt_bw.join(' ')} ${ko_bw.join(' ')} \
        --skipZeros \
        --missingDataAsZero \
        -o ${label}.matrix.gz
    """

}