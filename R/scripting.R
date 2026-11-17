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
#' @param schema schema name, defaults to "platform"
#'
#' @return data frame with original columns and added table and series code fields.
#' @export
parse_structure <- function(df, con, schema = "platform") {
  check_structure_df(df, con, schema)
  df_split <- split_structure(df)
  if(nrow(df_split$df_new) > 0){
  df_split$df_new <- compute_table_codes(df_split$df_new, con, schema)
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
#' @param keep_vintage boolean - whether or not to keep old vintages
#'
#' @return vector of inserted rows
#' @export
prep_and_import_structure <- function(df, con, schema = "platform",
                                      keep_vintage = FALSE) {
  x <- insert_new_table(df, con, schema, keep_vintage)
  x <- c(x, insert_new_category_table(df, con, schema))
  x <- c(x, insert_new_table_dimensions(df, con, schema))
  x <- c(x, insert_new_dimension_levels(df, con, schema))
  x <- c(x, insert_new_series(df, con, schema))
  x <- c(x, insert_new_series_levels(df, con, schema))
  base::message("Zapisovanje metapodatkov v bazo je kon\u010dano.")
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
#' @param keep_vintage logical value whether or not to keep old vintages
#'
#' @return if the whole thing goes through without a hitch, returns a character
#' vector of series codes, otherwise an error will be thrown.
#' @export

main_structure <- function(filename, con, schema = "platform", keep_vintage = FALSE) {

  df <- openxlsx::read.xlsx(filename, sheet = "timeseries")
  df_split <- parse_structure(df, con, schema)
  if(nrow(df_split$df_new) > 0){
  prep_and_import_structure(df_split$df_new, con, schema, keep_vintage)}
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
               base::message(cond)}
    )
    tryCatch({create_data_template_excel(path, initials, overwrite)},
             error=function(cond) {
               base::message(cond)}
    )
    add_author_folder(initials, path, con, schema)
    insert_new_category(name, con, schema)
    insert_new_category_relationship(name, con, schema)
    base::message(name, " je dodan(a) med avtorje.")
    base::message("Zdaj pa ji/mu uredi pravice na mapi!")
    TRUE} else {
      base::message("Avtor ni bil zapisan, preveri inicijalke.")
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
#' @return number of imported data points (0 if all sheets are empty)
#' @export
#'
main_data <- function(filename, codes, con, schema) {
  check_data_xlsx(filename, codes)
  sheets <- intersect(c("M", "A", "Q", "D"), openxlsx::getSheetNames(filename))
  imported_rows <- sum(vapply(sheets, \(sheet) {
    base::message("\nZavihek ", sheet, ":")
    df <- suppressWarnings(openxlsx::read.xlsx(filename, sheet = sheet))
    if (is.null(df)) {
      base::message("Na zavihku ni podatkov")
      return(0)
    }
    import_data_df(df, sheet, codes, con, schema, checked = TRUE)
  }, numeric(1)))
  base::message("\nPodatki iz ", basename(filename), " so prene\u0161eni v bazo.\n-----------------------")
  imported_rows
}


#' Import a single wide data frame of one interval
#'
#' Same format as one data sheet: a `period` column first, then one column per
#' series code. Lets data that is already in R (e.g. scripted pulls) skip the
#' Excel round trip.
#'
#' @param df data frame with `period` and series-code columns
#' @param interval one of "M", "Q", "A", "D"
#' @param codes legal series codes
#' @param con connection to database
#' @param schema schema name
#' @param checked logical, skip \link[UMARfetchR]{check_data_df} if already done
#'
#' @return number of inserted data points
#' @export
import_data_df <- function(df, interval, codes, con, schema = "platform", checked = FALSE) {
  if (!checked && check_data_df(df, codes) != interval)
    stop("Serije v tabeli niso z intervalom ", interval)
  df <- prepare_periods(df, interval)
  insert_new_vintage(df, con, schema)
  n <- insert_data_points(df, con, schema)
  if (is.null(n)) 0 else as.numeric(n)
}


#' Send email with log
#'
#' Convenience wrapper for sending the log to a (bunch of) recipient(s). This fun is
#' based on the ddvR::email_log function, just fyi. Cannae be bothered writing tests for this.
#'
#' @param log path to log file
#' @param recipient email (not checked) address to be sent to as BCC.
#' I think single email is all that's allowed. Haven't tried more.
#' @param initials initials of the author
#' @param meta logical indicating if the script was the metadata one or the data one (default).
#' This affects the subject and text of the email.
#'
#' @return nothing, side effect is the email being sent.
#' @export
#'
email_log <- function(log, recipient, initials, meta = FALSE) {
  if (meta) {
    subject <- paste0("UMAR baza - uvoz metapodatkov - ", initials)
    body <- paste0("To je avtomatsko sporo\u010dilo. <br><br>",
                   "V priponki je log uvoza metapodatkov v bazo <code>platform</code> na ",
                   "stre\u017eniku <code>umar-bi</code><br><br>",
                   "Tvoj Umar Data Bot &#129302;")
  } else {
    subject <- paste0("UMAR baza - uvoz podatkov - ", initials)
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
#' @param keep_vintage logical value whether or not to keep vintage data
#'
#' @return Nothing, just side effects :). Writes to the database and the excel file and emails logs.
#' @export
#'
update_metadata <- function(filename, con, schema, path = "logs/", keep_vintage = FALSE) {
  log <- paste0(path, "log_metadata_", format(Sys.time(), "%d-%b-%Y %H.%M.%S"), ".txt")

  # Create an open connection to the log file
  con_log <- file(log, open = "wt", encoding = "UTF-8")

  # Start capturing messages first, then output
  sink(con_log, type="message")
  sink(con_log, type="output")

  # Use tryCatch to capture warnings and errors
  result <- tryCatch({
    initials <- sub(".*_(.*)\\.xlsx", "\\1", filename)
    base::message("Mapa ", initials, ":\n-----------------------")
    base::message("Uvoz metapodatkov:\n----------------------- \n")
    email <- UMARaccessR::sql_get_email_from_author_initials(initials, con, schema)
    codes <- main_structure(filename, con, schema, keep_vintage)
    base::message("Kode za tvoje serije so zapisane v Excelu, sicer pa ima\u0161 trenutno v bazi metapodatke za naslednje serije:\n",
            paste(codes, collapse = "\n"))

  }, warning = function(w) {
    base::message("Captured warning: ", conditionMessage(w))
    return(NULL)  # or some other sentinel value
  }, error = function(e) {
    base::message("Captured error: ", conditionMessage(e))
    return(NULL)  # or some other sentinel value
  }, finally = {
    # Close the sinks and email them
    sink(type="output")
    sink(type="message")
    close(con_log)

    # Strip ISO 2022 escape sequences
    log_lines <- readLines(log, encoding = "UTF-8", warn = FALSE)
    log_clean <- gsub("\033[Gg][0-9]*;?", "", log_lines)  # Removes \033G3; and \033g
    log_clean <- log_clean[nzchar(log_clean) | seq_along(log_clean) == 1]  # Keep empty first line only
    writeLines(log_clean, log, useBytes = FALSE)

    email_log(log, recipient = "maja.zaloznik@gmail.com", initials, meta = TRUE)
    email_log(log, recipient = email, initials, meta = TRUE)
  })
}


#' Import one author's data file into the database
#'
#' Reads the series codes from the metadata file and imports any new data from
#' the data file with \link[UMARfetchR]{main_data}. Everything is written to a
#' per-file log (in Slovenian, meant for the author) and also passes through
#' as normal messages, warnings and errors, so the calling runner logs them too.
#' Warnings do not stop the import. Errors are logged and re-raised.
#'
#' No emails are sent: the return value has what the caller needs to route
#' the log to the author.
#'
#' @param metadata_filename path to the `umar_serije_metadata_XY.xlsx` file
#' @param data_filename path to the matching `umar_serije_podatki_XY.xlsx` file
#' @param con connection to database
#' @param schema schema name
#' @param path folder for the log file
#'
#' @return list with `initials`, `rows` (number of imported data points),
#'   `log_file`, `email` (author's email, NA if unknown) and `codes`.
#' @export
update_data <- function(metadata_filename, data_filename, con, schema, path = "logs") {
  initials <- sub(".*_(.*)\\.xlsx$", "\\1", basename(metadata_filename))
  data_initials <- sub(".*_(.*)\\.xlsx$", "\\1", basename(data_filename))
  if (data_initials != initials)
    stop("Metadata and data files are for different initials: ",
         initials, " vs ", data_initials, call. = FALSE)

  dir.create(path, showWarnings = FALSE, recursive = TRUE)
  log_file <- file.path(path, sprintf("log_data_%s_%s.txt", initials,
                                      format(Sys.time(), "%Y-%m-%d_%H.%M.%S")))
  log_con <- file(log_file, open = "wt", encoding = "UTF-8")
  on.exit(close(log_con))
  sink(log_con, split = TRUE)                      # printed output: file + console
  on.exit(sink(), add = TRUE, after = FALSE)       # unsink before closing

  write_log <- function(...) {
    writeLines(gsub("\033[Gg][0-9]*;?", "", paste0(...)), log_con)
    flush(log_con)
  }

  email <- tryCatch(
    suppressWarnings(UMARaccessR::sql_get_email_from_author_initials(initials, con, schema)),
    error = function(e) NA_character_)

  codes <- NULL
  rows <- withCallingHandlers({
    message("Mapa ", initials, ":\n-----------------------")
    message("Uvoz podatkov:\n-----------------------")
    codes <- read_codes_from_metadata_excel(metadata_filename)
    main_data(data_filename, codes, con, schema)
  },
  message = function(m) write_log(sub("\n$", "", conditionMessage(m))),
  warning = function(w) write_log("Opozorilo: ", conditionMessage(w)),
  error   = function(e) write_log("Napaka: ", conditionMessage(e)))

  list(initials = initials, rows = rows, log_file = log_file,
       email = email, codes = codes)
}
