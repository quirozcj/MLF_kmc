#!/bin/bash
#SBATCH --partition=jic-long,nbi-long
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem 30G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log3/kmc_tran.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log3/kmc_tran.%N.%j.err # STDERR
#SBATCH --job-name=kmc_tran
#SBATCH --array=0-14


i=$SLURM_ARRAY_TASK_ID 

# source kmc-3.0.1

function log_line() {
	echo $(date) "$1" >&2
}

log_line "all script START"


metadata='/jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/metadata_wilds'
mapfile -t databases < ${metadata}/kmer_wilds_paths.tsv
mapfile -t names < ${metadata}/kmer_wilds.tsv


db=${databases[$i]}
sample_id=${names[$i]}


out_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers/${sample_id}
mkdir -p $out_dir

./kmc_tools -t1 -ci2 transform ${db} reduce $out_dir/${sample_id} -ci2


db_count_tmp=$(./kmc_tools -t1 dump $out_dir/${sample_id} /dev/stdout | wc -l)
db_count=$(( $db_count_tmp - 1 ))

echo -e $sample_id' \t '$db_count > $out_dir/${sample_id}_kmer_cout.tsv

log_line "all script END"