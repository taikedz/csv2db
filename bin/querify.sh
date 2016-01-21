#!/bin/bash

DATAFILE=
TABLENAME=

while [[ -n "$@" ]]; do
	ARG=$1
	shift
	if [[ -n "$@" ]]; then
		case "$ARG" in
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

heads=$(bin/createdb -h "$DATAFILE" --printcols|xargs echo|sed 's/ /,/g')

bin/csvreader.py -f "$DATAFILE" -h - -w | sed -r -e 's/\t/","/g' -e 's/^|$/"/g'|sed -r -e "s/^/INSERT INTO $TABLENAME ($heads) VALUES (/" -e 's/$/ );/' -e 's|([0-9]{2})/([0-9]{2})/([0-9]{4})|\3/\2/\1|g'

