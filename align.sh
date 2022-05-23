runSTAR() {
  base=$(basename $1)
  plate=$(echo $1 | rev | cut -d/ -f 4 | rev)
  well=$(echo $base | cut -d. -f 1)
  STAR --runThreadN 1 --genomeDir /home/lfaure/tools/refs/star/GRCm39_vM27_SS2/ --readFilesIn $1 --outFileNamePrefix aligned/$plate/"$well"_ --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate --outSAMstrandField intronMotif --twopassMode Basic
  samtools view -q 10 -b aligned/$plate/"$well"_Aligned.sortedByCoord.out.bam > aligned/$plate/"$well"_unique.bam
}
export -f runSTAR
readarray -d '' fastqs < <(find . -name "*.gz" -print0)
parallel -j 20 runSTAR ::: "${fastqs[@]}"
