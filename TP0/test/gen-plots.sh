#!/bin/sh

if [ $# -ne 2 ]; then
	echo "Usage: $0 [TP0 binary] [output dir]"
	exit 1
fi

TP0=$(readlink -f $1)
DATADIR=$PWD
WORKDIR=$2

if [ ! -f "$TP0" ]; then
	echo "TP0 binary does not exist!" >&2
	exit 1
fi

gen_plot () {
	EX=$1
	NAME=$2
	PARAM=$3
	PLOT=$4
	CHECK=$5
	$TP0 -e "$EX" -o "$NAME" -p "$PARAM"
	if [ "$PLOT" != "" ]; then
		(printf 'name="%s"\nparams="%s"\nex="%s"\n' "$NAME" "$PARAM" "$EX"; cat "$DATADIR/$PLOT.r") | R --vanilla >/dev/null
		mv Rplots.pdf "$NAME.pdf"
	fi
	if [ "$CHECK" != "" ]; then
		(printf 'name="%s"\nparams="%s"\nex="%s"\n' "$NAME" "$PARAM" "$EX"; cat "$DATADIR/$CHECK.r") | R --vanilla > "$NAME.check"
	fi
}

mkdir -p "$WORKDIR"
cd "$WORKDIR"

gen_plot "a" "ej-a-data-1" "2 200 0.75"    "plot-ab" "check-ab"
gen_plot "a" "ej-a-data-2" "4 2000 0.75"   ""        "check-ab2"
gen_plot "a" "ej-a-data-3" "2 20000 0.75"  "plot-ab" "check-ab"
gen_plot "b" "ej-b-data-1" "2 200 0.75"    "plot-ab" "check-ab"
gen_plot "b" "ej-b-data-2" "4 2000 0.75"   ""        "check-ab2"
gen_plot "b" "ej-b-data-3" "2 20000 0.75"  "plot-ab" "check-ab"
gen_plot "c" "ej-c-data-1" "5000"          "plot-c"
gen_plot "c" "ej-c-data-2" "15000"         "plot-c"
