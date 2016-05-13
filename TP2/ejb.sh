#!/bin/bash
export LC_NUMERIC=C

if [ $# -ne 3 ]; then
	echo "Usage: $0 [BP binary] [TP0 binary] [output dir]"
	exit 1
fi

export BP=$(readlink -f $1)
export TP0=$(readlink -f $2)
export DATADIR=$PWD
export WORKDIR=$3

if [ ! -f "$BP" ]; then
	echo "BP binary does not exist!" >&2
	exit 1
fi

if [ ! -f "$TP0" ]; then
	echo "TP0 binary does not exist!" >&2
	exit 1
fi

source "$DATADIR/utils.sh"

gen_data () {
	$TP0 -r cpp -e c -p 2000 -o espirales
	$TP0 -r cpp -e c -p 2000 -o espirales-test
	rm espirales.names espirales-test.names
	mv espirales-test.data espirales.test
}

run_test () {
	N2="$1"
	RUN="$2"

	PREFIX="ejb-n2-$N2-$RUN"
	gen_net "ejb.net" "$PREFIX.net" N2 "$N2" SEED "0"

	ln -f "espirales.data" "$PREFIX.data"
	ln -f "espirales.test" "$PREFIX.test"

	$BP "$PREFIX" > "$PREFIX.report"

	ERR=$(grep discreto "$PREFIX.report" | awk -F ':' '{gsub(/(%| )/,""); print $2}')
	echo "$N2,$ERR" >> discrete-error.csv
}
export -f run_test

mkdir -p "$WORKDIR"
cd "$WORKDIR"

truncate -s0 discrete-error.csv

gen_data

parallel run_test ::: 2 5 10 20 40 ::: $(seq 1 20)

clean_test "espirales"
