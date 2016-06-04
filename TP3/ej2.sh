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
	echo "NVB binary does not exist!" >&2
	exit 1
fi

source "$DATADIR/../TP2/utils.sh"

mkdir -p "$WORKDIR"
cd "$WORKDIR"

get_data 'https://sites.google.com/site/aprendizajeautomatizadounr/Inicio/datasets/dos_elipses.zip?attredirects=0&d=1'

head -n 500 "dos_elipses.data" > "dos_elipses.tdata"
$NVB "dos_elipses.tdata" "dos_elipses.test" "dos_elipses.predict" > "dos_elipses.report"

head -n 1600 "espirales.data" > "espirales.tdata"
$NVB "espirales.tdata" "espirales.test" "espirales.predict" > "espirales.report"

Rscript "$DATADIR/plot-ej2.r"
mv Rplots.pdf points-plot.pdf
