#!/bin/bash
#SBATCH --partition=jic-long,nbi-long
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem 15G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log3/MLF_pan.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log3/MLF_pan.%N.%j.err # STDERR
#SBATCH --job-name=MLF_pan

###SBATCH --array=0-50


# i=$SLURM_ARRAY_TASK_ID

# source kmc-3.0.1

function log_line() {
	echo $(date) "$1" >&2
}

log_line "all script START"


# metadata='/jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/metadata'
# mapfile -t databases < ${metadata}/ref_paths.tsv
# mapfile -t ref_names < ${metadata}/ref_names.tsv


# db=${databases[$i]}
# reference=${ref_names[$i]}


# ref_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers/${reference}


# db_count_tmp=$(./kmc_tools -t1 dump ${db} /dev/stdout | wc -l)
# db_count=$(( $db_count_tmp - 1 ))

# echo -e $reference' \t '$db_count > $ref_dir/${reference}_kmer_cout.tsv

# log_line "all script END"



reference="T_timopheevii_raws_subtract"
ref_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers/${reference}


db_count_tmp=$(./kmc_tools -t1 dump ${ref_dir}/${reference} /dev/stdout | wc -l)
db_count=$(( $db_count_tmp - 1 ))

echo -e $reference' \t '$db_count > $ref_dir/${reference}_kmer_cout.tsv

log_line "all script END"


log_line "histo START"
./kmc_tools histogram ${ref_dir}/${reference} ${ref_dir}/${reference}_histo.txt
log_line "histo DONE"

