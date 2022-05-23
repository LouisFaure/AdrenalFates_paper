find aligned -size 0 -print -delete
runVelo() {
  refpath=/home/lfaure/tools/refs
  velocyto run-smartseq2 -o . -m $refpath/mm39_rmsk.gtf -e $1 aligned/$1/*unique.bam $refpath/star/gencode.vM27.annotation.gtf
}
export -f runVelo

declare -a plates
plates=(`cat plates`)

parallel -j 20 runVelo ::: "${plates[@]}"
