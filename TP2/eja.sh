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
	LRNRATE="$1"
	MOMENTUM="$2"
	RUN="$3"

	PREFIX="eja-l-$LRNRATE-m-$MOMENTUM-$RUN"
	gen_net "eja.net" "$PREFIX.net" LRNRATE "$LRNRATE" MOMENTUM "$MOMENTUM" SEED "0"

	ln -f "dos_elipses.data" "$PREFIX.data"
	ln -f "dos_elipses.test" "$PREFIX.test"

	$BP "$PREFIX" > "$PREFIX.report"

	ERR=$(grep discreto "$PREFIX.report" | awk -F ':' '{gsub(/(%| )/,""); print $2}')
	echo "$LRNRATE,$MOMENTUM,$ERR" >> discrete-error.csv
}
export -f run_test

mkdir -p "$WORKDIR"
cd "$WORKDIR"

truncate -s0 discrete-error.csv

get_data 'https://sites.google.com/site/aprendizajeautomatizadounr/Inicio/datasets/dos_elipses.zip?attredirects=0&d=1'

parallel run_test ::: 0.001 0.01 0.1 ::: 0 0.5 0.9 ::: $(seq 1 20)

clean_test "dos_elipses"
