#!/bin/bash
#SBATCH --partition=jic-short,jic-long,jic-medium,nbi-medium,nbi-long,nbi-short
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem 35G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log11/MLF_wld.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log11/MLF_wld.%N.%j.err # STDERR
#SBATCH --job-name=MLF_wld
#SBATCH --array=0-2500


###SBATCH --array=0-2500

i=$SLURM_ARRAY_TASK_ID



if [[ $((SLURM_ARRAY_TASK_ID % 2500)) == 0 ]] ; then 
    sbatch --array=$((SLURM_ARRAY_TASK_ID+1))-$((SLURM_ARRAY_TASK_ID+2500)) $0
fi
# else
# 	if [[ $((SLURM_ARRAY_TASK_ID % 5000)) == 0 ]] ; then 
# 	    sbatch --array=$((SLURM_ARRAY_TASK_ID+1))-$((SLURM_ARRAY_TASK_ID+2500)) $0

# else
# 	if [[ $((SLURM_ARRAY_TASK_ID % 7500)) == 0 ]] ; then 
# 	    sbatch --array=$((SLURM_ARRAY_TASK_ID+1))-$((SLURM_ARRAY_TASK_ID+2500)) $0
# 	fi
# 	fi
# fi
# source kmc-3.0.1

function log_line() {
	echo $(date) "$1" >&2
}

log_line "all script START"

declare -a references=("T_durum_wilds_subtract")
# ref_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers
# 
# 

reference=$(($i%1))
reference=${references[$reference]}


# ref_dir=/jic/scratch/projects/watseq/kmer_agis/kmc_wheat/hexa_final/kmers/${reference}
# ref_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers/${reference}
ref_dir=/jic/scratch/projects/watseq/kmer_agis/uk_cgiar/01_kmers/wilds/${reference}
# cd ${ref_dir}
ref_count=$(cut -f2 ${ref_dir}/${reference}_kmer_cout.tsv)
echo $reference $ref_count


### put more space to concatenate large number of files ###
# ulimit -s 65536
# for f in *.err; do rm "$f"; done
# cat *_jacc.tsv >> ../all_hexa_runs.tsv

group=hexa_final

metadata='/jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/metadata'
# mapfile -t databases < ${metadata}/hexa_paths_5000.tsv
# mapfile -t db_names < ${metadata}/hexa_names_5000.tsv
# mapfile -t databases < ${metadata}/hexa_paths_10000.tsv
# mapfile -t db_names < ${metadata}/hexa_names_10000.tsv
# mapfile -t databases < ${metadata}/hexa_paths_15000.tsv
# mapfile -t db_names < ${metadata}/hexa_names_15000.tsv
mapfile -t databases < ${metadata}/hexa_paths_20000.tsv
mapfile -t db_names < ${metadata}/hexa_names_20000.tsv
# mapfile -t databases < ${metadata}/hexa_paths_25000.tsv
# mapfile -t db_names < ${metadata}/hexa_names_25000.tsv
# mapfile -t databases < ${metadata}/hexa_paths_30000.tsv
# mapfile -t db_names < ${metadata}/hexa_names_30000.tsv
# mapfile -t databases < ${metadata}/hexa_paths_35000.tsv
# mapfile -t db_names < ${metadata}/hexa_names_35000.tsv
# mapfile -t databases < ${metadata}/hexa_paths_40000.tsv
# mapfile -t db_names < ${metadata}/hexa_names_40000.tsv
# mapfile -t databases < ${metadata}/hexa_paths_45000.tsv
# mapfile -t db_names < ${metadata}/hexa_names_45000.tsv
# mapfile -t databases < ${metadata}/hexa_paths_50000.tsv
# mapfile -t db_names < ${metadata}/hexa_names_50000.tsv
# mapfile -t databases < ${metadata}/hexa_paths_55000.tsv
# mapfile -t db_names < ${metadata}/hexa_names_55000.tsv
# mapfile -t databases < ${metadata}/hexa_paths_60000.tsv
# mapfile -t db_names < ${metadata}/hexa_names_60000.tsv
# mapfile -t databases < ${metadata}/hexa_paths_65000.tsv
# mapfile -t db_names < ${metadata}/hexa_names_65000.tsv
# mapfile -t databases < ${metadata}/hexa_paths_66275.tsv
# mapfile -t db_names < ${metadata}/hexa_names_66275.tsv

# mapfile -t databases < ${metadata}/tetra_paths_5000.tsv
# mapfile -t db_names < ${metadata}/tetra_names_5000.tsv
# mapfile -t databases < ${metadata}/tetra_paths_10000.tsv
# mapfile -t db_names < ${metadata}/tetra_names_10000.tsv
# mapfile -t databases < ${metadata}/tetra_paths_15000.tsv
# mapfile -t db_names < ${metadata}/tetra_names_15000.tsv
# mapfile -t databases < ${metadata}/tetra_paths_20000.tsv
# mapfile -t db_names < ${metadata}/tetra_names_20000.tsv
# mapfile -t databases < ${metadata}/tetra_paths_22197.tsv
# mapfile -t db_names < ${metadata}/tetra_names_22197.tsv
# mapfile -t databases < ${metadata}/cwr_paths.tsv
# mapfile -t db_names < ${metadata}/cwr_names.tsv
# 
# mapfile -t databases < ${metadata}/rerun_paths.tsv
# mapfile -t db_names < ${metadata}/rerun_names.tsv


db_i=$(($i/1)) # note thi is the number of references
db=${databases[$db_i]}
name=${db_names[$db_i]}

jacc_dir=/jic/scratch/projects/watseq/kmer_agis/uk_cgiar/02_jaccards/${group}/${reference}
tmp_dir=/jic/scratch/projects/watseq/kmer_agis/uk_cgiar/tmp_dir/$name
# tmp_dir=/jic/scratch/projects/watseq/kmer_agis/kmc_wheat/pangenome/kmers/$name
mkdir -p $jacc_dir
mkdir -p $tmp_dir
mkdir -p $tmp_dir_ref

echo $jacc_dir
echo $tmp_dir
 
# ______________________________________________________

# log_line "kmc count START ${db} ${name}"

# kmer=31

# zcat ${db} | cut -f 3 --delimiter="," | awk 'BEGIN{cont=0}{printf ">seq_%d\n",cont; print $0;cont++}' > ${tmp_dir}/${name}.fa

# ./kmc \
# -k${kmer} \
# -ci1 \
# -m40 \
# -t1 \
# -fm ${tmp_dir}/${name}.fa ${tmp_dir}/${name} ${tmp_dir}

# log_line "kmc count END"

# ________________________________________________________


log_line "intersect START "

db_count=$(./kmc_tools -t1 dump ${tmp_dir}/${name} /dev/stdout | wc -l)
echo $name $db_count


./kmc_tools -t1 simple ${ref_dir}/${reference} ${tmp_dir}/${name} intersect ${tmp_dir}/${reference}_${name}_intersect

rq_inter=$(./kmc_tools -t1 dump ${tmp_dir}/${reference}_${name}_intersect /dev/stdout | wc -l)
echo $rq_inter

log_line "intersect DONE "

# ________________________________________________________

sette=$(( $db_count + $ref_count ));otto=$(( $sette - $rq_inter ))
jacc_dist=$(echo "scale=10;$rq_inter/$otto" | bc -l )
echo $jacc_dist

echo -e ${reference}' \t '${ref_count}' \t '${name}' \t '${db_count}' \t '${rq_inter}' \t '${jacc_dist} > $jacc_dir/${reference}_vs_${name}_jacc.tsv

log_line "all script DONE"

wait
cd ${tmp_dir}
rm ${reference}_${name}_intersect*

# ________________________________________________________

##### concatenate at the end ###########
# cat *jacc.tsv >> ../hexa_concat/hexa_vs_timopheevii_concat.tsv

# 