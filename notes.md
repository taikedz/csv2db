# Notes for implementation ideas

## Multi-table creation

Probably a deployment file with contents similar to:

    #define table/headers to use/columns to index
    Table1/Header_1,Header_2,Header_3/Header_3
    Table2/Header_3,Header_4,Header_5/Header_3

Add support to existing scripts to recognize these lines

* `createdb` need to know all 3 info
* `querify` only needs to know the first two
