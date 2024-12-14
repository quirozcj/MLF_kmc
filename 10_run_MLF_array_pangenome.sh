#!/bin/bash
#SBATCH --partition=jic-long,nbi-long
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem 60G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log2/MLF.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log2/MLF.%N.%j.err # STDERR
#SBATCH --job-name=MLF_pg
#SBATCH --array=0-135

i=$SLURM_ARRAY_TASK_ID 

# source kmc-3.0.1

function log_line() {
	echo $(date) "$1" >&2
}

log_line "all script START"

declare -a references=("Ae_ventricosa_wilds_subtract")
# ref_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers


reference=$(($i%1))
reference=${references[$reference]}


# ref_dir=/jic/scratch/projects/watseq/kmer_agis/kmc_wheat/pangenome/kmers/${reference}
ref_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers/${reference}
# ref_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/monococcum/kmers/${reference}
# cd ${ref_dir}
ref_count=$(cut -f2 ${ref_dir}/${reference}_kmer_cout.tsv)
echo $reference $ref_count


### put more space to concatenate large number of files ###
# ulimit -s 65536
# cat *_jacc.tsv >> ../all_hexa_runs.tsv

group=gbs

metadata='/jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/metadata'
mapfile -t databases < ${metadata}/gbs_paths.tsv
mapfile -t db_names < ${metadata}/gbs_names.tsv

# some samples fail in : exa_names_12500-15000.tsv

db_i=$(($i/1)) # note thi is the number of references
db=${databases[$db_i]}
name=${db_names[$db_i]}

jacc_dir=/jic/scratch/projects/watseq/kmer_agis/uk_cgiar/02_jaccards/${group}/${reference}
# tmp_dir=/jic/scratch/projects/watseq/kmer_agis/uk_cgiar/tmp_dir/$name
tmp_dir=/jic/scratch/projects/watseq/kmer_agis/kmc_wheat/pangenome/kmers/$name
mkdir -p $jacc_dir
mkdir -p $tmp_dir

echo $jacc_dir
echo $tmp_dir
 

# log_line "kmc count START ${db} ${name}"

# kmer=31

# zcat ${db} | cut -f 3 --delimiter="," | awk 'BEGIN{cont=0}{printf ">seq_%d\n",cont; print $0;cont++}' > ${tmp_dir}/${name}.fa

# ./kmc \
# -k${kmer} \
# -ci1 \
# -m10 \
# -t1 \
# -fm ${tmp_dir}/${name}.fa ${tmp_dir}/${name} ${tmp_dir}

# log_line "kmc count END"



log_line "intersect START "

db_count=$(./kmc_tools -t1 dump ${db} /dev/stdout | wc -l)
echo $name $db_count


./kmc_tools -t1 simple ${ref_dir}/${reference} ${db} intersect ${tmp_dir}/${reference}_${name}_intersect

rq_inter=$(./kmc_tools -t1 dump ${tmp_dir}/${reference}_${name}_intersect /dev/stdout | wc -l)
echo $rq_inter

log_line "intersect DONE "



sette=$(( $db_count + $ref_count ));otto=$(( $sette - $rq_inter ))
jacc_dist=$(echo "scale=10;$rq_inter/$otto" | bc -l )
echo $jacc_dist

echo -e ${reference}' \t '${ref_count}' \t '${name}' \t '${db_count}' \t '${rq_inter}' \t '${jacc_dist} > $jacc_dir/${reference}_vs_${name}_jacc.tsv

log_line "all script DONE"

wait
cd ${tmp_dir}
rm ${reference}_${name}_intersect*

##### concatenate at the end ###########
# cat *jacc.tsv >> ../hexa_concat/hexa_vs_timopheevii_concat.tsv
