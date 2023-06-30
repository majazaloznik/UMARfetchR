# UMARfetchR 0.4.0

* Added prep and import functions for all the structural tables left: table, table_dimensions, dimension_levels, series and series_levels
* Added `compute_series_codes` function to fill that column.
* Added a bunch more checks.
* Allowed for external source being syphoned through the UMAR package. 

# UMARfetchR 0.3.0

* Rewrote structure checks to consilidate all worksheet into one, only `check_structure_df` is left.
* Added `compute_table_codes` function to fill that column.

# UMARfetchR 0.2.0

* Added function for preparing Excel template for the structure metadata
* Added `check_structure_wb` to check structure metadata file for integrity
* Added `message_structure` to give overview of import ahead of time.
* Added prepare and write  functions for new source, category and category_relationship rows.

# UMARfetchR 0.1.0.9000

* Added a `NEWS.md` file to track changes to the package.
* Prepared overall package framework.
