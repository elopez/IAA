#!/bin/sh

if [ $# -ne 2 ]; then
	echo "Usage: $0 [c4.5 binary] [output dir]"
	exit 1
fi

C45=$(readlink -f $1)
DATADIR=$PWD
WORKDIR=$2

if [ ! -f "$C45" ]; then
	echo "TP0 binary does not exist!" >&2
	exit 1
fi

get_data () {
	URL=$1
	wget -q -O tmp.zip "$URL"
	unzip tmp.zip >/dev/null
	rm tmp.zip
}

plot_data () {
	NAME=$1
	cat "$DATADIR/plot-ej8.r" | R --vanilla >/dev/null
	mv Rplots.pdf "$NAME.pdf"
}

run_c45 () {
	NAME=$1
	$C45 -f "$NAME" > "$NAME.report"
}

clean_data () {
	rm xor.data xor.names
}

mkdir -p "$WORKDIR"
cd "$WORKDIR"

get_data 'https://sites.google.com/site/aprendizajeautomatizadounr/Inicio/datasets/xor.zip?attredirects=0&d=1'
run_c45 "xor"
plot_data "xor"
clean_data
