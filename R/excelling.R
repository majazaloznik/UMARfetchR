#' Prepare excel template for structure file
#'
#' Prepares an empty excel file with the correct columns for a structure file.
#'
#' @param path path to file, default empty
#' @param author initials of author that becomes part of the filename
#' @param overwrite - whether or not to overwrite previous file
#'
#' @return nothing - side effect is saving to an excel file.
#' @export
#'
#' @importFrom stats setNames

create_structure_template_excel <- function(path = "", author = "name",
                                   overwrite = TRUE){
  outfile <- if (path == "") {
    paste0("umar_serije_metadata_", author, ".xlsx")
  } else {
    file.path(path, paste0("umar_serije_metadata_", author, ".xlsx"))
  }
  nejmz <- c("source", "author", "table_name", "dimensions", "dimension_levels_text",
             "dimension_levels_code", "unit", "interval",
             "series_name", "table_code",	"series_code")

  template_df <- setNames(data.frame(matrix(ncol = length(nejmz), nrow = 0)), nejmz)


  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "timeseries")

  openxlsx::writeData(wb, "timeseries", template_df, startRow = 1, startCol = 1)
  openxlsx::freezePane(wb,"timeseries", firstActiveRow = 2)
  openxlsx::setColWidths(wb, sheet = "timeseries", cols = 1:length(nejmz), widths = "auto")

  openxlsx::saveWorkbook(wb, file = outfile, overwrite = overwrite)
}



#' Update structure table in Excel file
#'
#' After running \link[UMARfetchR]{parse_structure} the updated dataframe
#' with table codes and series codes etc. is written
#' back into the original Excel file with this funciton
#'
#' @param filename name and path of excel file
#' @param df updated dataframe.
#'
#' @return nothing,
#' @export
update_structure_excel <- function(filename, df) {
  wb <- openxlsx::loadWorkbook(filename)
  openxlsx::writeData(wb, "timeseries", df)
  openxlsx::saveWorkbook(wb, filename, overwrite = TRUE)
  message("Tabela ", basename(filename), " je posodobljena.")
}


#' Prepare excel template for data file
#'
#' Prepares an empty excel file for the data. Really only names the three sheets
#'
#' @param path path to file, default empty
#' @param author initials of author that becomes part of the filename
#' @param overwrite - whether or not to overwrite previous file
#'
#' @return nothing - side effect is saving to an excel file.
#' @export

create_data_template_excel <- function(path = "", author = "name", overwrite = TRUE){
  outfile <- if (path == "") {
    paste0("umar_serije_podatki_", author, ".xlsx")
  } else {
    file.path(path, paste0("umar_serije_podatki_", author, ".xlsx"))
  }

  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "M")
  openxlsx::addWorksheet(wb, "Q")
  openxlsx::addWorksheet(wb, "A")
  openxlsx::saveWorkbook(wb, file = outfile, overwrite = overwrite)
}



#' Little helper function to get the codes out of a metadata file
#'
#' does what it says on the tin. no error checking of any note.
#'
#' @param filename location of excel file of the `umar_serije_metadata_XX.xlsx` variety
#'
#' @return vector of code names.
#' @export
read_codes_from_metadata_excel <- function(filename){
  df <- openxlsx::read.xlsx(filename, sheet = "timeseries")
  x <- df$series_code
  x <- x[!is.na(x)]
  if(length(x) == 0) { NA  } else {
    x  }
}
