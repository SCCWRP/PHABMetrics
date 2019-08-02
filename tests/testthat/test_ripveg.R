test_that('Checking XGB.result', {
  
  result <- ripvegmet$XGB.result
  expect_equal(c(8, 38, 60, 36), result)
  
})


