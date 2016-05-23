#!/bin/bash
export LC_NUMERIC=C

if [ $# -ne 2 ]; then
	echo "Usage: $0 [BP binary] [output dir]"
	exit 1
fi

export BP=$(readlink -f $1)
export DATADIR=$PWD
export WORKDIR=$2

if [ ! -f "$BP" ]; then
	echo "BP binary does not exist!" >&2
	exit 1
fi

source "$DATADIR/utils.sh"

run_test () {
	PROB="$1"
	DIMS="$2"
	RUN="$3"

	PREFIX="ej-5-$PROB-data-$DIMS-$RUN"
	gen_net "eje.net" "$PREFIX.net" DIMS "$DIMS" SEED "$(rand)"

	$BP "$PREFIX" > "$PREFIX.bpreport"

	ERR=$(grep discreto "$PREFIX.bpreport" | awk -F ':' '{gsub(/(%| )/,""); print $2}')
	echo "$PROB,$DIMS,$ERR" >> discrete-error.csv
}
export -f run_test

mkdir -p "$WORKDIR"
cd "$WORKDIR"

truncate -s0 discrete-error.csv

parallel run_test ::: a b ::: 2 4 8 16 32 ::: $(seq 1 20)
