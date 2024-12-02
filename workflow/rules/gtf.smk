rule filter_duplicate_genes_from_gtf:
    input:
        "resources/genome/genome.gtf.gz",
    output:
        tsv="resources/genome/duplicate_genes.tsv"
    log:
        "logs/genome/prepare_reference_fasta.log",
    conda:
        "../../conda/unix.yaml"
    resources:
        mem="8G",
        runtime="5m",
    threads: 1
    script:
        "({download_concatenate_genome_fasta_cmd_str}) 2> {log}"