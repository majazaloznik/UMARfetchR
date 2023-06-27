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
create_structure_template_excel <- function(author = "name",
                                   overwrite = TRUE){

  outfile <- paste0("struct_table_", author, ".xlsx")
  nejmz <- c("source", "author", "table_name", "dimensions", "dimension_levels_text",
             "dimension_levels_code", "unit", "series_name")

  template_df <- setNames(data.frame(matrix(ncol = length(nejmz), nrow = 0)), nejmz)


  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "M")
  openxlsx::addWorksheet(wb, "Q")
  openxlsx::addWorksheet(wb, "A")

  openxlsx::writeData(wb, "M", template_df, startRow = 1, startCol = 1)
  openxlsx::writeData(wb, "Q", template_df, startRow = 1, startCol = 1)
  openxlsx::writeData(wb,"A", template_df, startRow = 1, startCol = 1)
  openxlsx::freezePane(wb,"M", firstActiveRow = 2)
  openxlsx::freezePane(wb,"Q", firstActiveRow = 2)
  openxlsx::freezePane(wb,"A", firstActiveRow = 2)
  openxlsx::setColWidths(wb, sheet = "M", cols = 1:length(nejmz), widths = "auto")
  openxlsx::setColWidths(wb, sheet = "Q", cols = 1:length(nejmz), widths = "auto")
  openxlsx::setColWidths(wb, sheet = "A", cols = 1:length(nejmz), widths = "auto")

  openxlsx::saveWorkbook(wb, file = outfile, overwrite = overwrite)
}
