#' Check structure data to be parsed
#'
#' This function checks if the input data that is read from an excel file is
#' in the proper format to be parsed by the parser functions and gives informative
#' errors if not.
#'
#' @param df dataframe with the structure data, which means at a minumum the columns
#' source, author, table_name, dimensions, dimension_levels_text, dimension_levels_code,
#' unit, and interval.
#'
#' @return TRUE if passes all checks
#' @param con connection to the database
#'
#' @export
#' @importFrom stats complete.cases
check_structure_df <- function(df, con) {

  # Check the column names
  col_names <- c("source", "author", "table_name", "dimensions", "dimension_levels_text",
                 "dimension_levels_code", "unit", "interval")
  if (!all(col_names %in% names(df))) {
    stop("Nekaj je narobe z imeni stolpcev. Pri\u010dakovani so vsaj naslednji: ",
         paste(col_names, collapse = ", "))
  }
  #check incomplete rows
  rows_with_na <- which(!complete.cases(df[,1:8]))

  if (length(rows_with_na) > 0) {
    stop("V tabeli ima\u0161 nepopolne vrstice. Poglej naslednje vrstice: ",
         paste(rows_with_na, collapse = ", "))
  }
  # check sources
  check <- grep("^(\\w+)(,\\s?\\w+)*$", df$source, invert = TRUE)
  if(length(check) > 0) {
    stop("V tabeli ima\u0161 neveljavne vrednosti v polju source. Poglej naslednje vrstice: ",
         paste(check, collapse = ", "))
  }

  # check one source is UMAR
  check <- grep(".*UMAR.*", toupper(df$source), invert = TRUE)
  if(length(check) > 0) {
    stop("V tabeli ti  v polju source manjka UMAR. Poglej naslednje vrstice: ",
         paste(check, collapse = ", "))
  }


  # check single author
  if (length(unique(df$author)) != 1) {
    stop("V tabeli so dovoljene samo serije enega avtorja. Mogo\u010de si se zatipkal/a? Vne\u0161eno ima\u0161: ",
         paste(unique(df$author), collapse = ", "))
  }
  # check author is in the database
  if (is.na(UMARaccessR::get_initials_from_author_name(unique(df$author), con))) {
    stop("Avtor \u0161e ni v bazi. Mogo\u010de si se zatipkal/a? Vne\u0161eno ima\u0161: ",
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

  # check same source per table
  df |>
    dplyr::arrange(table_name) |>
    dplyr::group_by(table_name) |>
    dplyr::summarize(all_same_source = dplyr::n_distinct(source) == 1, .groups = "drop") |>
    dplyr::filter(all_same_source == FALSE) -> check
  if (nrow(check) > 0) {
    stop("Vse serije v eni tabli morajo imeti enak source To ni res tukaj: ",
         paste(check$table_name, collapse = ", "))
  }


  # check dimensions are the same for each table
  df |>
    dplyr::arrange(table_name) |>
    dplyr::group_by(table_name) |>
    dplyr::summarize(all_same_dimz = dplyr::n_distinct(dimensions) == 1, .groups = "drop") |>
    dplyr::filter(all_same_dimz == FALSE) -> check
  if (nrow(check) > 0) {
    stop("Vse serije v eni tabli morajo imeti enake dimenzije. To ni res tukaj: ",
         paste(check$table_name, collapse = ", "))
  }

  # check dimension level codes are legal
  df |>
    dplyr::mutate(dimension_levels_code = toupper(dimension_levels_code),
                  check = grepl("^([A-Z0-9]{1,4})(--([A-Z0-9]{1,4}))*$", dimension_levels_code)) |>
    dplyr::filter(check ==FALSE) -> check
  if (nrow(check) > 0) {
    stop("Naslednje vrednosti dimension_levels_code polja so nedovoljene, preberi navodila: ",
         paste(check$dimension_levels_code, collapse = ", "))
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
  # check same number of dimensions and levels in each table
  count_occurrences <- function(x) {
    sapply(gregexpr("--", x), function(y) sum(y > 0))
  }
  df |>
    dplyr::arrange(table_name) |>
    dplyr::group_by(table_name) |>
    dplyr::mutate(count1 = count_occurrences(dimensions),
                  count2 = count_occurrences(dimension_levels_text),
                  count3 = count_occurrences(dimension_levels_code),
                  same_counts = (count1 == count2 & count2 == count3)) |>
    dplyr::filter(!same_counts) -> check
  if (nrow(check) > 0) {
    stop("Vse serije v eni tabli morajo imeti enako \u0161tevilo dimenzij in level-ov. To ni res tukaj: ",
         paste(check$table_name, collapse = ", "))
  }
  # check that dimension level codes and text are matching
  check <- df %>%
    dplyr::select(table_name, dimension_levels_code, dimension_levels_text)  %>%
    dplyr::mutate(row_number = seq_along(dimension_levels_code)) %>%
    tidyr::separate_rows(dimension_levels_code, dimension_levels_text, sep = "--") %>%
    dplyr::group_by(row_number) %>%
    dplyr::mutate(pos_number = seq_along(dimension_levels_code)) |>
    dplyr::group_by(table_name, row_number, pos_number) %>%
    dplyr::summarise(dimension_levels_text = dimension_levels_text,
                     dimension_levels_code = dimension_levels_code) |>
    dplyr::ungroup() |>
    dplyr::select(-row_number) |>
    dplyr::relocate(table_name, pos_number, dimension_levels_code, dimension_levels_text) |>
    dplyr::group_by(table_name,pos_number, dimension_levels_code) |>
    dplyr::summarise(distinct_text = dplyr::n_distinct(dimension_levels_text)) |>
    dplyr::mutate(check = distinct_text == 1) |>
    dplyr::filter(!check)

  if (nrow(check) > 0) {
    stop("Besedila in kode dimension level-ov niso ena:ena v naslednjih tabelah: ",
         paste(check$table_name, collapse = ", "))
  }

  # check series names are different in table
  df |>
    dplyr::arrange(table_name) |>
    dplyr::group_by(table_name) |>
    dplyr::mutate(count = dplyr::n()) |>
    dplyr::summarise(all_na = all(is.na(series_name)),
                     check_unique = length(unique(series_name)),
                     group_n = unique(count)) |>
    dplyr::mutate(check = ifelse(all_na, TRUE, check_unique == group_n)) |>
    dplyr::filter(!check) -> check

  if (nrow(check) > 0) {
    stop("V tabeli ne sme biti enako poimenovanih serij (series_name). Glej tabele: ",
         paste(check$table_name, collapse = ", "))
  }
  # check UMAR isn't the only source
  check <- grep("^\\W*UMAR\\W*$", toupper(df$source))
  if(length(check) > 0) {
    stop("V tabeli ima\u0161 kot vir samo UMAR, rabi\u0161 \u0161e originalen vir. Poglej naslednje vrstice: ",
         paste(check, collapse = ", "))
  }
  TRUE
}


#' Prepare message describing structure process
#'
#' Prepares a log message describing how many new series will be imported
#' from each worksheet and how many are already there and will be ignored.
#'
#' @param df dataframe from structure template
#'
#' @return a list with both the old and the new df
#' @export
#'
split_structure <- function(df) {

  df_old <- df %>%
    dplyr::filter(complete.cases(.))
  df_new <- df %>%
    dplyr::filter(!complete.cases(.))
  # Count the number of old and new
  old_rows <- nrow(df_old)
  new_rows <- nrow(df_new)

  if (new_rows > 0) {
    message(paste("V tabeli je \u0161tevilo novih serij, ki bodo uvou\u017eene:", new_rows))
  }
  if (old_rows > 0) {
    message(paste("V tabeli je \u0161tevilo starih serij, ki bodo ignorirane:", old_rows))
  }
  return(list("df_new" = df_new, "df_old" = df_old))
}

#' Compute the table codes for new series
#'
#' Computes the new table codes for the tables of the series to be imported.
#' This uses the author field to create the code and checks which ones are
#' already in the database and increments from there. Also first checks if a
#' table with the same name doesn't already exist for this table name.
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
  auth <- UMARaccessR::get_initials_from_author_name(unique(df$author), con)
  existing_codes <- length(unique(df$table_code)) - 1
  df <- df |>
    dplyr::arrange(table_code, table_name) |>
    dplyr::group_by(table_name) |>
    tidyr::fill(table_code, .direction = "downup") |>
    dplyr::rowwise() |>
    dplyr::mutate(table_code = ifelse(is.na(table_code),
                                      get_table_id_with_same_name(auth, table_name, con),
                                      table_code))
  x <- DBI::dbGetQuery(con, sprintf("SELECT code
       FROM \"table\"
       WHERE code LIKE '%s%%'
       ORDER BY substring(code FROM '[0-9]+')::int DESC
       LIMIT 1;", auth))
  start <- ifelse(nrow(x) == 0, "000", sub("^[A-Za-z]*", "", x[1,1]))
  df |>
    dplyr::arrange(table_code, table_name) |>
    dplyr::group_by(table_code,table_name) |>
    dplyr::mutate(gr =   ifelse(is.na(table_code), dplyr::cur_group_id() - existing_codes, 0),
                  table_code = ifelse(is.na(table_code),
                                      paste0(auth, sprintf("%03d",
                                                           as.integer(start) + gr)),
                                      table_code)) |>
    dplyr::select(-gr) |>
    dplyr::ungroup()

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
                                       paste(gsub(",\\s+", "-", toupper(source)),
                                             table_code,
                                                    toupper(dimension_levels_code),
                                                    interval,
                                                    sep = "--"),
                                       series_code))
}

#' Compute the series codes for the new series
#'
#' This isn't really a compute funciton, because it just copies the values, but
#' kinda fits with the other funcitons to name it this way. Anyway, in case there
#' are no series name values, this funciton copies the ones from the
#' dimension_levels_text field.
#'
#' @param df a dataframe with dimension_levels_text
#'
#' @return df with a complete series_code column
#' @export
#'
compute_series_names <- function(df) {
  df |>
    dplyr::mutate(series_name = ifelse(is.na(series_name),
                                       dimension_levels_text, series_name))
}


#' Check data frame to be parsed
#'
#' Uses the output of \link[UMARfetchR]{main_structure} to get the list
#' of legal series codes and also checks a bunch of other stuff.
#'
#' @param df data with time series data
#' @param codes character vector of codes
#'
#' @return TRUE if it works
#' @export
#'
check_data_df <- function(df, codes){
  colnames(df) <- trimws(colnames(df))
  # Check the column names
  if (!("period" %in% names(df))) {
    stop("Manjka ti stolpec 'period'!")
  }
  if(sum(names(df) == "period") != 1){
    stop("Samo en period stolpec ima\u0161 lahko na zavihku!")
  }
  # check no missing periods
  if(any(is.na(df$period))){
    stop("V stolpcu period ne sme biti praznih polj!")
  }

  # check unique periods
  if(any(duplicated(df$period))){
    stop("V stolpcu period se obdobja ne smejo ponavljati")
  }
  # check all series are same interval
  intervals <- substring(colnames(df), nchar(colnames(df)))
  if(!all(intervals[-1] == intervals[2])){
    stop("Na zavihku morajo imeti vse serije isti interval.")
  }
  # check all series are correct interval
  interval <- unique(intervals[-1])
  if (interval == "M" & !all(grepl("^\\d{4}M\\d{2}$", df$period))){
    stop("Vrednosti obdobij niso v formatu yyyyMmm.")
  }
  if (interval == "Q" & !all(grepl("^\\d{4}Q\\d{1}$", df$period))){
    stop("Vrednosti obdobij niso v formatu yyyyQq.")
  }
  if (interval == "A" & !all(grepl("^\\d{4}$", df$period))){
    stop("Vrednosti obdobij niso v formatu yyyy.")
  }
  # check no duplicated series
  series <- colnames(df)[-1]
  dups <- series[duplicated(series)]
  if (length(dups) > 0){
    stop("Stolpci ne smejo imeti enakih imen: ",
         paste(dups, collapse = "," ))
  }

  # check all series are in the database
  series <- colnames(df)[-1]
  missing_codes <- which(!series %in% codes)
  if(length(missing_codes) > 0) {
    stop("Za naslednje serije manjkajo strukturni metapodatki: ",
         paste(series[missing_codes], collapse = "," ))

  }

  interval
}




#' Check data file to be parsed
#'
#'  checks all the sheets with the data are
#' ok with \link[UMARfetchR]{check_data_df}
#'
#' @param filename Excel file with time series data
#' @param codes character vector of codes from main_structure
#'
#' @return TRUE if it works
#' @export
#'
check_data_xlsx <- function(filename, codes) {
  wb <- openxlsx::loadWorkbook(filename)
  # check sheet names correspond with intervals of the data
  sheet_names <- openxlsx::getSheetNames(filename)
  if("M" %in% sheet_names) {
    df <- openxlsx::read.xlsx(filename, sheet = "M")
    interval <- check_data_df(df, codes)
    if (interval != "M") {
      stop("Na zavihku M so dovoljene samo serije z mese\u010dno resolucijo.")
    }
  }
  if("A" %in% sheet_names) {
    df <- openxlsx::read.xlsx(filename, sheet = "A")
    interval <- check_data_df(df, codes)
    if (interval != "A") {
      stop("Na zavihku A so dovoljene samo serije z letno resolucijo.")
    }
  }
  if("Q" %in% sheet_names) {
    df <- openxlsx::read.xlsx(filename, sheet = "Q")
    interval <- check_data_df(df, codes)
    if (interval != "Q") {
      stop("Na zavihku Q so dovoljene samo serije s \u010detrtletno resolucijo.")
    }
  }
  TRUE
}
