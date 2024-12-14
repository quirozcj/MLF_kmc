#!/bin/bash
#SBATCH --partition=jic-long,nbi-long
#SBATCH --nodes=1
#SBATCH --cpus=25
#SBATCH --mem 60G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log/kmc.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log/kmc.%N.%j.err # STDERR
#SBATCH --job-name=kmcTE

###SBATCH --array=0-9


# i=$SLURM_ARRAY_TASK_ID

source kmc-3.0.1


function log_line() {
	echo $(date) "$1" >&2
}

# i="101219" \
group=tetra

in_dir=/jic/research-groups/Cristobal-Uauy/Jesus/CIMMYT/${group}
metadata='/jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/metadata'
out_dir='/jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/01_kmers'
mkdir -p $out_dir/kmc_tmp
mkdir -p $out_dir/${group}


# ls /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/metadata/tetra_samples.tsv
# ls /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/metadata/cwr_samples.tsv
# mapfile -t databases < $in_dir/urartu_kmers.tsv
# mapfile -t db_names < ${metadata}/names.tsv

# declare -a db_names=(\
# "100050" \
# "100051" \
# "100052" \
# "100053" \
# "100054" \
# "100055" \
# "100056" \
# "100057" \
# "100058" \
# "100059" \
# )

# sample_id=${db_names[$i]}

# db_i=$(($i/1))
# db=${databases[$db_i]}
# name=${db_names[$db_i]}

# sample_id=${db_names[$i]}

kmer=31
#
for i in $(cat ${metadata}/${group}_batch5.tsv)
do


zcat $in_dir/${i}.FASTQCOL.gz | cut -f 3 --delimiter="," | awk 'BEGIN{cont=0}{printf ">seq_%d\n",cont; print $0;cont++}' > ${out_dir}/${i}.fa

kmc \
-k${kmer} \
-ci1 \
-m60 \
-t25 \
-fm ${out_dir}/${i}.fa ${out_dir}/${i} ${out_dir}/kmc_tmp

log_line "kmer count DONE"

kmc_tools -t25 transform ${out_dir}/${i} dump ${out_dir}/${i}.txt

log_line "kmer dump DONE"

cut -f 1 ${out_dir}/${i}.txt | sort |
gzip > $out_dir/${group}/${i}_${kmer}mers.fa.gz

log_line "gzip DONE"

# # wait
cd ${out_dir}/
rm ${i}*

# time

done

