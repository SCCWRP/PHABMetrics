test_that('Checking PCT_RS.result', {
  
  result <- submet$PCT_RS.result
  expect_equal(c(0, 0, 0, 0), result)
  
})

test_that('Checking PCT_SB.result', {
  
  result <- submet$PCT_SB.result
  expect_equal(c(2, 0, 13, 7), result)
  
})