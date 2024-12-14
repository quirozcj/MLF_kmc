#!/bin/bash
#SBATCH --partition=jic-long,nbi-long
#SBATCH --nodes=1
#SBATCH --cpus-per-task=15
#SBATCH --mem 250G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log3/kmc_complex.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log3/kmc_complex.%N.%j.err # STDERR
#SBATCH --job-name=kmc_complex

###SBATCH --array=0-9


# i=$SLURM_ARRAY_TASK_ID

# kmc-3.0.1 installed in the JIC HPC does not perform complex operations. I used KMC binaries in the script folders.
# source kmc-3.0.1


function log_line() {
	echo $(date) "$1" >&2
}


# sample_id=timopheevii


log_line "complex START"
# perform complex operation
./kmc_tools -t15 complex complex_kmc_taueschii_L1-L2.op

log_line "complex DONE"


# output path described in complex_kmc.op file
# out_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers


# reference='arinaLrFor-pg'

# out_dir=/jic/scratch/projects/watseq/kmer_agis/kmc_wheat/pangenome/kmers/${reference}


# log_line "dump START"

# dump, only to see the final result
# reference='julius-4x'
# db_count=$(./kmc_tools -t15 dump ${out_dir}/${reference} /dev/stdout | wc -l)
# echo $reference $db_count
# echo $out_dir



# ./kmc_tools -t10 -hp dump -s ${out_dir}/merged /dev/stdout |cut -f 1 > ${out_dir}/${sample_id}_merged.dump_nosorted.gz

# log_line "dump DONE"


# log_line "dump START"

# cd ${out_dir}
# sort -o timopheevii_merged.sorted2.dump ${out_dir}/timopheevii_merged.dump

# log_line "dump DONE"


# log_line "gunzip START"
# gunzip -c ${out_dir}/${sample_id}_merged.sorted.dump.gz > ${out_dir}/${sample_id}_merged.sorted.dump
# log_line "gunzip DONE"