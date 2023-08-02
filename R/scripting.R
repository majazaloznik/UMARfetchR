#' Umbrella function for parsing metadata structural file
#'
#' Umbrella function that does the following: runs all the checks to see if the
#' input data is correctly prepared and returns meaningful errors if not. Then
#' announces the number of new series and old series that will be parsed. Then
#' computes the values for the table codes and the series codes and if necessary
#' also the series names.
#'
#' @param df dataframe with the structure data, which means at a minumum the columns
#' source, author, table_name, dimensions, dimension_levels_text, dimension_levels_code,
#' unit, and interval.
#' @param con connection to the database.
#'
#' @return data frame with original columns and added table and series code fields.
#' @export
parse_structure <- function(df, con){
  check_structure_df(df, con)
  df_split <- split_structure(df)
  if(nrow(df_split$df_new) > 0){
  df_split$df_new <- compute_table_codes(df_split$df_new, con)
  df_split$df_new <- compute_series_codes(df_split$df_new)
  df_split$df_new <- compute_series_names(df_split$df_new)}
  df_split
}


#' Umbrella function to prepare and import structure metadata
#'
#' Umbrella funciton that takes the structure metadata dataframe an author
#' prepares using the template created with \link[UMARfetchR]{create_structure_template_excel}
#' and the connection and schema and prepares and imports the following tables into
#' the database: `table`, `category_table`, `table_dimensions`, `dimension_levels`,
#' `series` and `series_levels`. Logs number of rows inserted into each table.
#'
#' @param df dataframe with the structure data, which means at a minumum the columns
#' source, author, table_name, dimensions, dimension_levels_text, dimension_levels_code,
#' unit, and interval.
#' @param con connection to the database.
#' @param schema schema name, defaults to "platform"
#'
#' @return vector of inserted rows
#' @export
prep_and_import_structure <- function(df, con, schema = "platform") {
  x <- insert_new_table(df, con, schema)
  x <- c(x, insert_new_category_table(df, con, schema))
  x <- c(x, insert_new_table_dimensions(df, con, schema))
  x <- c(x, insert_new_dimension_levels(df, con, schema))
  x <- c(x, insert_new_series(df, con, schema))
  x <- c(x, insert_new_series_levels(df, con, schema))
  message("Zapisovanje metapodatkov v bazo je kon\u010dano.")
  x
}


#' Main function for processing structure data
#'
#' This is the top level funciton to process the structre metadata from a
#' file an author prepares using the template created with
#' \link[UMARfetchR]{create_structure_template_excel}. This function:
#' * reads the structure metadata and checks the data
#' * computes the columns that are missing
#' * inserts the data into the database
#' * updates the original excel file.
#'
#' @param filename path to excel file with timeseries structure metadata
#' @param con connection to database
#' @param schema schema name
#'
#' @return if the whole thing goes through without a hitch, returns a character
#' vector of series codes, otherwise an error will be thrown.
#' @export

main_structure <- function(filename, con, schema) {

  df <- openxlsx::read.xlsx(filename, sheet = "timeseries")
  df_split <- parse_structure(df, con)
  if(nrow(df_split$df_new) > 0){
  prep_and_import_structure(df_split$df_new, con, schema)}
  df <- dplyr::bind_rows(df_split$df_old, df_split$df_new)
  update_structure_excel(filename, df)
  df$series_code
}



#' Main function for adding a new author
#'
#' This function inserts the author into the database - checking if the initials are
#' unique, otherwise you'll need to change them. Then creates the data folder for
#' that author and places the template excel file in there. And finally adds the
#' category and cat relationship rows for that author.
#'
#' @param name full name
#' @param initials initials, make them unique if already exist
#' @param email email
#' @param con connection to the database
#' @param schema schema name. defaults to "platform"
#' @param data_location location where data folders live. defaults to "O://Avtomatizacija//umar-data"
#' @param overwrite logical value whether or not to overwrite existing files. defaults to FALSE
#'
#' @return true if completes, otherwise error message
#' @export

add_new_author <- function(name, initials, email, con, schema = "platform",
                             data_location = "O://Avtomatizacija//umar-data",
                           overwrite = FALSE){
  insert_new_author(name, initials, email, folder = NA, con, schema)
  dir.create(file.path(data_location, initials), showWarnings = FALSE)
  path <- file.path(data_location, initials)
  tryCatch({create_structure_template_excel(path, initials, overwrite)},
           error=function(cond) {
             message(cond)}
  )
  tryCatch({create_data_template_excel(path, initials, overwrite)},
           error=function(cond) {
             message(cond)}
  )
  add_author_folder(initials, path, con, schema)
  insert_new_category(name, con, schema)
  insert_new_category_relationship(name, con, schema)
  message(name, " je dodan(a) med avtorje.")
  message("Zdaj pa ji/mu uredi pravice na mapi!")
  TRUE
}



#' Main function for processing data
#'
#' @param filename path to excel file with timeseries structure metadata
#' @param codes output of \link[UMARfetchR]{main_structure} i.e. list of series codes
#' @param con connection to database
#' @param schema schema name
#'
#' @return nothing, just message
#' @export
#'
main_data <- function(filename, codes, con, schema) {
  check_data_xlsx(filename, codes)
  sheet_names <- openxlsx::getSheetNames(filename)
  if("M" %in% sheet_names) {
    df <- openxlsx::read.xlsx(filename, sheet = "M")
    message("Zavihek M:\n")
    insert_new_vintage(df, con, schema)
    insert_data_points(df, con, schema)
  }
  if("A" %in% sheet_names) {
    df <- openxlsx::read.xlsx(filename, sheet = "A")
    message("Zavihek A:\n")
    insert_new_vintage(df, con, schema)
    insert_data_points(df, con, schema)
  }
  if("Q" %in% sheet_names) {
    df <- openxlsx::read.xlsx(filename, sheet = "Q")
    message("Zavihek Q:\n")
    insert_new_vintage(df, con, schema)
    insert_data_points(df, con, schema)
  }
 message("Podatki iz ", basename(filename), " so prene\u0161eni v bazo.")
}
