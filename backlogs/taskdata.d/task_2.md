
  #2: Generate a schema file from CSV

The schema file takes the headers and assigns them shortnames

Using the short names, the user can then group the shortnames to define tables, as well as add foreign keys

Given CSV headers

	First name, Last name, Book, Price, Account Number

We can define their shortnames as

	!Firstname = First name
	!Lastname = Last name
	!Book = Book
	!Price = Price
	!AccountNumber = Account Number

We can arrange these as

	Buyers = Firstname, Lastname
	Books = Book, Price
	Accounts = AccountNumber, %Buyers
	Purchases = %Book, %Price

* Where preceded by `!`, an assignment indicates the definition of a shortname against a CSV header
* Otherwise the items before the `=` are table names
* The items starting with `%` can only be used on table names, and indicate a foreign key
* The rest are column names, and must be equivalent to shortnames


