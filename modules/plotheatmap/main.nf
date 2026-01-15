#!/usr/bin/env nextflow

process PLOTHEATMAP {
    label 'process_medium'
    conda 'envs/deeptools_env.yml'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(label), path(matrix)

    output:
    path("${label}_heatmap.png")

    script:
    """
    plotHeatmap \
      -m $matrix \
      --colorMap RdPu \
      --whatToShow 'plot, heatmap and colorbar' \
      --heatmapHeight 10 \
      --heatmapWidth 6 \
      --regionsLabel Gain Loss \
      --samplesLabel WT1 WT2 KO1 KO2 \
      --sortRegions descend \
      --sortUsing mean \
      --sortUsingSamples 1 \
      -o ${label}_heatmap.png
    """

}