# csv2db

Take a CSV file and load it to a database!

If you need an easy way to take a single CSV file and load it to MySQL as a single database table, this tool will do it for you. You can then use that database table to do analysis that SQL querying was better suited for.

This version has a script to create a database table out of your CSV file, and a script to convert CSV to MySQL/MariaDB "INSERT" statements.

## Installation

Copy the scripts in `bin/` to `/usr/local/bin`, or add the `bin/` directory to your `PATH`

## Dependencies

This tool requires merely `bash` and the standard python CSV libraries.

## Usage

You basically need these two commands:

	createdb -h myfile.csv -t TableName
	querify.sh -d myfile.csv -t TableName

## The Scripts

* `createdb` takes the headers from a CSV file and creates an appropriate table structure for it.
	* Additional options allow you to specify varchar lengths depending on pattern names of headers
	* as well as define which headers need an index added to them.
* `querify` takes your CSV file, and creates a SQL script of `INSERT` statements to load the CSV to MysQL/MariaDB
* `csvreader.py` is a script to convert the separators into alternative separator strings
	* to remove confusion in nested comma values for easier processing.
	* You should not need to use it directly, but it's there if you need it

## Contributing

Please do.

Really it would be nice to also be able to separate a single CSV into multiple tables and define external keys automatically. I haven't cracked that yet.
