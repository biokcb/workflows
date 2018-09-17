#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
doc: |
    CWL wrapper for bowtie2. 
    Bowtie 2 version 2.2.6 by Ben Langmead (langmea@cs.jhu.edu, www.cs.jhu.edu/~langmea)
    Usage\: 
        bowtie2 [options]* -x <bt2-idx> {-1 <m1> -2 <m2> | -U <r>} [-S <sam>]

    <bt2-idx>  Index filename prefix (minus trailing .X.bt2).
               NOTE: Bowtie 1 and Bowtie 2 indexes are not compatible.
    <m1>       Files with #1 mates, paired with files in <m2>.
               Could be gzip'ed (extension: .gz) or bzip2'ed (extension: .bz2).
    <m2>       Files with #2 mates, paired with files in <m1>.
               Could be gzip'ed (extension: .gz) or bzip2'ed (extension: .bz2).
    <r>        Files with unpaired reads.
               Could be gzip'ed (extension: .gz) or bzip2'ed (extension: .bz2).
    <sam>      File for SAM output (default: stdout)

    <m1>, <m2>, <r> can be comma-separated lists (no whitespace) and can be
    specified many times.  E.g. '-U file1.fq,file2.fq -U file3.fq'.   

requirements:
 - class: InlineJavascriptRequirement
 - class: InitialWorkDirRequirement
   listing: $(inputs.bt2_index_files)

baseCommand: bowtie2

inputs:

  # Required inputs to run bowtie2
  bt2_idx:
    type: string
    inputBinding:
      prefix: -x
    doc: |
      Index filename prefix (minus trailing .X.bt2). 
      NOTE: Bowtie 1 and Bowtie 2 indexes are not compatible.
      If files do not exist, use bowtie2-build to create them.
      Must be an absolute path (for now)

  bt2_index_files:
    type: File[]
    doc: |
      Index files for bowtie2 alignment. 

  mate1:
    type: 
      - "null"
      - File[]
      - File
    inputBinding:
      prefix: "-1"
    doc: | 
      Array of input files to align. Can be gzipped (.gz) or 
      bzipped (.bz2). If paired end, these are the first mates,
      ordered to match the mates in m2.

  # Optional inputs 
  mate2:
    type:
      - "null"
      - File[]
      - File
    inputBinding:
      prefix: "-2"
    doc: | 
      Array of paired end mate input files to align. Can be 
      gzipped (.gz) or bzipped (.bz2). Must be ordered to match
      mates in m1 input array.

  unpaired:
    type: 
      - "null"
      - File[]
      - File
    inputBinding:
      prefix: -U
    doc: |
      Files with unpaired reads to align. Can be gzipped (.gz)
      or bzipped (.bz2). Must be ordered to match paired end
      files. 

  sam: 
    type: string
    inputBinding:
      prefix: -S
    doc: |
      Sam file name for output. Defaults to stdout.

  # Options 

  q:
    type: boolean?
    inputBinding:
      prefix: -q
    doc: |
      query input files are FASTQ .fq/.fastq (default)

  qseq:
    type: boolean?
    inputBinding:
      prefix: --qseq
    doc: |
      query input files are in Illumina's qseq format

  f:
    type: boolean?
    inputBinding:
      prefix: -f
    doc: |
      query input files are (multi-)FASTA .fa/.mfa

  r:
    type: boolean?
    inputBinding:
      prefix: -r
    doc: |
      query input files are raw one-sequence-per-line

  c: 
    type: boolean?
    inputBinding:
      prefix: -c
    doc: |
      <m1>, <m2>, <r> are sequences themselves, not files

  skip:
    type: int?
    inputBinding:
      prefix: --skip
    doc: |
      skip the first <int> reads/pairs in the input (none)

  upto:
    type: int?
    inputBinding:
      prefix: --upto
    doc: |
      stop after first <int> reads/pairs (no limit)

  trim5:
    type: int?
    inputBinding:
      prefix: --trim5
    doc: |
      trim <int> bases from 5'/left end of reads (0)

  trim3:
    type: int?
    inputBinding:
      prefix: --trim3  
    doc: |
      trim <int> bases from 3'/right end of reads (0)

  phred33:
    type: boolean?
    inputBinding:
      prefix: --phred33
    doc: |
      qualities are Phred+33 (default)

  phred64:
    type: boolean?
    inputBinding:
      prefix: --phred64
    doc: | 
      qualities are Phred+64

  int_quals:
    type: boolean?
    inputBinding:
      prefix: --int-quals
    doc: |
      qualities encoded as space-delimited integers

  # Preset options for end-to-end alignment mode

  very_fast:
    type: boolean?
    inputBinding:
      prefix: --very-fast 
    doc: |
      Same as setting -D 5 -R 1 -N 0 -L 22 -i S,0,2.50
      Use with end-to-end mode.

  fast:
    type: boolean?
    inputBinding:
      prefix: --fast
    doc: |
      Same as setting -D 10 -R 2 -N 0 -L 22 -i S,0,2.50
      Use with end-to-end mode.

  sensitive:
    type: boolean?
    inputBinding:
      prefix: --sensitive
    doc: |
      Same as setting -D 15 -R 2 -N 0 -L 22 -i S,1,1.15 
      This is the default for end-to-end mode.

  very_sensitive:
    type: boolean?
    inputBinding:
      prefix: --very-sensitive
    doc: |
      Same as setting -D 20 -R 3 -N 0 -L 20 -i S,1,0.50
      Use with end-to-end mode.

  # Set alignment mode to end-to-end 
  end_to_end:
    type: boolean?
    inputBinding:
      prefix: --end-to-end
    doc: |
      entire read must align; no clipping (on).
      Defaults to this mode.

  # Preset options for local alignment mode
  very_fast_local:
    type: boolean?
    inputBinding:
      prefix: --very-fast-local 
    doc: |
      Same as setting -D 5 -R 1 -N 0 -L 25 -i S,1,2.00
      Use with local alignment mode.

  fast_local:
    type: boolean?
    inputBinding:
      prefix: --fast-local
    doc: |
      Same as setting -D 10 -R 2 -N 0 -L 22 -i S,1,1.75
      Use with local alignment mode.

  sensitive_local:
    type: boolean?
    inputBinding:
      prefix: --sensitive-local
    doc: |
      Same as setting -D 15 -R 2 -N 0 -L 20 -i S,1,0.75
      This is the default for local alignment mode.

  very_sensitive_local:
    type: boolean?
    inputBinding:
      prefix: --very-sensitive-local
    doc: |
      Same as setting -D 20 -R 3 -N 0 -L 20 -i S,1,0.50
      Use with local alignment mode.

  # Set alignment mode to local
  local: 
    type: boolean?
    inputBinding:
      prefix: --local 
    doc: |
      local alignment; ends might be soft clipped (off)

  # Other alignment options
  n_max:
    type: int?
    inputBinding:
      prefix: -N
    doc: |
      Max number of mismatches in seed alignment; can be 0 or 1. 
      Default 0.
  
  l:
    type: int?
    inputBinding:
      prefix: -L
    doc: |
      Length of seed substrings; must be >3, <32. Default 22.

  i:
    type: string? #may need to make a special type for this
    inputBinding:
      prefix: -i
    doc: |
      interval between seed substrings w/r/t read len. 
      Default S,1,1.15

  n_ceil:
    type: string? #may need to be a special type
    inputBinding:
      prefix: --n-ceil
    doc: |
      func for max # non-A/C/G/Ts permitted in aln (L,0,0.15)

  dpad:
    type: int?
    inputBinding:
      prefix: --dpad
    doc: |
      include <int> extra ref chars on sides of DP table (15)

  gbar:
    type: int?
    inputBinding:
      prefix: --gbar
    doc: |
      disallow gaps within <int> nucs of read extremes (4)
  
  ignore_quals:
    type: boolean?
    inputBinding:
      prefix: --ignore-quals
    doc: |
      treat all quality values as 30 on Phred scale (off)

  nofw:
    type: boolean?
    inputBinding:
      prefix: --nofw
    doc: |
      do not align forward (original) version of read (off)

  norc: 
    type: boolean?
    inputBinding:
      prefix: --norc
    doc: |
      do not align reverse-complement version of read (off)

  no_1mm_upfront:
    type: boolean?
    inputBinding:
      prefix: --no-1mm-upfront
    doc: |
      do not allow 1 mismatch alignments before attempting to
      scan for the optimal seeded alignments

  # Scoring options
  ma:
    type: int?
    inputBinding:
      prefix: --ma
    doc: |
      match bonus (0 for --end-to-end, 2 for --local) 

  mp:
    type: int?
    inputBinding:
      prefix: --mp
    doc: |
      max penalty for mismatch; lower qual = lower penalty (6)

  np:
    type: int?
    inputBinding:
      prefix: --np
    doc: |
      penalty for non-A/C/G/Ts in read/ref (1)

  rdg:
    type: int[]? #change to record at some point
    inputBinding:
      prefix: --rdg
    doc: |
      read gap open, extend penalties (5,3)

  rfg:
    type: int[]? #change to record at some point
    inputBinding:
      prefix: --rfg
    doc: |
      reference gap open, extend penalties (5,3)

  score_min:
    type: string? #change to special type at some point
    inputBinding:
      prefix: --score-min
    doc: |
      min acceptable alignment score w/r/t read length
      (G,20,8 for local, L,-0.6,-0.6 for end-to-end)

  # Reporting options
  # Default is to look for multiple alignments, report best, with MAPQ
  # Change this to exclusive parameters type at some point
  k:
    type: int?
    inputBinding:
      prefix: -k
    doc: |
      report up to <int> alns per read; MAPQ not meaningful

  all:
    type: boolean?
    inputBinding:
      prefix: --all
    doc: |
      report all alignments; very slow, MAPQ not meaningful

  # Effort options
  d_ext:
    type: int?
    inputBinding:
      prefix: -D
    doc: |
      give up extending after <int> failed extends in a row (15)

  r_seed:
    type: int?
    inputBinding:
      prefix: -R
    doc: |
      for reads w/ repetitive seeds, try <int> sets of seeds (2)

  # Paired-end options:
  minins:
    type: boolean?
    inputBinding:
      prefix: --minins 
    doc: |
      minimum fragment length (0)

  maxins:
    type: boolean?
    inputBinding:
      prefix: --maxins 
    doc: |
      maximum fragment length (500)

  fr:
    type: boolean?
    inputBinding:
      prefix: --fr
    doc: |
      -1, -2 mates align fw/rev, default

  rf:
    type: boolean?
    inputBinding:
      prefix: --rf
    doc: |
      -1, -2 mates align rev/fw

  ff:
    type: boolean?
    inputBinding:
      prefix: --ff
    doc: |
      -1, -2 mates align fw/fw

  no_mixed:
    type: boolean?
    inputBinding:
      prefix: --no-mixed         
    doc: |
      suppress unpaired alignments for paired reads

  no_discordant:
    type: boolean?
    inputBinding:  
      prefix: --no-discordant    
    doc: |
      suppress discordant alignments for paired reads

  no_dovetail:
    type: boolean?
    inputBinding:
      prefix: --no-dovetail      
    doc: |
      not concordant when mates extend past each other

  no_contain:  
    type: boolean?
    inputBinding:
      prefix: --no-contain       
    doc: |
      not concordant when one mate alignment contains other

  no_overlap:
    type: boolean?
    inputBinding:  
      prefix: --no-overlap       
    doc: |
      not concordant when mates overlap at all

  # Output options
  time:
    type: boolean?
    inputBinding:
      prefix: --time          
    doc: |
      print wall-clock time taken by search phases

  un:
    type: string?
    inputBinding:
      prefix: --un 
    doc: |
      write unpaired reads that didn't align to <path>

  al:
    type: string?
    inputBinding:  
      prefix: --al           
    doc: |
      write unpaired reads that aligned at least once to <path>
  
  un_conc:
    type: string?
    inputBinding:
      prefix: --un-conc 
    doc: |
      write pairs that didn't align concordantly to <path>
  
  al_conc:
    type: string?
    inputBinding:
      prefix: --al-conc 
    doc: |
      write pairs that aligned concordantly at least once to <path>
    #need to add gzip and bzip options - value from as an option or separate options?
    #	(Note: for --un, --al, --un-conc, or --al-conc, add '-gz' to the option name, e.g.
    #  prefix: --un-gz <path>, to gzip compress output, or add '-bz2' to bzip2 compress output.)
  
  quiet:
    type: boolean?
    inputBinding:
      prefix: --quiet            
    doc: |
      print nothing to stderr except serious errors

  met_file:
    type: string?
    inputBinding:
      prefix: --met-file
    doc: |
      send metrics to file at <path> (off)

  met_stderr:
    type: boolean?
    inputBinding:
      prefix: --met-stderr       
    doc: |
      send metrics to stderr (off)
  
  met:
    type: int?
    inputBinding:
      prefix: --met        
    doc: |
      report internal counters & metrics every <int> secs (1)

  no_unal:
    type: boolean?
    inputBinding:
      prefix: --no-unal          
    doc: |
      supppress SAM records for unaligned reads

  no_head:
    type: boolean?
    inputBinding:
      prefix: --no-head          
    doc: |
      supppress header lines, i.e. lines starting with @
  
  no_sq:
    type: boolean?
    inputBinding:
      prefix: --no-sq            
    doc: |
      supppress @SQ header lines

  rg_id:
    type: string?
    inputBinding:  
      prefix: --rg-id 
    doc: |
      set read group id, reflected in @RG line and RG:Z: opt field

  rg:
    type: string?
    inputBinding:
      prefix: --rg
    doc: |
      add <text> ("lab:value") to @RG line of SAM header. 
      Note: @RG line only printed when --rg-id is set.

  omit_sec_seq:
    type: boolean?
    inputBinding:
      prefix: --omit-sec-seq     
    doc: |
      put '*' in SEQ and QUAL fields for secondary alignments.

  # Performance options
  threads:
    type: int?
    inputBinding:
      prefix: --threads
    doc: |
      number of alignment threads to launch (1)

  reorder:
    type: boolean?
    inputBinding:
      prefix: --reorder          
    doc: |
      force SAM output order to match order of input reads

  mm: 
    type: boolean?
    inputBinding:
      prefix: --mm               
    doc: |
      use memory-mapped I/O for index; many 'bowtie's can share

  # Other options:
  qc_filter:
    type: boolean?
    inputBinding:
      prefix: --qc-filter        
    doc: |
      filter out reads that are bad according to QSEQ filter

  seed:
    type: int?
    inputBinding:
      prefix: --seed       
    doc: |
      seed for random number generator (0)

  non_deterministic:
    type: boolean?
    inputBinding:
      prefix: --non-deterministic 
    doc: |
      seed rand. gen. arbitrarily instead of using read attributes

outputs:
  sam_out:
    type: File?
    outputBinding:
      glob: $(inputs.sam)

  unal_seqs:
    type: File?
    outputBinding:
      glob: |
        ${
          if (inputs.un) {
            return inputs.un;
          } else {
            return [];
          }
        }
