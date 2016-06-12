#!/bin/bash
export LC_NUMERIC=C

if [ $# -ne 2 ]; then
	echo "Usage: $0 [NVB binary] [output dir]"
	exit 1
fi

export NVB=$(readlink -f $1)
export DATADIR=$PWD
export WORKDIR=$2

if [ ! -f "$NVB" ]; then
	echo "NVB binary does not exist!" >&2
	exit 1
fi

source "$DATADIR/../TP2/utils.sh"

run_test () {
	BINS=$1
	RUN=$2
	PREFIX="dos_elipses-bin-$BINS-run-$RUN"

	shuf dos_elipses.data > "$PREFIX.shuf"
	head -n 400 "$PREFIX.shuf" > "$PREFIX.data"
	tail -n +401 "$PREFIX.shuf" | head -n 100 > "$PREFIX.val"
	rm "$PREFIX.shuf"

	$NVB "$PREFIX.data" "$PREFIX.val" "$BINS" > "$PREFIX.vreport"
	$NVB "$PREFIX.data" "dos_elipses.test" "$BINS" > "$PREFIX.treport"

	TRAIN=$(grep 'Train error' "$PREFIX.vreport" | awk -F ':' '{gsub(/(%| )/,""); print $2}')
	VAL=$(grep 'Test error' "$PREFIX.vreport" | awk -F ':' '{gsub(/(%| )/,""); print $2}')
	TEST=$(grep 'Test error' "$PREFIX.treport" | awk -F ':' '{gsub(/(%| )/,""); print $2}')
	echo "$BINS,$TRAIN,$VAL,$TEST" >> bayes-error.csv

}
export -f run_test

run_test_espirales () {
	BINS=$1
	RUN=$2
	PREFIX="espirales-bin-$BINS-run-$RUN"

	shuf espirales.data > "$PREFIX.shuf"
	head -n 1600 "$PREFIX.shuf" > "$PREFIX.data"
	tail -n +1601 "$PREFIX.shuf" > "$PREFIX.val"
	rm "$PREFIX.shuf"

	$NVB "$PREFIX.data" "$PREFIX.val" "$BINS" > "$PREFIX.vreport"
	$NVB "$PREFIX.data" "espirales.test" "$BINS" > "$PREFIX.treport"

	TRAIN=$(grep 'Train error' "$PREFIX.vreport" | awk -F ':' '{gsub(/(%| )/,""); print $2}')
	VAL=$(grep 'Test error' "$PREFIX.vreport" | awk -F ':' '{gsub(/(%| )/,""); print $2}')
	TEST=$(grep 'Test error' "$PREFIX.treport" | awk -F ':' '{gsub(/(%| )/,""); print $2}')
	echo "$BINS,$TRAIN,$VAL,$TEST" >> bayes-error-espirales.csv

}
export -f run_test_espirales

mkdir -p "$WORKDIR"
cd "$WORKDIR"

truncate -s0 bayes-error.csv
truncate -s0 bayes-error-espirales.csv

get_data 'https://sites.google.com/site/aprendizajeautomatizadounr/Inicio/datasets/dos_elipses.zip?attredirects=0&d=1'

. $(which env_parallel.bash)
env_parallel run_test ::: $(seq 1 1 100) ::: $(seq 1 21)
env_parallel run_test_espirales ::: $(seq 1 1 100) ::: $(seq 1 21)

#Rscript "$DATADIR/plot-ej3.r"
#mv Rplots.pdf bayes-errors.pdf
