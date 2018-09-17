#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

baseCommand: bowtie2-build

inputs:
  # references
  ref_in:
    type: File[]
    inputBinding:
      position: 2

  bt2_base:
    type: string
    inputBinding:
      position: 3

  # options
  fasta:
    type: boolean
    inputBinding: 
      position: 1
      prefix: -f
    default: true

  c:
    type: boolean?
    inputBinding: 
      position: 1
      prefix: -c

  large_index:
    type: boolean?
    inputBinding: 
      position: 1
      prefix: --large-index

  noauto:
    type: boolean?
    inputBinding: 
      position: 1
      prefix: -a

  packed:
    type: boolean?
    inputBinding: 
      position: 1
      prefix: -p

  bmax:
    type: int?
    inputBinding: 
      position: 1
      prefix: --bmax

  bmaxdivn:
    type: int?
    inputBinding: 
      position: 1
      prefix: --bmaxdivn

  dcv:
    type: int?
    inputBinding: 
      position: 1
      prefix: --dcv

  nodc:
    type: boolean?
    inputBinding: 
      position: 1
      prefix: --nodc

  noref:
    type: boolean?
    inputBinding: 
      position: 1
      prefix: -r

  justref:
    type: boolean?
    inputBinding: 
      position: 1
      prefix: "-3"

  offrate:
    type: int?
    inputBinding: 
      position: 1
      prefix: -o

  ftabchars:
    type: int?
    inputBinding: 
      position: 1
      prefix: -t

  seed:
    type: int?
    inputBinding: 
      position: 1
      prefix: --seed

  cutoff:
    type: int?
    inputBinding: 
      position: 1
      prefix: --cutoff

  quiet:
    type: boolean?
    inputBinding: 
      position: 1
      prefix: -q

  threads:
    type: int?
    inputBinding: 
      position: 1
      prefix: --threads

outputs:
  index_files:
    type: File[]
    outputBinding:
      glob: $(inputs.bt2_base).*.bt2
    
