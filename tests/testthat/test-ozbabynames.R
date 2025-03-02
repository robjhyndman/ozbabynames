test_that("ozbabynames", {
  expect_equal(length(unique(ozbabynames$state)), 7L)
  expect_equal(min(ozbabynames$year), 1930)
  expect_equal(max(ozbabynames$year), 2024)
  expect_equal(class(ozbabynames$year), "integer")
  expect_equal(class(ozbabynames$count), "integer")
  expect_equal(colnames(ozbabynames), c("year", "state", "sex", "name", "count"))
})
