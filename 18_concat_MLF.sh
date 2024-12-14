#!/bin/bash
#SBATCH --partition=jic-short,jic-long,jic-medium
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem 20G
#SBATCH -o /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log3/MLF_concat.%N.%j.out # STDOUT
#SBATCH -e /jic/scratch/groups/Cristobal-Uauy/quirozj/26_uk_cgiar/scripts/log3/MLF_concat.%N.%j.err # STDERR
#SBATCH --job-name=MLF_concat

function log_line() {
	echo $(date) "$1" >&2
}

time

log_line "all script START"


group=hexa_final
reference="Th_intermedium_wilds_subtract"

### put more space to concatenate large number of files ###
ulimit -s 65536

jacc_dir=/jic/scratch/projects/watseq/kmer_agis/uk_cgiar/02_jaccards/${group}/${reference}
out_dir=/jic/scratch/projects/watseq/kmer_agis/uk_cgiar/02_jaccards/${group}/01_concatenated
mkdir -p $out_dir

cd $jacc_dir

cat ${reference}* > ../01_concatenated/${reference}_vs_${group}_jacc.tsv
log_line "all script DONE"

time
# header='reference' \t 'ref_count'
# echo -e 'reference' \t 'ref_count' \t 'query' \t 'kmer_count' \t 'common_kmer' \t 'jacc_dist'

# echo -e '\reference\ref_count\query\tuniversity\kmer_count\common_kmer\jacc_dist\n' | cat - ${jacc_dir}/Ae_kotschyii_wilds_subtract_vs_hexa_all.tsv > ${jacc_dir}/Ae_kotschyii_wilds_subtract_vs_hexa_all_header.tsv


# # echo -e "name\tage\tuniversity\tcity" | cat - yourfile > /tmp/out && mv /tmp/out yourfile

# # sed -i '1 i \Some Header Text Here' ExtractDataFile.dat
# # 
# # awk 'BEGIN{print "header"}1' ${jacc_dir}/Ae_kotschyii_wilds_subtract_vs_hexa_all.tsv > ${jacc_dir}/Ae_kotschyii_wilds_subtract_vs_hexa_all_header.tsv

# # cd $jacc_dir
# # cat <(echo -e 'reference' \t 'ref_count' \t 'query' \t 'kmer_count' \t 'common_kmer' \t 'jacc_dist') ${jacc_dir}/Ae_kotschyii_wilds_subtract_vs_hexa_all.tsv

# awk -F',|,' 'BEGIN{print "reference"'\t'"ref_count"'\t'"query"'\t'"kmer_count"'\t'"common_kmer"'\t'"jacc_dist"}
#                  {gsub(/"/,""); 
#                   print $1,$2,$4,$5,$6}' ${jacc_dir}/Ae_kotschyii_wilds_subtract_vs_hexa_all.tsv |tr ' ' '\t'  > ${jacc_dir}/Ae_kotschyii_wilds_subtract_vs_hexa_all_header.tsv


# awk -F '|' 'BEGIN{print "reference", "ref_count", "query", "kmer_count", "common_kmer", "jacc_dist"}1' | tr ' ' '\t' ${jacc_dir}/Ae_ventricosa_wilds_subtract_runs.tsv > ${jacc_dir}/Ae_ventricosa_wilds_subtract_vs_hexa_all_header.tsv