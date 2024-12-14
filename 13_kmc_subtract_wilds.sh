#!/bin/bash
#SBATCH --partition=jic-long,nbi-long
#SBATCH --nodes=1
#SBATCH --cpus-per-task=30
#SBATCH --mem 150G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log4/kmc_complex.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log4/kmc_complex.%N.%j.err # STDERR
#SBATCH --job-name=kmc_complex

###SBATCH --array=0-9


# i=$SLURM_ARRAY_TASK_ID

# kmc-3.0.1 installed in the JIC HPC does not perform complex operations. I used KMC binaries in the script folders.
# source kmc-3.0.1


function log_line() {
	echo $(date) "$1" >&2
}


sample_id=T_timopheevii_nuq

metadata='/jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/metadata_wilds'
out_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers/${sample_id}_wilds_subtract
mkdir -p $out_dir

log_line "complex START"

./kmc_tools -t30 complex ${metadata}/wilds_subtract.op

log_line "complex DONE"


db_count_tmp=$(./kmc_tools -t1 dump ${out_dir}/${sample_id}_wilds_subtract /dev/stdout | wc -l)
db_count=$(( $db_count_tmp - 1 ))

echo -e $sample_id' \t '$db_count > ${sample_id}_wilds_subtract_kmer_cout.tsv