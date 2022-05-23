runFc() {
  refpath=/home/lfaure/tools/refs
  well=$(basename $1 | cut -d_ -f 1)
  plate=$(echo $1 | rev | cut -d/ -f 2 | rev)
  featureCounts -T 1 -a $refpath/star/gencode.vM27.annotation.gtf -g gene_name -o "$plate"_"$well".txt $1
}
export -f runFc

readarray -d '' bams < <(find . -name "*unique.bam" -print0)
parallel -j 40 runFc ::: "${bams[@]}"

python merge_fC.py
rm *.txt && rm *.summary
echo "done" | mail -s "Feature counts" louis.faure75@gmail.com
