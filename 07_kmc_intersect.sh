#!/bin/bash
#SBATCH --partition=jic-long,nbi-long
#SBATCH --nodes=1
#SBATCH --cpus=1
#SBATCH --mem 5G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log2/kmc_inter.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log2/kmc_inter.%N.%j.err # STDERR
#SBATCH --job-name=kmc_inter

###SBATCH --array=0-9


# i=$SLURM_ARRAY_TASK_ID

# kmc-3.0.1 installed in the JIC HPC does not perform complex operations. I used KMC binaries in the script folders.
# source kmc-3.0.1


function log_line() {
	echo $(date) "$1" >&2
}




group=hexa

# log_line "complex START"
# perform complex operation
# ./kmc_tools -t31 complex complex_kmc.op

# log_line "complex DONE"

# output path described in complex_kmc.op file
ref_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers
ref_id=merged

query_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/01_kmers
query='100055'

mem=5

th=1

# log_line "intersect START ${mem}"


# ./kmc_tools -t${th} simple ${ref_dir}/${ref_id} ${query_dir}/${query} intersect ${query_dir}/${ref_id}_${query}_intersect_${th}_${mem}

# log_line "intersect DONE ${mem}"

log_line "kmer Jaccard's START"

due=$(./kmc_tools -t${th} dump ${query_dir}/${query} /dev/stdout | wc -l)
echo $due

# dump, only to see the final result
tre=$(./kmc_tools -t${th} dump ${query_dir}/${ref_id}_${query}_intersect_${th}_${mem} /dev/stdout | wc -l)
echo $tre

uno=12127388878
# due=5530407
# tre=1617605



sette=$(( $due + $uno ));otto=$(( $sette - $tre ))
distan=$(echo "scale=10;$tre/$otto" | bc -l )
log_line "kmer Jaccard's END"

echo $distan

echo -e ${group}_${query}' \t '${due}' \t '${tre}' \t '$distan > $query_dir/${query}_vs_${ref_id}.tsv

# ./kmc_tools -t${th}  -hp dump -s ${query_dir}/${ref_id}_${query}_intersect_${th}_${mem} /dev/stdout |cut -f 1 > ${query_dir}/${ref_id}_merged.dump_nosorted.gz



