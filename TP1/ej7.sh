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
	$TP0 -r cpp -e "$1" -o "test-$1-$2" -p "$2 10000 0.78"
}

run_test () {
	TEST=$1
	NAME=$2
	D=$3
	PARAM="$D 250 0.78"
	SET="$TEST,$D"

	$TP0 -r cpp -e "$TEST" -o "$NAME" -p "$PARAM"
	cp "test-$TEST-$D.data" "$NAME.test"
	$C45 -u -f "$NAME" > "$NAME.report"

	# Error percentage
	echo -n "$SET," >> plot-error-after-prune.csv
	cat "$NAME.report" | grep '<<' | awk -F "[()]" '{gsub(/(%| )/,""); print $4}'| paste -d "," - - >> plot-error-after-prune.csv
}

gen_plot () {
	NAME=$1
	TITLE=$2

	(printf 'file="%s.csv"\ntitle="%s"\n' "$NAME" "$TITLE"; cat "$DATADIR/plot-ej7.r") | R --vanilla >/dev/null
	mv Rplots.pdf "$NAME.pdf"

}

clean_test () {
	rm test-*.data test-*.names
}

mkdir -p "$WORKDIR"
cd "$WORKDIR"

truncate -s0 plot-error-after-prune.csv

for test in a b; do
	for d in 2 4 8 16 32; do
		gen_test "$test" "$d"
		for nr in $(seq 1 20); do
			run_test "$test" "ej-5-$test-data-$d-$nr" "$d"
		done
	done
done

gen_plot "plot-error-after-prune"  "luego de pruning"

clean_test
