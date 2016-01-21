#!/usr/bin/python

import os,csv,sys,copy,re

# =============================
# Configure your variables here
# =============================

walloppairs = [
	("\t","%22"),
	(r"\r\n|\n|\r",";"),
	("\"","%09")
]

# =============================

arglist = copy.copy(sys.argv[1:])
csvfname=''
headers=[]
outsep='\t'
debm=False # debug mode
wallop=False
donotexecute=False

def printhelp():
	print """
Print the contents of a CSV with new separator strings, specifying headers

OPTIONS

-f FILE
	The CSV file to process

-s SEPSTRING
	The separator string to use
	Default is a tab character

-h HEADSFILE
	Specify a file with headers to be used
	File can contain several headers, separated by newlines or commas
	If the HEADSFILE is equal to "-" (single dash) then the first line of
	  the CSV will be used instead, printing all the columns
	Default is empty.

-w|--wallop
	Perform sanitization
	Current substitution pairs: %s
	Edit this script and configure the "walloppairs" to change
""" % (walloppairs,)

while len(arglist) > 0:
	myarg = arglist.pop(0)
	if myarg == "-f" and len(arglist) > 0:
		csvfname=arglist.pop(0)
	elif myarg == "-s" and len(arglist) > 0:
		outsep=arglist.pop(0)
	elif myarg == "-h" and len(arglist) > 0:
		arg=arglist.pop(0)
		if arg == "-": # use the data file
			fh=open(csvfname,'r')
			thelines=[fh.readline()] # only use the first line
		else:
			fh=open(arg,'r') # use the argument as a file
			thelines=fh.readlines()

		for hline in thelines:
			hline=re.sub(r'\r\n|\n|\r|"','',hline);
			headers += hline.split(",")
	elif myarg == "--help":
		printhelp()
		exit(0)
	elif myarg == "--debug":
		debm=True
	elif myarg == "--wallop" or myarg == "-w":
		wallop=True
	elif myarg == "--dne":
		donotexecute=True
	elif myarg[0] == '-' and len(arglist) < 1:
		print "Not enough arguments to",myarg
	else:
		headers.append(myarg)

if debm: print "csvfname: %s // outsep: %s" % (csvfname,outsep)
if debm: print "headers",headers

def dowallop(artefact):
	for (orgp,repp) in walloppairs:
		artefact=re.sub( orgp,repp, artefact)
	return artefact

if donotexecute:
	exit(0)

if not os.path.isfile(csvfname):
	print "[1;31mNot a file [",csvfname,"][0m\nPlease specify a file name with the -f option"
	exit(1)

with open(csvfname,'r') as csvfile:
	reader = csv.DictReader(csvfile)
	for row in reader:
		#print str(row.values() )
		rowitems= []
		for header in headers:
			artefact=row[header]
			if wallop:
				artefact=dowallop(artefact)
			rowitems.append(artefact)
		print outsep.join(rowitems)

