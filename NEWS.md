# UMARfetchR 0.7.0

changes in update_data()

* Warnings no longer stop an import. They go into the author’s log and carry on to with_run, which records them.
* Errors are written to the author’s log and then raised again, so run_step() reports them as an issue for that file.
* Messages reach both places. The old version used sink(type = "message"), so everything went only to the author’s log file. Now each message goes to that file and to stderr, which the .bat captures. The output sink uses split = TRUE for the same reason.
* It sends no emails. It returns what the runner needs to send them instead.
* Clearer log names. Log files now include the initials, log_data_<XY>_<timestamp>.txt, and file.path() builds the path, so a missing trailing slash no longer breaks it.
* Mismatched files are caught. If the metadata and data files belong to different initials, it raises an error. 

# UMARfetchR 0.6.0

* add daily (`D`) interval: structure check, `D` data sheet, ISO-date periods (YYYY-MM-DD)
* `prepare_periods()` now takes the interval explicitly instead of guessing it from the months
* `get_interval_from_period()` vectorised; dropped `rowwise()` in `insert_data_points()`
* new exported `import_data_df()` to import a wide data frame without the Excel round trip
* sheet loops in `main_data()`/`check_data_xlsx()` deduplicated

# UMARfetchR 0.5.0

* add logging to insert functions
* add function to write data back to excel
* add umbrella function `main_structure` for parsing and & inserting data and writing to Excel
* add insert author setup with umbrella funciton `add_new_author`
* add vignette with workflow overview

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
