#!/bin/bash

DATAFILE=
TABLENAME=
INHEADERS=-
COLHEADS=

function printhelp {
cat <<EOHELP
Create MySQL-compatible insertion queries from CSV file

OPTIONS

	-d FILE
	Specify the CSV data file

	-t TABLENAME
	Specify the table name to insert to

	-h FILE
	Specify a file of comma-separated header names from the CSV
	Any run of characters that are neither alphanumeric or the underscore "_" character
	 must be replaced with a single underscore character.
	 So if the header in CSV is "Month (short)", the name in this file should be
	 "Month_short_"
	By default, use all columns
	
	-c FILE
	Specify a file of comma-separated names of MySQL columns to insert to.
	 Needs to be the same number of columns as in the CSV headers specified by -h
	By default, use the same names as -h
	
EOHELP
}

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
	--help)
		printhelp
		exit 0
		;;
	*)
		echo "[131mI do not understand [1;34m$ARG[0m" 1>&2
		;;
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

