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


