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
	TRAIN="$1"
	RUN="$2"

	PREFIX="ejc-t-$TRAIN-$RUN"
	gen_net "$WORKDIR/ikeda.net" "$PREFIX.net" '^100$' "$TRAIN"

	ln -f "ikeda.data" "$PREFIX.data"
	ln -f "ikeda.test" "$PREFIX.test"

	$BP "$PREFIX" > "$PREFIX.report"

	ERR=$(grep Test: "$PREFIX.report" | tail -n1 | awk -F ':' '{gsub(/(%| )/,""); print $2}')
	echo "$TRAIN,$ERR" >> test-error.csv
}
export -f run_test

mkdir -p "$WORKDIR"
cd "$WORKDIR"

truncate -s0 test-error.csv

get_data 'https://sites.google.com/site/aprendizajeautomatizadounr/Inicio/datasets/ikeda.zip?attredirects=0&d=1'
mv ikeda/ikeda.net ikeda.net.tmpl
mv ikeda/* .
rmdir ikeda

parallel run_test ::: 190 150 100 ::: $(seq 1 21)

clean_test "ikeda"
