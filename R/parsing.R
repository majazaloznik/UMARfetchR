#' Check structure data to be parsed
#'
#' This function checks if the input data that is read from an excel file is
#' in the proper format to be parsed by the parser functions and gives informative
#' errors if not.
#'
#' @param df dataframe from one of the structure worksheets
#'
#' @return TRUE if passes all checks
#' @export
#' @importFrom stats complete.cases
check_structure_df <- function(df) {

  # Check the column names
  col_names <- c("source", "author", "table_name", "dimensions", "dimension_levels_text",
                 "dimension_levels_code", "unit")
  if (!all(col_names %in% names(df))) {
    stop("Nekaj je narobe z imeni stolpcev. Pri\u010dakovani so vsaj naslednji: ",
         paste(col_names, collapse = ", "))
  }

  # check single author
  if (length(unique(df$author)) != 1) {
    stop("V tabeli so dovoljene samo serije enega avtorja. Mogo\u010de si se zatipkal/a? Vne\u0161eno ima\u0161: ",
         paste(unique(df$author), collapse = ", "))
  }

  # Check intervals are all legal
  intervals <- c("M", "Q", "A")
  if (!all(unique(df$interval) %in% intervals)) {
    stop("Nekaj je narobe z vrednostimi v polju interval, dovoljene so samo naslednje vrednosti: ",
         paste(intervals, collapse = ", "))
  }

  # check one interval per table
  df |>
    dplyr::arrange(table_name) |>
    dplyr::group_by(table_name) |>
    dplyr::summarize(all_same_interval = dplyr::n_distinct(interval) == 1, .groups = "drop") |>
    dplyr::filter(all_same_interval == FALSE) -> check
  if (nrow(check) > 0) {
    stop("Vse serije v eni tabli morajo imeti enak interval. To ni res tukaj: ",
         paste(check$table_name, collapse = ", "))
  }

  # check unique dimension level codes per table
  df |>
    dplyr::arrange(table_name) |>
    dplyr::group_by(table_name) |>
    dplyr::mutate(count = dplyr::n()) |>
    dplyr::summarise(check_unique = length(unique(dimension_levels_code)),
                     group_n = unique(count)) |>
    dplyr::mutate(duplicate_exists = ifelse(check_unique < group_n, TRUE, FALSE)) |>
    dplyr::filter(duplicate_exists) -> check
  if (nrow(check) > 0) {
    stop("Vse serije v eni tabli morajo unikaten dimension_levels_code. To ni res tukaj: ",
         paste(check$table_name, collapse = ", "))
  }


  #check incomplete rows
  rows_with_na <- which(!complete.cases(df[,1:7]))

  if (length(rows_with_na) > 0) {
    stop("V tabeli ima\u0161 nepopolne vrstice. Poglej naslednje vrstice: ",
         paste(rows_with_na, collapse = ", "))
  }

 TRUE
}


#' Prepare message describing structure process
#'
#' Prepares a log message describing how many new series will be imported
#' from each worksheet and how many are already there and will be ignored.
#'
#' @param filename path to excel file
#'
#' @return outputs log message
#' @export
#'
message_structure <- function(filename) {
  wb <- openxlsx::loadWorkbook(filename)
  sheet_names <- openxlsx::getSheetNames(filename)
  out <- data.frame(sheet = sheet_names, new = NA, old = NA)
  for (sheet in sheet_names){
    df <- openxlsx::readWorkbook(wb, sheet = sheet)
    df <- df %>%
      dplyr::mutate(non_na_count = rowSums(!is.na(.)))

    # Count the number of rows with 7 and 9 non-NA values
    new_rows <- sum(df$non_na_count == 9)
    old_rows <- sum(df$non_na_count == 11)

    if (new_rows > 0) {
      message(paste("Na zavihku", sheet, "je \u0161tevilo novih serij, ki bodo uvou\u017eene:", new_rows))
    }
    if (old_rows > 0) {
      message(paste("Na zavihku", sheet, "je \u0161tevilo starih serij, ki bodo ignorirane:", old_rows))
    }
    out[out$sheet == sheet, "new"] <- new_rows
    out[out$sheet == sheet, "old"] <- old_rows
  }
  out
}

#' Compute the table codes for new series
#'
#' Computes the new table codes for the tables of the series to be imported.
#' This uses the author field to create the code and checks which ones are
#' already in the database and increments from there.
#'
#' If the table already exists, need to cover this eventuality
#'
#' @param df dataframe from structure template
#' @param con connection to the database.
#'
#' @return dataframe with a complete table_code column
#' @export
#'
compute_table_codes <- function(df, con){
  auth <- toupper(unique(df$author))
  existing_codes <- length(unique(df$table_code)) - 1
  df <- df |>
    dplyr::arrange(table_code, table_name) |>
    dplyr::group_by(table_name) |>
    tidyr::fill(table_code, .direction = "downup")


  x <- DBI::dbGetQuery(con, sprintf("SELECT code
       FROM \"table\"
       WHERE code LIKE '%s%%'
       ORDER BY substring(code FROM '[0-9]+')::int DESC
       LIMIT 1;", auth))
  start <- ifelse(nrow(x) == 0, "000", sub("^[A-Za-z]*", "", x[1,1]))
  df <- df |>
    dplyr::arrange(table_code, table_name) |>
    dplyr::group_by(table_code,table_name) |>
    dplyr::mutate(gr =   ifelse(is.na(table_code), dplyr::cur_group_id() - existing_codes, 0),
                  table_code = ifelse(is.na(table_code),
                                      paste0(auth, sprintf("%03d",
                                                           as.integer(start) + gr)),
                                      table_code)) |>
    dplyr::select(-gr)
  df
}


#' Compute the series codes for the new series
#'
#' To be run after \link[UMARfetchR]{compute_table_codes} is already run so
#' all the series have a legit table code. Computes the series code, which will
#' be unique, because of the checks and how the table codes are computed.
#'
#' @param df a dataframe with the table code, dimension levels code, interval and
#'
#' @return df with a complete series_code column
#' @export
#'
compute_series_codes <- function(df) {
  if (!"series_code" %in% names(df)) {
    df$series_code <- NA
  }
  df |>
    dplyr::mutate(series_code = ifelse(is.na(series_code),
                                       paste("UMAR", table_code,
                                             toupper(dimension_levels_code),
                                             interval,
                                             sep = "--"), series_code))



}
