test_that("create_excel_file produces an Excel file with the correct structure", {

  filename <- paste0("umar_serije_metadata_", "name", ".xlsx")
  create_structure_template_excel()

  ws <- openxlsx::read.xlsx(filename, sheet = "timeseries")
  # Check that the file has the right number of rows and columns
  expect_equal(ncol(ws), 9)
  expect_equal(names(ws)[1], "source")

  # Don't forget to delete the temp file
  unlink(filename)
})



testthat::test_that("update_structure_excel updates Excel workbook correctly", {
  temp_filename <- tempfile(fileext = ".xlsx")
  df_orig <- data.frame(a = 1:3)
  wb_orig <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb_orig, "timeseries")
  openxlsx::writeData(wb_orig, "timeseries", df_orig)
  openxlsx::saveWorkbook(wb_orig, temp_filename, overwrite = TRUE)
  new_df <- data.frame(b = as.double(4:6))
  update_structure_excel(temp_filename, new_df)
  wb <- openxlsx::loadWorkbook(temp_filename)
  sheet_data <- openxlsx::read.xlsx(wb, sheet = "timeseries")
  testthat::expect_identical(sheet_data, new_df)
  unlink(temp_filename)
})
