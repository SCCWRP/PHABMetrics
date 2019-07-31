test_that('Checking PCT_RS.result', {
  
  result <- submet$PCT_RS.result
  expect_equal(c(0, 0, 0, 0), result)
  
})

test_that('Checking PCT_SB.result', {
  
  result <- submet$PCT_SB.result
  expect_equal(c(7, 1, 0, 20), result)
  
})