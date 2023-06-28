#' Prepare excel template for structure file
#'
#' Prepares an empty excel file with the correct columns for a structure file.
#'
#' @param author name of author that becomes part of the filename
#' @param overwrite - whether or not to overwrite previous file
#'
#' @return nothing - side effect is saving to an excel file.
#' @export
#'
#' @importFrom stats setNames

create_structure_template_excel <- function(author = "name",
                                   overwrite = TRUE){

  outfile <- paste0("struct_table_", author, ".xlsx")
  nejmz <- c("source", "author", "table_name", "dimensions", "dimension_levels_text",
             "dimension_levels_code", "unit", "interval", "series_name")

  template_df <- setNames(data.frame(matrix(ncol = length(nejmz), nrow = 0)), nejmz)


  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "timeseries")

  openxlsx::writeData(wb, "timeseries", template_df, startRow = 1, startCol = 1)
  openxlsx::freezePane(wb,"timeseries", firstActiveRow = 2)
  openxlsx::setColWidths(wb, sheet = "timeseries", cols = 1:length(nejmz), widths = "auto")

  openxlsx::saveWorkbook(wb, file = outfile, overwrite = overwrite)
}
