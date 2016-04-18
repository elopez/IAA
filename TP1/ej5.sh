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
	$TP0 -r cpp -e "$1" -o "test-$1" -p "2 $2 0.75"
}

run_test () {
	TEST=$1
	NAME=$2
	PARAM="2 $3 0.75"
	SET="$TEST,$3"

	$TP0 -r cpp -e "$TEST" -o "$NAME" -p "$PARAM"
	cp "test-$TEST.data" "$NAME.test"
	$C45 -u -f "$NAME" > "$NAME.report"

	# Error percentage
	echo -n "$SET," >> plot-error-before-prune.csv
	cat "$NAME.report" | grep '<<' | awk -F "[()]" '{gsub(/(%| )/,""); print $2}'| paste -d "," - - >> plot-error-before-prune.csv
	echo -n "$SET," >> plot-error-after-prune.csv
	cat "$NAME.report" | grep '<<' | awk -F "[()]" '{gsub(/(%| )/,""); print $4}'| paste -d "," - - >> plot-error-after-prune.csv

	# Tree sizes
	echo -n "$SET," >> plot-size-before-prune.csv
	cat "$NAME.report" | grep '<<' | awk -F "[()]" '{print $1}' | awk '{print $1}' | head -n1 >> plot-size-before-prune.csv
	echo -n "$SET," >> plot-size-after-prune.csv
	cat "$NAME.report" | grep '<<' | awk -F "[()]" '{print $3}' | awk '{print $1}' | head -n1 >> plot-size-after-prune.csv
}

gen_plot () {
	PLOT=$1
	NAME=$2
	TITLE=$3

	(printf 'file="%s.csv"\ntitle="%s"\n' "$NAME" "$TITLE"; cat "$DATADIR/plot-ej5-$PLOT.r") | R --vanilla >/dev/null
	mv Rplots.pdf "$NAME.pdf"

}

clean_test () {
	rm test-a.data test-a.names test-b.data test-b.names
}

mkdir -p "$WORKDIR"
cd "$WORKDIR"

truncate -s0 plot-error-before-prune.csv
truncate -s0 plot-error-after-prune.csv
truncate -s0 plot-size-before-prune.csv
truncate -s0 plot-size-after-prune.csv

for test in a b; do
	gen_test "$test" "10000"
	for size in 100 200 300 500 1000 5000; do
		for nr in $(seq 1 20); do
			run_test "$test" "ej-5-$test-data-$size-$nr" "$size"
		done
	done
done

gen_plot "error" "plot-error-before-prune" "previo a pruning"
gen_plot "error" "plot-error-after-prune"  "luego de pruning"
gen_plot "size"  "plot-size-before-prune"  "previo a pruning"
gen_plot "size"  "plot-size-after-prune"   "luego de pruning"

clean_test
