output "nf-core-rna-seq-job-descriptions" {
  description = "NF-core RNA-Seq"
  value       = "${zipmap(distinct(keys(local.nf_core_rna_seq_jobs)), values(aws_batch_job_definition.igf-jd-nfcore-rnaseq).*.name)}"
}