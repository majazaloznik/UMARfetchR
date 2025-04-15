test_that("create_excel_file produces an Excel file with the correct structure", {

  filename <- paste0("umar_serije_metadata_", "name", ".xlsx")
  create_structure_template_excel()

  ws <- openxlsx::read.xlsx(filename, sheet = "timeseries")
  # Check that the file has the right number of rows and columns
  expect_equal(ncol(ws), 11)
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

test_that("create_data_template_excel: Check if Excel file is created with custom path", {
  # Define a custom path for the Excel file
  custom_folder <- file.path(tempdir(), "custom_folder")
  dir.create(custom_folder)  # Create the custom folder before calling the function

  # Call the function with custom path
  create_data_template_excel(path = custom_folder)

  # Check if the file is created in the custom folder
  expect_true(file.exists(file.path(custom_folder, "umar_serije_podatki_name.xlsx")))
})

test_that("code reading from xlsx works", {
  x <-read_codes_from_metadata_excel(testthat::test_path("testdata", "struct_tests6.xlsx"))
  expect_equal(length(x), 3)
})
