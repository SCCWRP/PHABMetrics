test_that('Checking PCT_RS.result', {
  
  result <- submet$PCT_RS.result
  expect_equal(c(0, 0, 0, 0), result)
  
})

test_that('Checking PCT_RR.result', {
  
  result <- submet$PCT_RR.result
  expect_equal(c(0, 0, 0, 0), result)
  
})

test_that('Checking PCT_RC.result', {
  
  result <- submet$PCT_RC.result
  expect_equal(c(0, 0, 0, 10), result)
  
})

test_that('Checking PCT_XB.result', {
  
  result <- submet$PCT_XB.result
  expect_equal(c(0, 0, 0, 3), result)
  
})

test_that('Checking PCT_SB.result', {
  
  result <- submet$PCT_SB.result
  expect_equal(c(2, 0, 13, 7), result)
  
})

test_that('Checking PCT_CB.result', {
  
  result <- submet$PCT_CB.result
  expect_equal(c(5, 23, 28, 45), result)
  
})

test_that('Checking PCT_GC.result', {
  
  result <- submet$PCT_GC.result
  expect_equal(c(23, 49, 18, 17), result)
  
})

test_that('Checking PCT_GF.result', {
  
  result <- submet$PCT_GF.result
  expect_equal(c(19, 10, 9, 1), result)
  
})

test_that('Checking PCT_SA.result', {
  
  result <- submet$PCT_SA.result
  expect_equal(c(49, 10, 27, 12), result)
  
})

test_that('Checking PCT_FN.result', {
  
  result <- submet$PCT_FN.result
  expect_equal(c(1, 3, 4, 0), result)
  
})

test_that('Checking PCT_HP.result', {
  
  result <- submet$PCT_HP.result
  expect_equal(c(1, 0, 0, 1), result)
  
})

test_that('Checking PCT_WD.result', {
  
  result <- submet$PCT_WD.result
  expect_equal(c(1, 5, 2, 4), result)
  
})

test_that('Checking PCT_OT.result', {
  
  result <- submet$PCT_OT.result
  expect_equal(c(0, 0, 0, 0), result)
  
})

test_that('Checking counts of PCT_(RS, RR, RC, XB, SB, CB, GC, GF, SA, FN, HP. WD. OT)', {
  
  count <- c()
  count[[1]] <- submet$PCT_RS.count
  count[[2]] <- submet$PCT_RR.count
  count[[3]] <- submet$PCT_RC.count
  count[[4]] <- submet$PCT_XB.count
  count[[5]] <- submet$PCT_SB.count
  count[[6]] <- submet$PCT_CB.count
  count[[7]] <- submet$PCT_GC.count
  count[[8]] <- submet$PCT_GF.count
  count[[9]] <- submet$PCT_SA.count
  count[[10]] <- submet$PCT_FN.count
  count[[11]] <- submet$PCT_HP.count
  count[[12]] <- submet$PCT_WD.count
  count[[13]] <- submet$PCT_OT.count
  
  for(i in 1:13){
    expect_equal(c(105, 105, 105, 105), as.vector(count[[i]]))
  }
  
})

test_that('Checking XSPGM.result', {

  result <- submet$XSPGM.result
  expect_equal(c(4.776569, 20.563869, 19.282021, 56.476045), as.vector(result))
})
