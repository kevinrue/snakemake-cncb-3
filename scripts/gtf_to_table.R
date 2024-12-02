message(Sys.time())

suppressPackageStartupMessages({library(HDF5Array)})
suppressPackageStartupMessages({library(rtracklayer)})
suppressPackageStartupMessages({library(tidyverse)})

message("Importing from GTF file ...")
gtf_data <- import("../../resources/genome/genome.gtf.gz")
message("Done.")

all_genes <- gtf_data %>% 
  as.data.frame() %>% 
  as_tibble() %>% 
  filter(type == "gene") %>% 
  select(seqnames, start, end, strand, gene_id, gene_name, gene_biotype)

message("Identifying duplicate genes coordinates ...")
duplicated_coordinates <- all_genes[all_genes %>% 
  select(seqnames, start, end, strand) %>% 
  duplicated(), ]
message("Done.")

message("Identifying duplicate genes ...")
dup_gene_info <- all_genes %>% 
  filter(
    seqnames %in% dup2$seqnames & start %in% dup2$start & end %in% dup2$end & strand %in% dup2$strand
  ) %>% 
  arrange(seqnames, start, end, strand)
message("Done.")

message("Writing duplicates to TSV file ...")
write_tsv(dup_gene_info, snakemake@output[["tsv"]])
message("Done.")

message(Sys.time())
