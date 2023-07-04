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
