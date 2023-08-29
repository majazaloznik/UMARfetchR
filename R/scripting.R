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
  if (nrow(df_split$df_old) == 0) {
    final_df <- df_split$df_new
  } else {
    final_df <- dplyr::bind_rows(df_split$df_old, df_split$df_new)
  }
  update_structure_excel(filename, final_df)
  final_df$series_code
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
                           data_location = "O:/Avtomatizacija/umar-data",
                           overwrite = FALSE){
  x <- insert_new_author(name, initials, email, folder = NA, con, schema)
  if (x == 1) {
    path <- file.path(data_location, initials)
    dir.create(file.path(path), showWarnings = FALSE)
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
    TRUE} else {
      message("Avtor ni bil zapisan, preveri inicijalke.")
      FALSE
    }
}



#' Main function for processing data
#'
#' inputs the excel file with the timeseries data plus a vector of the allowed codes and
#' imports them into the database.
#'
#' @param filename path to excel file with timeseries data
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
    message("\nZavihek M:")
    df <- suppressWarnings( openxlsx::read.xlsx(filename, sheet = "M"))
    if (!is.null(df)){
      insert_new_vintage(df, con, schema)
      insert_data_points(df, con, schema)} else {
        message("Na zavihku ni podatkov")}
  }
  if("A" %in% sheet_names) {
    message("\nZavihek A:")
    df <- suppressWarnings(openxlsx::read.xlsx(filename, sheet = "A"))
    if (!is.null(df)){
      insert_new_vintage(df, con, schema)
      insert_data_points(df, con, schema)} else {
        message("Na zavihku ni podatkov")}
  }
  if("Q" %in% sheet_names) {
    message("\nZavihek Q:")
    df <- suppressWarnings(openxlsx::read.xlsx(filename, sheet = "Q"))
    if (!is.null(df)){
      insert_new_vintage(df, con, schema)
      insert_data_points(df, con, schema)} else {
        message("Na zavihku ni podatkov")}
  }
  message("\nPodatki iz ", basename(filename), " so prene\u0161eni v bazo.\n-----------------------")
}


#' Send email with log
#'
#' Convenience wrapper for sending the log to a (bunch of) recipient(s). This fun is
#' based on the ddvR::email_log function, just fyi. Cannae be bothered writing tests for this.
#'
#' @param log path to log file
#' @param recipient email (not checked) address to be sent to as BCC.
#' I think single email is all that's allowed. Haven't tried more.
#' @param meta logical indicating if the script was the metadata one or the data one (default).
#' This affects the subject and text of the email.
#'
#' @return nothing, side effect is the email being sent.
#' @export
#'
email_log <- function(log, recipient, meta = FALSE) {
  if (meta) {
    subject <- "UMAR baza - uvoz metapodatkov"
    body <- paste0("To je avtomatsko sporo\u010dilo. <br><br>",
                   "V priponki je log uvoza metapodatkov v bazo <code>platform</code> na ",
                   "stre\u017eniku <code>umar-bi</code><br><br>",
                   "Tvoj Umar Data Bot &#129302;")
  } else {
    subject <- "UMAR baza - uvoz podatkov"
    body <- paste0("To je avtomatsko sporo\u010dilo. <br><br>",
                   "V priponki je log uvoza podatkov v bazo <code>platform</code> na ",
                   "stre\u017eniku <code>umar-bi</code><br><br>",
                   "Tvoj Umar Data Bot &#129302;")
  }


  text_msg <- gmailr::gm_mime() %>%
    gmailr::gm_bcc(recipient) %>%
    gmailr::gm_subject(subject) %>%
    gmailr::gm_html_body(body) %>%
    gmailr::gm_attach_file(log)

  gmailr::gm_send_message(text_msg)
}



#' Wrapper function for complete metadata pipeline
#'
#' This wrapper function runs the whole pipeline in the \link[UMARfetchR]{main_structure}, while
#' logging everything to the sink and emailing the logs to the listed recipients
#'
#' @param filename location of metadata file
#' @param con connection to database
#' @param schema name of database schema
#' @param path folder to store the log file to
#'
#' @return Nothing, just side effects :). Writes to the database and the excel file and emails logs.
#' @export
#'
update_metadata <- function(filename, con, schema, path = "logs/") {

  log <- paste0(path, "log_metadata_", format(Sys.time(), "%d-%b-%Y %H.%M.%S"), ".txt")

  # Create an open connection to the log file
  con_log <- file(log, open = "wt", encoding = "UTF-8")

  # Start capturing messages first, then output
  sink(con_log, type="message")
  sink(con_log, type="output")

  # Use tryCatch to capture warnings and errors
  result <- tryCatch({
    initials <- sub(".*_(.*)\\.xlsx", "\\1", filename)
    message("Mapa ", initials, ":\n----------------------- \n")
    message("Uvoz metapodatkov:\n----------------------- \n")
    email <- UMARaccessR::get_email_from_author_initials(initials, con)
    codes <- main_structure(filename, con, schema)
    message("Kode za tvoje serije so zapisane v Excelu, sicer pa ima\u0161 trenutno v bazi metapodatke za naslednje serije:\n",
            paste(codes, collapse = "\n"))
    codes
  }, warning = function(w) {
    message("Captured warning: ", conditionMessage(w))
    return(NULL)  # or some other sentinel value
  }, error = function(e) {
    message("Captured error: ", conditionMessage(e))
    return(NULL)  # or some other sentinel value
  }, finally = {
    # Close the sinks
    sink(type="output")
    sink(type="message")
    close(con_log)  # Close the file connection
  })

  email_log(log, recipient = "maja.zaloznik@gmail.com", meta = TRUE)
  email_log(log, recipient = email, meta = TRUE)
  return(result)
}



#' Wrapper function for complete data pipeline
#'
#' This wrapper function runs the whole data pipeline by running \link[UMARfetchR]{main_data}
#' one which imports any new data, while logging everything to the sink and emailing the
#' logs to the listed recipients.
#'
#' @param metadata_filename metadata file
#' @param data_filename data file
#' @param con connection to database
#' @param schema name of database schema
#' @param path folder to store the log file to
#'
#' @return Nothing, just side effects :). Writes to the database and the excel file and emails logs.
#' @export
#'
update_data <- function(metadata_filename, data_filename, con, schema, path = "logs/") {

  log <- paste0(path, "log_data_", format(Sys.time(), "%d-%b-%Y %H.%M.%S"), ".txt")

  # Create an open connection to the log file
  con_log <- file(log, open = "wt", encoding = "UTF-8")

  # Start capturing messages first, then output
  sink(con_log, type="message")
  sink(con_log, type="output")

  # Use tryCatch to capture warnings and errors
  result <- tryCatch({
    initials <- sub(".*_(.*)\\.xlsx", "\\1", meta_filename)
    email <- UMARaccessR::get_email_from_author_initials(initials, con)
    codes <- read_codes_from_metadata_excel(metadata_filename)
    message("Mapa ", initials, ":\n----------------------- \n")
    message("Uvoz podatkov:\n-----------------------")

    main_data(data_filename, codes, con, schema)

  }, warning = function(w) {
    message("Captured warning: ", conditionMessage(w))
    return(NULL)
  }, error = function(e) {
    message("Captured error: ", conditionMessage(e))
    return(NULL)
  }, finally = {

    # Close the sinks
    sink(type="output")
    sink(type="message")
    close(con_log)  # Close the file connection

  })

  email_log(log, recipient = "maja.zaloznik@gmail.com")
  email_log(log, recipient = email)
  return(result)
}
