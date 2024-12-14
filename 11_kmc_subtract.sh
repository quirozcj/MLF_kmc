#!/bin/bash
#SBATCH --partition=jic-long,nbi-long
#SBATCH --nodes=1
#SBATCH --cpus-per-task=30
#SBATCH --mem 120G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log3/kmc_inter.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log3/kmc_inter.%N.%j.err # STDERR
#SBATCH --job-name=kmc_inter

###SBATCH --array=0-9


# i=$SLURM_ARRAY_TASK_ID

# kmc-3.0.1 installed in the JIC HPC does not perform complex operations. I used KMC binaries in the script folders.


function log_line() {
	echo $(date) "$1" >&2
}


group=hexa



ref_id=T_timopheevii_wilds_subtract_par
ref_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers/${ref_id}


query=cadenza2 
query_dir=/jic/scratch/projects/watseq/kmer_agis/kmc_wheat/pangenome/kmers/${query}

out_dir=/jic/scratch/groups/Cristobal-Uauy/quirozj/00_kmers/wilds/kmers/${ref_id}_parcad
mkdir -p ${out_dir}



log_line "subtract START ${mem}"

./kmc_tools -t30 simple ${ref_dir}/${ref_id} ${query_dir}/${query} kmers_subtract ${out_dir}/${ref_id}_parcad

log_line "subtract DONE ${mem}"



db_count_tmp=$(./kmc_tools -t30 dump ${out_dir}/${ref_id}_parcad /dev/stdout | wc -l)
db_count=$(( $db_count_tmp - 1 ))

echo -e ${ref_id}_parcad' \t '$db_count > ${out_dir}/${ref_id}_parcad_kmer_cout.tsv


log_line "histo START"
./kmc_tools histogram ${out_dir}/${ref_id}_parcad ${out_dir}/${ref_id}_parcad_histo.txt
log_line "histo DONE"

# log_line "kmer Jaccard's START"

# due=$(./kmc_tools -t${th} dump ${query_dir}/${query} /dev/stdout | wc -l)
# echo $due

# dump, only to see the final result
# tre=$(./kmc_tools -t${th} dump ${query_dir}/${ref_id}_${query}_subtract_${th}_${mem} /dev/stdout | wc -l)
# echo $tre

# uno=12127388878
# due=5530407
# tre=1617605



# sette=$(( $due + $uno ));otto=$(( $sette - $tre ))
# distan=$(echo "scale=10;$tre/$otto" | bc -l )
# log_line "kmer Jaccard's END"

# echo $distan

# echo -e ${group}_${query}' \t '${due}' \t '${tre}' \t '$distan > $query_dir/${query}_vs_${ref_id}.tsv

# ./kmc_tools -t${th}  -hp dump -s ${query_dir}/${ref_id}_${query}_subtract_${th}_${mem} /dev/stdout |cut -f 1 > ${query_dir}/${ref_id}_merged.dump_nosorted.gz
