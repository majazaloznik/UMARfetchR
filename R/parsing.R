#' Check structure data to be parsed
#'
#' This function checks if the input data that is read from an excel file is
#' in the proper format to be parsed by the parser functions and gives informative
#' errors if not.
#'
#' @param df dataframe from one of the structure worksheets
#' @param interval name of the sheet - which is the one character interval code e.g. "M" or "Q"
#'
#' @return TRUE if passes all checks
#' @export
#'
check_structure_df <- function(df, interval) {

  # Check the column names
  col_names <- c("source", "author", "table_name", "dimensions", "dimension_levels_text",
                 "dimension_levels_code", "unit")
  if (!all(col_names %in% names(df))) {
    stop("Zavihek ", interval, ". Nekaj je narobe z imeni stolpcev. Pri\u010dakovani so vsaj naslednji: ",
         paste(col_names, collapse = ", "))
  }

  # check single author
  if (length(unique(df$author)) != 1) {
    stop("V tabeli so dovoljene samo serije enega avtorja. Mogo\u010de si se zatipkal/a? Vne\u0161eno ima\u0161: ",
         paste(unique(df$author), collapse = ", "))
  }

  #check incomplete rows
  rows_with_na <- which(!complete.cases(df[,1:7]))

  if (length(rows_with_na) > 0) {
    stop("V tabeli ima\u0161 nepopolne vrstice. Poglej naslednje vrstice: ",
         paste(rows_with_na, collapse = ", "))
  }

 TRUE
}



#' Check structure workbook to be parsed
#'
#' Takes the excel file with the data to be parsed and checks the inputs are all
#' OK.
#'
#' @param filename
#'
#' @return TRUE if all checks pass
#' @export
#'
check_structure_wb <- function(filename) {
  sheets <- c("M", "Q", "A")
  wb <- openxlsx::loadWorkbook(filename)
  sheet_names <- openxlsx::getSheetNames(filename)
  if (!all(sheet_names %in% sheets)) {
    stop("Nekaj je narobe z imeni zavihkov. Pri\u010dakovani so naslednji zavihki: ",
         paste(sheets, collapse = ", "))
  }
  for (sheet in sheet_names){
    df <- openxlsx::readWorkbook(wb, sheet = sheet)
    check_structure_df(df, sheet)
  }
  TRUE
}
