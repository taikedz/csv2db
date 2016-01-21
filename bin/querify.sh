#!/bin/bash

DATAFILE=
TABLENAME=
INHEADERS=-
COLHEADS=

while [[ -n "$@" ]]; do
	ARG=$1
	shift
	if [[ -n "$@" ]]; then
		case "$ARG" in
		-h)
			INHEADERS=$1 # CSV file headers -- default all
			shift
			continue
			;;
		-c)
			COLHEADS=$1 # table dest columns -- default same as INHEADERS
			shift
			continue
			;;
		-t)
			TABLENAME=$1
			shift
			continue
			;;
		-d)
			DATAFILE=$1
			shift
			continue
			;;
		esac
	fi
	case "$ARG" in
	*)
		echo "[131mI do not understand [1;34m$ARG[0m" 1>&2
	esac
done


[[ -z "$DATAFILE" ]] && { echo "[1;31mNo data file \$1[0m" ; exit 1 ; }
[[ -z "$TABLENAME" ]] && { echo "[1;31mNo table name \$2[0m" ; exit 1 ; }

if [[ "$INHEADERS" = "-" ]]; then
	INHEADERS=$(createdb -h "$DATAFILE" --printcols|xargs echo|sed 's/ /,/g')
fi

if [[ -z "$COLHEADS" ]]; then
	COLHEADS="$INHEADERS"
else
	COLHEADS=$(createdb -h "$DATAFILE" --printcols|xargs echo|sed 's/ /,/g')
fi

csvreader.py -f "$DATAFILE" -h "$INHEADERS" -w | sed -r -e 's/\t/","/g' -e 's/^|$/"/g'|sed -r -e "s/^/INSERT INTO $TABLENAME ($COLHEADS) VALUES (/" -e 's/$/ );/' -e 's|([0-9]{2})/([0-9]{2})/([0-9]{4})|\3/\2/\1|g'

