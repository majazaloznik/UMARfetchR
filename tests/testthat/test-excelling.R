test_that("create_excel_file produces an Excel file with the correct structure", {

  # Call the function to create an Excel file
  filename <- paste0("struct_table_", "name", ".xlsx")
  create_structure_template_excel()

  # Load the workbook
  m <- openxlsx::read.xlsx(filename, sheet = "M")
  q <- openxlsx::read.xlsx(filename, sheet = "Q")
  a <- openxlsx::read.xlsx(filename, sheet = "A")
  # Check that the file has the right number of rows and columns
  expect_equal(ncol(m), 8)
  expect_equal(ncol(q), 8)
  expect_equal(ncol(a), 8)
  expect_equal(names(m)[1], "source")

  # Don't forget to delete the temp file
  unlink(filename)
})


