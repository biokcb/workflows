cwlVersion: v1.0
class: Workflow
hints:
  DockerRequirement:
    dockerLoad: https://workbench.qr1hi.arvadosapi.com/collections/download/qr1hi-4zz18-x2ae13tsx5jqg8d/1nduktd8dpvhdpgsva82lje0i710kgzb6rttks5jldx7s2y7k9/7e0c0ae3bf4e70442f9b8eee816ec23426d9e1169a2925316e5c932745e21613.tar
    dockerImageId: 7e0c0ae3bf4e70442f9b8eee816ec23426d9e1169a2925316e5c932745e21613
inputs:
  p1:
    doc: list of files containing the first end of paired end reads in fasta or fastq
      format
    type: File[]?
  p2:
    doc: list of files containing the second end of paired end reads in fasta or fastq
      format
    type: File[]?
  output_prefix:
    doc: prefix for output files. will output prefix.aligned.bam and prefix.aligned.stats
    type: string
  reference:
    doc: lobSTR's bwa reference files
    type: File
  rg-sample:
    doc: Use this in the read group SM tag
    type: string
  rg-lib:
    doc: Use this in the read group LB tag
    type: string
  strinfo:
    doc: File containing statistics for each STR.
    type: File
  noise_model:
    doc: File to read noise model parameters from (.stepmodel)
    type: File
    secondaryFiles:
    - ^.stuttermodel
steps:
  lobSTR:
    run: lobSTR-tool.cwl
    out:
    - bam
    - bam_stats
    in:
      p1: p1
      p2: p2
      output_prefix: output_prefix
      reference: reference
      rg-sample: rg-sample
      rg-lib: rg-lib
  samsort:
    run: samtools-sort.cwl
    out:
    - output_file
    in:
      input: lobSTR/bam
      output_name:
        default: aligned.sorted.bam
  samindex:
    run: samtools-index.cwl
    out:
    - bam_with_bai
    in:
      input: samsort/output_file
  allelotype:
    run: allelotype.cwl
    out:
    - vcf
    - vcf_stats
    in:
      bam: samindex/bam_with_bai
      reference: reference
      output_prefix: output_prefix
      noise_model: noise_model
      strinfo: strinfo
outputs:
  bam:
    type: File
    outputSource: samindex/bam_with_bai
  bam_stats:
    type: File
    outputSource: lobSTR/bam_stats
  vcf:
    type: File
    outputSource: allelotype/vcf
  vcf_stats:
    type: File
    outputSource: allelotype/vcf_stats

