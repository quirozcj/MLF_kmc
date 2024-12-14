# AIM: run "Missing Link Finder" using KMC

## The current pipeline was modified from: https://github.com/emilecg/wheat_evolution and was publushed in: https://doi.org/10.1038/s41586-024-07808-z 


## Create DArTseq kmers from the "query" samples:

- DArTseq reads come in ```FASTQCOL.gz``` format.
- Sequences are ~70 bp
- We use 31mers
- To transform ```FASTQCOL.gz``` into fasta files and create kmers use:

```sh
01_query_kmc.sh
```

## Create kmers from samples to use as a "reference"

- When using raw reads remove -b option to avoid canonical kmers.
- In this example qe use Whole Genome Sequences from 11 accesions of T. timopeevii (individual samples). Ran separately.
- We used 31 mers

```sh
02_ref_kmc.sh
```

## Merge reference samples and build a single dump file keeping only the kmers sequences without counters

### NOTE: KMC in the JIC HPC fails to run complex operatios. To solve this we download KMC binaries from: ```https://github.com/refresh-bio/KMC/issues/54```
- These are the binary files we have to put in the directory "scrips" from we are running. We can redirect the ouptut with the ```complex_kmc.op``` below.
- kmc
- kmc_tools


- Use ```kmc_tools``` complex operations.
- Complex operation requeres an external file (```complex_kmc.op```) describing the operations to perform.
- The ```complex_kmc.op``` has the name of the samples, input paths, and ouput paths.
- We included ```dump``` operations and ```gzip``` in this step to generate the final kmer matrix to compare.

```sh
03_ref_dump_merge.sh
```

## Run " Missing Link Finder" which compares the "reference" vs each of the "queries" one at a time
04_run_MLF.sh
