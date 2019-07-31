test_that('Checking PCT_RS.result', {
  
  PCT_RS.result <- submet$PCT_RS.result
  expect_equal(c(0, 0, 0, 0), PCT_RS.result)
  
  }
)