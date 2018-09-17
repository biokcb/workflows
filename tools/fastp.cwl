#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
doc: | 
  CWL wrapper for fastp - a tool designed to provide fast all-in-one 
  preprocessing for FastQ files. This tool is developed in C++ with 
  multithreading supported to afford high performance.

requirements:
 - class: InlineJavascriptRequirement

baseCommand: fastp

inputs:

  # File I/O options
  in1: 
    type: File
    inputBinding:
      position: 1
      prefix: --in1
    doc: |
      read1 input file name (string)

  out1:
    type: string
    inputBinding:
      position: 2
      prefix: --out1
    doc: |
      read1 output file name (string [=])

  in2:
    type: File?
    inputBinding:
      prefix: --in2
    doc: |
      read2 input file name (string [=])

  out2:
    type: string?
    inputBinding:
      prefix: --out2
    doc: |
      read2 output file name (string [=]) 

  phred64:
    type: boolean?
    inputBinding:
      prefix: --phred64
    doc: |
       indicate the input is using phred64 scoring
       (it'll be converted to phred33, so the output
       will still be phred33)
 
  compression:
    type: int?
    inputBinding:
      prefix: --compression
    doc: |
      compression level for gzip output (1 ~ 9). 
      1 is fastest, 9 is smallest, default is 4.
      (int [=4])

  stdout: 
    type: boolean?
    inputBinding:
      prefix: --stdout
    doc: |
      stream passing-filters reads to STDOUT. This
      option will result in interleaved FASTQ output
      for paired-end input. Disabled by defaut.
 
  interleaved_in:
    type: boolean?
    inputBinding:
      prefix: --interleaved_in
    doc: |
      indicate that <in1> is an interleaved FASTQ 
      which contains both read1 and read2. Disabled 
      by defaut.

  reads_to_process:
    type: int?
    inputBinding:
      prefix: --reads_to_process
    doc: |
      specify how many reads/pairs to be processed.
      Default 0 means process all reads. (int [=0])

  dont_overwrite:
    type: boolean?
    inputBinding:
      prefix: --dont_overwrite
    doc: |
      don't overwrite existing files. Overwritting is
      allowed by default.
  
  # Adapter trimming options
  disable_adapter_trimming:
    type: boolean?
    inputBinding:
      prefix: --disable_adapter_trimming 
    doc: |
      adapter trimming is enabled by default. If this
      option is specified, adapter trimming is disabled

  adapter_sequence:
    type: string?
    inputBinding:
      prefix: --adapter_sequence
    doc: |
      the adapter for read1. For SE data, if not specified,
      the adapter will be auto-detected. For PE data, this
      is used if R1/R2 are found not overlapped. 
      (string [=auto])
  
  adapter_sequence_r2:
    type: string?
    inputBinding:
      prefix: --adapter_sequence_r2
    doc: |
      the adapter for read2 (PE data only). This is used if
      R1/R2 are found not overlapped. If not specified, it
      will be the same as <adapter_sequence> (string [=])

  # Trimming options regardless of quality
  trim_front1:
    type: int?
    inputBinding:
      prefix: --trim_front1
    doc: |
      trimming how many bases in front for read1, default 
      is 0 (int [=0])

  trim_tail1:
    type: int?
    inputBinding:
      prefix: --trim_tail1
    doc: |
      trimming how many bases in tail for read1, default
      is 0 (int [=0])

  trim_front2:
    type: int?
    inputBinding:
      prefix: --trim_front2
    doc: |
      trimming how many bases in front for read2. If it's
      not specified, it will follow read1's settings
      (int [=0])

  trim_tail2:
    type: int?
    inputBinding:
      prefix: --trim_tail2
    doc: |
      trimming how many bases in tail for read2. If it's
      not specified, it will follow read1's settings 
      (int [=0])
  
  trim_poly_g:
    type: boolean?
    inputBinding:
      prefix: --trim_poly_g
    doc: |
      force polyG tail trimming, by default trimming is 
      automatically enabled for Illumina NextSeq/NovaSeq
      data

  poly_g_min_len:
    type: int?
    inputBinding:
      prefix: --poly_g_min_len
    doc: |
      the minimum length to detect polyG in the read tail.
      10 by default. (int [=10])

  disable_trim_poly_g:
    type: boolean?
    inputBinding:
      prefix: --disable_trim_poly_g 
    doc: |
      disable polyG tail trimming, by default trimming is
      automatically enabled for Illumina NextSeq/NovaSeq
      data

  trim_poly_x:
    type: boolean?
    inputBinding:
      prefix: --trim_poly_x
    doc: |
      enable polyX trimming in 3' ends.

  poly_x_min_len:
    type: int?
    inputBinding:
      prefix: --poly_x_min_len
    doc: |
      the minimum length to detect polyX in the read tail.
      10 by default. (int [=10]) 

  # Quality score trimming and filtering options
  cut_by_quality5:
    type: boolean?
    inputBinding: 
      prefix: --cut_by_quality5
    doc: |
      enable per read cutting by quality in front (5'), 
      default is disabled (WARNING: this will interfere
      deduplication for both PE/SE data)

  cut_by_quality3:
    type: boolean?
    inputBinding:
      prefix: --cut_by_quality3
    doc: |
      enable per read cutting by quality in tail (3'),
      default is disabled (WARNING: this will interfere
      deduplication for SE data)

  cut_window_size:
    type: int?
    inputBinding:
      prefix: --cut_window_size
    doc: |
      the size of the sliding window for sliding window
      trimming, default is 4 (int [=4])

  cut_mean_quality:
    type: int?
    inputBinding:
      prefix: --cut_mean_quality
    doc: |
      the bases in the sliding window with mean quality
      below cutting_quality will be cut, default is Q20
      (int [=20])

  disable_quality_filtering:
    type: boolean?
    inputBinding:
      prefix: --disable_quality_filtering
    doc: |
      quality filtering is enabled by default. If this
      option is specified, quality filtering is disabled

  qualified_quality_phred:
    type: int?
    inputBinding:
      prefix: --qualified_quality_phred
    doc: |
      the quality value that a base is qualified. Default
      15 means phred quality >=Q15 is qualified. (int [=15])

  unqualified_percent_limit:
    type: int?
    inputBinding:
      prefix: --unqualified_percent_limit
    doc: |
      how many percents of bases are allowed to be unqualified
      (0~100). Default 40 means 40% (int [=40])

  n_base_limit:
    type: int?
    inputBinding:
      prefix: --n_base_limit
    doc: |
      if one read's number of N base is >n_base_limit, then
      this read/pair is discarded. Default is 5 (int [=5])

  # Sequence length filtering
  disable_length_filtering:
    type: boolean?
    inputBinding:
      prefix: --disable_length_filtering
    doc: |
      length filtering is enabled by default. If this option
      is specified, length filtering is disabled
  
  length_required:
    type: int?
    inputBinding:
      prefix: --length_required
    doc: |
      reads shorter than length_required will be discarded,
      default is 15. (int [=15]) 

  length_limit:
    type: int?
    inputBinding:
      prefix: --length_limit
    doc: |
      reads longer than length_limit will be discarded,
      default 0 means no limitation. (int [=0])
  
  # Other filtering options
  low_complexity_filter:
    type: int?
    inputBinding:
      prefix: --low_complexity_filter
    doc: |
      enable low complexity filter. The complexity is 
      defined as the percentage of base that is different
      from its next base (base[i] != base[i+1]).
  
  complexity_threshold:
    type: int?
    inputBinding:
      prefix: --complexity_threshold
    doc: |
      the threshold for low complexity filter (0~100). Default
      is 30, which means 30% complexity is required. (int [=30])

  filter_by_index1:
    type: string?
    inputBinding:
      prefix: --filter_by_index1               
    doc: |
      specify a file contains a list of barcodes of index1 to 
      be filtered out, one barcode per line (string [=])

  filter_by_index2:
    type: string?
    inputBinding:
      prefix: --filter_by_index2
    doc: |
      specify a file contains a list of barcodes of index2 to
      be filtered out, one barcode per line (string [=])
     
  filter_by_index_threshold:
    type: int?
    inputBinding:
      prefix: --filter_by_index_threshold
    doc: |
      the allowed difference of index barcode for index 
      filtering, default 0 means completely identical.
      (int [=0])

  correction:
    type: boolean?
    inputBinding:
      prefix: --correction
    doc: |
      enable base correction in overlapped regions (only for PE 
      data), default is disabled
     
  overlap_len_require:
    type: int?
    inputBinding:
      prefix: --overlap_len_require
    doc: |
      the minimum length of the overlapped region for overlap 
      analysis based adapter trimming and correction. 30 by
      default. (int [=30])

  overlap_diff_limit:
    type: int?
    inputBinding:
      prefix: --overlap_diff_limit
    doc: |
      the maximum difference of the overlapped region for overlap
      analysis based adapter trimming and correction. 5 by default.
      (int [=5])
  
  # UMI options
  umi:
    type: boolean?
    inputBinding:
      prefix: --umi
    doc: |
      enable unique molecular identifer (UMI) preprocessing

  umi_loc:
    type: string?
    inputBinding:
      prefix: --umi_loc
    doc: |
      specify the location of UMI, can be 
      (index1/index2/read1/read2/per_index/per_read), default is
      none (string [=])

  umi_len:
    type: int?
    inputBinding:
      prefix: --umi_len
    doc: |
      if the UMI is in read1/read2, its length should be provided 
      (int [=0])

  umi_prefix:
    type: string?
    inputBinding:
      prefix: --umi_prefix
    doc: |
      if specified, an underline will be used to connect prefix and
      UMI (i.e. prefix=UMI, UMI=AATTCG, final=UMI_AATTCG). No prefix 
      by default (string [=])

  umi_skip:
    type: int? 
    inputBinding:
      prefix: --umi_skip
    doc: |
      if the UMI is in read1/read2, fastp can skip several bases 
      following UMI, default is 0 (int [=0])

  # Over-representation options
  overrepresentation_analysis:
    type: boolean?
    inputBinding:
      prefix: --overrepresentation_analysis
    doc: |
      enable overrepresented sequence analysis.

  overrepresentation_sampling:
    type: int?
    inputBinding:
      prefix: --overrepresentation_sampling
    doc: |
      one in (--overrepresentation_sampling) reads will be computed
      for overrepresentation analysis (1~10000), smaller is slower, 
      default is 20. (int [=20]) 
  
  # Output report options
  json:
    type: string?
    inputBinding:
      prefix: --json
    doc: |
      the json format report file name (string [=fastp.json])

  html:
    type: string?
    inputBinding:
      prefix: --html
    doc: |
      the html format report file name (string [=fastp.html]) 

  report_title: 
    type: string?
    inputBinding:
      prefix: --report_title
    doc: |
      should be quoted with ' or ", default is "fastp report" 
      (string [=fastp report])
  
  # Parallel processing options
  thread:
    type: int?
    inputBinding:
      prefix: --thread
    doc: |
      worker thread number, default is 2 (int [=2])
  
  split:
    type: int?
    inputBinding:
      prefix: --split 
    doc: |
      split output by limiting total split file number with this 
      option (2~999), a sequential number prefix will be added to
      output name ( 0001.out.fq, 0002.out.fq...), disabled by default
      (int [=0])

  split_by_lines:
    type: long?
    inputBinding:
      prefix: --split_by_lines
    doc: |
      split output by limiting lines of each file with this option
      (>=1000), a sequential number prefix will be added to output
      name ( 0001.out.fq, 0002.out.fq...), disabled by default 
      (long [=0])
  
  split_prefix_digits:
    type: int?
    inputBinding:
      prefix: --split_prefix_digits 
    doc: |
      the digits for the sequential number padding (1~10), default 
      is 4, so the filename will be padded as 0001.xxx, 0 to disable 
      padding (int [=4])


outputs:
  # need to implement the split fastq output better - perhaps a separate
  #tool all together
  fastq1:
    type: File
    outputBinding:
      glob: $(inputs.out1)
  
  fastq2:
    type: File?
    outputBinding:
      glob: $(inputs.out2)

  split_fastq:
    type: File[]
    outputBinding:
      glob: "*"
  
  report_json:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.json) {
            return inputs.json;
          } else {
            return "fastp.json";
          }
        }
  
  report_html:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.html) {
            return inputs.html;
          } else {
            return "fastp.html";
          }
        }
