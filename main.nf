#!/usr/bin/env nextflow
/*
 parameters: the input FASTQ files and a STAR index
*/
params.fastq_dir = "/home/ec2-user/fastq"
params.index = "/home/ec2-user/genome_index"
// the workflow definition
workflow {
 libraries = channel
    .fromPath(params.samplesheet, checkIfExists: true)
    .splitCsv(header: true, sep: '\t')
    .map { row->  tuple(row.library_id, [process     : row.process,
                                        library_id  : row.library_id,
                                        library_name: row.library_name,
                                        read1       : file("${params.fastq_dir}/${row.read1}"),
                                        read2       : file("${params.fastq_dir}/${row.read2}")])}
    .filter {library_id, library -> library.process == '1' }
    .view {library_id, library -> "Running STAR for library ${library.library_name}" }
    // we will define the ALIGN_READS process later, so comment this function call for now
    // bam_files = ALIGN_READS(libraries)
}
