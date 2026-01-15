include {DOWNLOAD_FASTQS} from './modules/download_fastqs'
include {TRIM} from './modules/trimmomatic'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {MULTIQC} from './modules/multiqc'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'
include {REMOVE_MITO} from './modules/remove_mt'
include { FASTQC as FASTQC_RAW } from './modules/fastqc'
include { FASTQC as FASTQC_TRIMMED } from './modules/fastqc'
include { CALLPEAKS } from './modules/macs3_callpeaks'
include { BAMCOVERAGE } from './modules/deeptools_bamcoverage'
include { ANNOTATE } from './modules/homer_annotatepeaks'
include { FIND_MOTIFS_GENOME } from './modules/homer_findmotifsgenome'
include { COMPUTEMATRIX } from './modules/compute_matrix'
include { COMPUTEMATRIX as COMPUTEMATRIX2} from './modules/compute_matrix'
include { PLOTHEATMAP } from './modules/plotheatmap'
include { PLOTHEATMAP as PLOTHEATMAP2 } from './modules/plotheatmap'


workflow {

    Channel.fromPath(params.samplesheet)
    | splitCsv(header: true)
    | map { row -> tuple(row.sample, row.accession)}
    | set { sras_ch }

    DOWNLOAD_FASTQS(sras_ch)

    FASTQC_RAW(DOWNLOAD_FASTQS.out)

    TRIM(DOWNLOAD_FASTQS.out, params.adapter_fa)

    FASTQC_TRIMMED(TRIM.out.trimmed_reads)

    BOWTIE2_BUILD(params.genome)

    BOWTIE2_ALIGN(TRIM.out.trimmed_reads, BOWTIE2_BUILD.out)

    SAMTOOLS_SORT(BOWTIE2_ALIGN.out.bam)

    SAMTOOLS_IDX(SAMTOOLS_SORT.out.sorted)

    SAMTOOLS_FLAGSTAT(SAMTOOLS_SORT.out.sorted)

    REMOVE_MITO(SAMTOOLS_IDX.out.index)

    fastqc_raw_zips = FASTQC_RAW.out.zip.map { name, zip -> zip }
    fastqc_trim_zips = FASTQC_TRIMMED.out.zip.map { name, zip -> zip }
    trim_logs_only = TRIM.out.log.map { name, log -> log }
    bowtie_logs_only = BOWTIE2_ALIGN.out.log.map { name, log -> log }

    multiqc_ch = fastqc_raw_zips
            .mix ( fastqc_trim_zips )
            .mix( trim_logs_only )
            .mix( bowtie_logs_only )
            .mix( SAMTOOLS_FLAGSTAT.out )
            .collect()
    MULTIQC(multiqc_ch)
    
    CALLPEAKS(REMOVE_MITO.out)

    BAMCOVERAGE(REMOVE_MITO.out)

    /*
    dar_ch = Channel.fromPath(params.dar_beds)
    dar_ch.view()

    ANNOTATE(dar_ch, params.genome, params.gtf)
    FIND_MOTIFS_GENOME(dar_ch, params.genome)

    BAMCOVERAGE.out
        .branch { it ->
            cDC1: it[0].contains('cDC1')
            cDC2: it[0].contains('cDC2')
        }
        .set { cell_ch }

    cell_ch.cDC1
        .branch { it ->
            WT: it[0].contains('WT')
            KO: it[0].contains('KO')
        }
        .set { cDC1_cond }

    cDC1_WT_bw = cDC1_cond.WT.map { it[1] }.collect()
    cDC1_KO_bw = cDC1_cond.KO.map { it[1] }.collect()

    cell_ch.cDC2
        .branch { it ->
            WT: it[0].contains('WT')
            KO: it[0].contains('KO')
        }
        .set { cDC2_cond }
    
    cDC2_WT_bw = cDC2_cond.WT.map { it[1] }.collect()
    cDC2_KO_bw = cDC2_cond.KO.map { it[1] }.collect()

    COMPUTEMATRIX(
        "cDC1",
        cDC1_WT_bw,
        cDC1_KO_bw,
        params.cDC1_gain,
        params.cDC1_loss
    )
    PLOTHEATMAP(COMPUTEMATRIX.out)

    COMPUTEMATRIX2(
        "cDC2",
        cDC2_WT_bw,
        cDC2_KO_bw,
        params.cDC2_gain,
        params.cDC2_loss
    )
    PLOTHEATMAP2(COMPUTEMATRIX2.out)
    */

}