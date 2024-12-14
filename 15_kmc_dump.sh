#!/bin/bash
#SBATCH --partition=jic-long,nbi-long
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem 15G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log3/kmc_tran.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log3/kmc_tran.%N.%j.err # STDERR
#SBATCH --job-name=kmc_tran


# source kmc-3.0.1

function log_line() {
	echo $(date) "$1" >&2
}

log_line "all script START"


sample_id='Albatross'


db_dir=/jic/scratch/projects/watseq/kmer_agis/kmc_wheat/watkins/reduced/${sample_id}
# mkdir -p $out_dir

./kmc_tools -t1 -sh dump ${db_dir}/${sample_id} /dev/stdout | head



log_line "all script END"


