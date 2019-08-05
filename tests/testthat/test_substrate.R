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

test_that('Checking counts of PCT_(RS, RR, RC, XB, SB, CB, GC, GF, SA, FN, HP. WD. OT).count', {
  
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

test_that('Checking PCT_BDRK.result', {
  result <- submet$PCT_BDRK.result
  expect_equal(c(0, 0, 0, 0), result)
})

test_that('Checking PCT_BIGR.result', {
  result <- submet$PCT_BIGR.result
  expect_equal(c(30, 71, 59, 71), result)
})

test_that('Checking PCT_SFGF.result', {
  result <- submet$PCT_SFGF.result
  expect_equal(c(69, 24, 39, 13), result)
})

test_that('Checking PCT_SAFN.result', {
  result <- submet$PCT_SAFN.result
  expect_equal(c(50, 13, 30, 12), result)
})

test_that('Checking PCT_BDRK.count', {
  result <- submet$PCT_BDRK.count
  expect_equal(c(2, 2, 2, 2), result)
})

test_that('Checking PCT_BIGR.count', {
  result <- submet$PCT_BIGR.count
  expect_equal(c(6, 6, 6, 6), result)
})

test_that('Checking PCT_SFGF.count', {
  result <- submet$PCT_SFGF.count
  expect_equal(c(3, 3, 3, 3), result)
})

test_that('Checking PCT_SAFN.cont', {
  result <- submet$PCT_SAFN.count
  expect_equal(c(2, 2, 2, 2), result)
})

test_that('Checking XSDGM.result', {
  result <- submet$XSDGM.result
  expect_equal(c(5.1, 20.6, 19.3, 97.6), as.vector(result))
})


test_that('Checking XSDGM.count', {
  result <- submet$XSDGM.count
  expect_equal(c(104, 100, 103, 101), as.vector(result))
})


test_that('Checking XSPGM.result', {
  
  result <- submet$XSPGM.result
  expect_equal(c(4.776569, 20.563869, 19.282021, 56.476045), as.vector(result))
})


test_that('Checking XEMBED.result', {
  result <- submet$XEMBED.result
  expect_equal(c(36, 24, 36, 7), as.vector(result))
})


test_that('Checking XEMBED.count', {
  result <- submet$XEMBED.count
  expect_equal(c(26, 25, 27, 47), as.vector(result))
})


test_that('Checking XEMBED.sd', {
  result <- submet$XEMBED.sd
  expect_equal(c(19.8, 26.8, 33.9, 14.0), as.vector(result))
})

test_that('Checking PCT_CPOM.result', {
  result <- submet$PCT_CPOM.result
  expect_equal(c(19, 84, 12, 82), as.vector(result))
})


test_that('Checking PCT_CPOM.count', {
  result <- submet$PCT_CPOM.count
  expect_equal(c(105, 105, 104, 95), as.vector(result))
})


test_that('Checking H_SubNat.result', {
  result <- submet$H_SubNat.result
  expect_equal(c(1.36, 1.41, 1.70, 1.47), result)
})


test_that('Checking H_SubNat.count', {
  result <- submet$H_SubNat.count
  expect_equal(c(8, 6, 7, 8), result)
})


test_that('Checking Ev_SubNat.result', {
  result <- submet$Ev_SubNat.result
  expect_equal(c(0.65, 0.79, 0.87, 0.71), result)
})


test_that('Checking Ev_SubNat.count', {
  result <- submet$Ev_SubNat.count
  expect_equal(c(8, 6, 7, 8), result)
})


test_that('Checking SB_PT_D50.result', {
  result <- submet$SB_PT_D50.result
  expect_equal(c(3.515, 36.500, 33.000, 111.000), as.vector(result))
})

test_that('Checking SB_PT_D10.result', {
  result <- submet$SB_PT_D10.result
  expect_equal(c(1.03, 1.03, 1.03, 1.03), as.vector(result))
})

test_that('Checking SB_PT_D25.result', {
  result <- submet$SB_PT_D25.result
  expect_equal(c(1.03, 15.00, 1.03, 43.00), as.vector(result))
})

test_that('Checking SB_PT_D75.result', {
  result <- submet$SB_PT_D75.result
  expect_equal(c(20, 60, 160, 210), as.vector(result))
})

test_that('Checking SB_PT_D90.result', {
  result <- submet$SB_PT_D90.result
  expect_equal(c(44, 75, 625, 5660), as.vector(result))
})

test_that('Checking SB_PP_D10.result', {
  result <- submet$SB_PP_D10.result
  expect_equal(c(1.03, 1.03, 1.03, 1.03), as.vector(result))
})

test_that('Checking SB_PP_D25.result', {
  result <- submet$SB_PP_D25.result
  expect_equal(c(1.03, 15.00, 1.03, 37.00), as.vector(result))
})


test_that('Checking SB_PP_D75.result', {
  result <- submet$SB_PP_D75.result
  expect_equal(c(19, 60, 160, 172), as.vector(result))
})


test_that('Checking SB_PP_D90.result', {
  result <- submet$SB_PP_D90.result
  expect_equal(c(42, 75, 625, 290), as.vector(result))
})

test_that('Checking counts of PCT_P
          
          T_D(50, 10, 25, 75, 90).count', {
  
  count <- c()
  count[[1]] <- submet$SB_PT_D50.count
  count[[2]] <- submet$SB_PT_D10.count
  count[[3]] <- submet$SB_PT_D25.count
  count[[4]] <- submet$SB_PT_D75.count
  count[[5]] <- submet$SB_PT_D90.count
  
  for(i in 1:5){
    expect_equal(c(104, 100, 103, 101), as.vector(count[[i]]))
  }
  
})


test_that('Checking counts of PCT_PP_D(50, 10, 25, 75, 90).count', {
  
  count <- c()
  count[[1]] <- submet$SB_PP_D50.count
  count[[2]] <- submet$SB_PP_D10.count
  count[[3]] <- submet$SB_PP_D25.count
  count[[4]] <- submet$SB_PP_D75.count
  count[[5]] <- submet$SB_PP_D90.count
  
  for(i in 1:5){
    expect_equal(c(103, 100, 103, 89), as.vector(count[[i]]))
  }
  
})

