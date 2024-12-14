#!/bin/bash
#SBATCH --partition=jic-long,nbi-long
#SBATCH --nodes=1
#SBATCH --cpus-per-task=30
#SBATCH --mem 250G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log10/kmc_complex.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log10/kmc_complex.%N.%j.err # STDERR
#SBATCH --job-name=kmc_complex

###SBATCH --array=0-9


# i=$SLURM_ARRAY_TASK_ID

# kmc-3.0.1 installed in the JIC HPC does not perform complex operations. I used KMC binaries in the script folders.
# source kmc-3.0.1


function log_line() {
	echo $(date) "$1" >&2
}


sample_id=T_durum

metadata='/jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/metadata_wilds'
out_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers/${sample_id}_wilds_subtract
# out_dir=/jic/scratch/projects/watseq/kmer_agis/uk_cgiar/01_kmers/wilds/${sample_id}_wilds_subtract
mkdir -p $out_dir

log_line "complex START"

./kmc_tools -t30 complex ${metadata}/wilds_subtract.op

log_line "complex DONE"


log_line "count START"
db_count_tmp=$(./kmc_tools -t30 dump ${out_dir}/${sample_id}_wilds_subtract /dev/stdout | wc -l)
db_count=$(( $db_count_tmp - 1 ))

echo -e ${sample_id}_wilds_subtract' \t '$db_count > ${out_dir}/${sample_id}_wilds_subtract_kmer_cout.tsv

log_line "count DONE"



log_line "histo START"
./kmc_tools histogram ${out_dir}/${sample_id}_wilds_subtract ${out_dir}/${sample_id}_wilds_subtract_histo.txt
log_line "histo DONE"
