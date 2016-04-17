#!/bin/sh

if [ $# -ne 3 ]; then
	echo "Usage: $0 [TP0 binary] [c4.5 binary] [output dir]"
	exit 1
fi

TP0=$(readlink -f $1)
C45=$(readlink -f $2)
DATADIR=$PWD
WORKDIR=$3

if [ ! -f "$TP0" ]; then
	echo "TP0 binary does not exist!" >&2
	exit 1
fi

if [ ! -f "$C45" ]; then
	echo "TP0 binary does not exist!" >&2
	exit 1
fi

gen_test () {
	$TP0 -e c -o "test" -p $1
}

run_test () {
	NAME=$1
	PARAM=$2

	$TP0 -e c -o "$NAME" -p "$PARAM"
	cp test.data "$NAME.test"
	$C45 -u -f "$NAME" > "$NAME.report"
	(printf 'name="%s"\nparams="%s"\n' "$NAME" "$PARAM"; cat "$DATADIR/plot-ej4.r") | R --vanilla >/dev/null
	mv Rplots.pdf "$NAME.pdf"

}

clean_test () {
	rm test.data test.names
}

mkdir -p "$WORKDIR"
cd "$WORKDIR"

gen_test "10000"
run_test "ej-4-data-140" "140"
run_test "ej-4-data-700" "700"
run_test "ej-4-data-3500" "3500"
clean_test
