#!/bin/bash
#SBATCH --partition=nbi-medium,jic-medium,nbi-long,jic-long
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem 30G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log/kmc.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log/kmc.%N.%j.err # STDERR
#SBATCH --job-name=kmc
#SBATCH --array=0-264

i=$SLURM_ARRAY_TASK_ID

source kmc-3.0.1
# source IBSpy-0.3.1

function log_line() {
	echo $(date) "$1" >&2
}

# db=/ei/public/under_license/toronto/Wulff_2018-01-31_OWWC/${name}
metadata='/jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/metadata'
mapfile -t databases < ${metadata}/tauschii_paths.tsv
mapfile -t db_names < ${metadata}/tauschii_names.tsv


db=${databases[$i]}
name=${db_names[$i]}


out_dir=/jic/scratch/projects/watseq/kmer_agis/kmc_tauschii/${name}
# out_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers/${name}
mkdir -p $out_dir


log_line "sample: $name"
log_line "sample reads: $db"
log_line "sample reads: $db/${name}"
log_line "output dir: $out_dir"

# ls -d $db/${name}.fa  > ${out_dir}/${name}_reads.tsv
ls -d $db/*.gz > ${out_dir}/${name}_reads.tsv


##### remove -b \ when using raw reads (canonical option) ######


kmc \
-k31 \
-ci1 \
-m30 \
-t1 \
-fq \
@<(ls -d $db/*.gz) ${out_dir}/${name} ${out_dir}



# run raw reads
# -fq \
# @<(ls -d $db/*.gz) ${out_dir}/${name} ${out_dir}

#run fasta files
# -fm \
# $db/Wheat_Borlaug_v1.fasta.gz ${out_dir}/${name} ${out_dir} \

log_line "kmer count DONE"
kmc_tools histogram ${out_dir}/${name} ${out_dir}/${name}_histo.txt
log_line "histo DONE"