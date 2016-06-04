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
	echo "NV binary does not exist!" >&2
	exit 1
fi

run_test () {
	PROB="$1"
	DIMS="$2"
	RUN="$3"

	PREFIX="ej-5-$PROB-data-$DIMS-$RUN"
	$NVB "$PREFIX.data" "$PREFIX.test" > "$PREFIX.nvreport"

	TRAINERR=$(grep 'Train error' "$PREFIX.nvreport" | awk -F ':' '{gsub(/(%| )/,""); print $2}')
	TESTERR=$(grep 'Test error' "$PREFIX.nvreport" | awk -F ':' '{gsub(/(%| )/,""); print $2}')
	echo "$PROB,$DIMS,$TRAINERR,$TESTERR" >> bayes-error.csv
}
export -f run_test

mkdir -p "$WORKDIR"
cd "$WORKDIR"

truncate -s0 bayes-error.csv

. $(which env_parallel.bash)
env_parallel run_test ::: a b ::: 2 4 8 16 32 ::: $(seq 1 20)
