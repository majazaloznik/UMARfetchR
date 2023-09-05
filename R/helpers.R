#' Get the initials from a name
#'
#' This function takes a name and returns the initials. It treats both "-" and " "
#' as separators. This function is for internal use and is not exported.
#'
#' @param name name
get_initials <- function(name) {
  words <- unlist(strsplit(name, split = "[ -]"))
  initials <- substring(words, 1, 1)
  paste(initials, collapse = "")
}


#' Get function to check if the author already has a table with that name
#'
#' Checks the author's tables if the same name already exists and uses
#' that code, otherwise returns NA
#'
#' @param auth author initials
#' @param table_name table name
#' @param con connection to the database
get_table_id_with_same_name <- function(auth, table_name, con) {

x <- DBI::dbGetQuery(con, sprintf("SELECT code
       FROM \"table\"
       WHERE code LIKE '%s%%' and name = '%s';", auth, table_name))
ifelse(nrow(x) == 0, NA, x[1,1])

}

#' Get interval from the period value
#'
#' @param period one of the possible period values
#'
#' @return "M", "A" or "Q" - or error if none work
#' @export
#'
get_interval_from_period <- function(period){
 ifelse(grepl("^\\d{4}M\\d{2}$", period), "M",
        ifelse(grepl("^\\d{4}Q\\d{1}$", period), "Q",
                     ifelse(grepl("^\\d{4}$", period), "A",
                            stop("Nekaj je narobe s periodami!"))))

}

#' Function to convert Excel serial date numbers to R Date objects
#' @param numeric
#' @keywords internal
#
excel_date_to_r_date <- function(excel_date) {
  # The origin is "1899-12-30" for the Excel system on Windows
  tryCatch({
    as.Date(excel_date, origin = "1899-12-30")
  }, warning = function(war) {
    return(NA)
  }, error = function(err) {
    return(NA)
  })
}


