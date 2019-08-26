#' Substrate metrics
#'
#' @param data Input data
#' 
#' @export
#' 
#' @importFrom magrittr "%>%"
#' 
#' @examples 
#' sampdat <- phabformat(sampdat)
#' substrate(sampdat)
substrate <- function(data){
  print("substrate")
  data <- data[which(data$AnalyteName %in% c('Substrate Size Class', 'Embeddedness', 'CPOM')),]
  
  # the code that runs below this line messed up the XEMBED metric somehow. Specifically it messed up the counts
  # I am preserving the data before it gets tweaked, so that XEMBED can work with "original.data" and the rest can work with "data"
  original.data <- data

  data <- data %>%
    dplyr::select(id, LocationCode, AnalyteName, VariableResult, Result) %>%
    unique %>%
    tidyr::complete(id, LocationCode, AnalyteName) %>%
    dplyr::group_by(id) %>%
    dplyr::filter(!all(is.na(VariableResult) & !all(is.na(Result)))) %>%
    dplyr::ungroup()

  data$VariableResult <- as.character(data$VariableResult)
  data$VariableResult[data$VariableResult=="a"]<-"SA"
  data$VariableResult[data$VariableResult=="as"]<-"SA"
  data$VariableResult[data$VariableResult=="ws"]<-"SA"
  data$VariableResult[data$VariableResult=="sn"]<-"SA" 
  data$VariableResult[data$VariableResult=="N"]<-"Not Recorded"
  data$VariableResult[data$VariableResult=="n"]<- "Not Recorded"
  data$VariableResult[data$VariableResult=="LB"]<-"XB"
  data$VariableResult[data$VariableResult=="G"]<- "GC"
  data$VariableResult[data$VariableResult=="FM"]<-"FN"
  data$VariableResult[data$VariableResult=="fd"]<-"SB"
  data$VariableResult[data$VariableResult=="fb"]<-"SB"
  
  sub <- data[data$AnalyteName =="Substrate Size Class",]
  
  sub$Result <- as.numeric(as.character(sub$Result))
  
  sub$VariableResult[sub$Result>= 1000 & sub$Result<4000] <- "XB"
  sub$VariableResult[sub$Result>= 250 & sub$Result<1000] <- "SB"
  sub$VariableResult[sub$Result>= 64 & sub$Result<250] <- "CB"
  sub$VariableResult[sub$Result>= 16 & sub$Result<64] <- "GC"
  sub$VariableResult[sub$Result>= 2 & sub$Result<16] <- "GF"
  sub$VariableResult[sub$Result>= 0.06 & sub$Result<2] <- "SA"

  # remove reach row
  # Some metric calculations later on needed Reach to be in there
  sub <- sub %>% 
    dplyr::filter(!LocationCode %in% 'Reach')
  
  ###Compute
  
  sumna <- function(data){sum(data, na.rm=T)}
  lengthna <- function(data){sum(!is.na(data))}
  
  metric <- c('RS', 'RR', 'RC', 'XB', 'SB', 'CB', 'GC', 'GF', 'SA', 'FN', 'HP', 'WD', 'OT')
  
  # All VariableResult values get transformed to uppercase here
  # Not Recorded turns into NOT RECORDED
  sub$VariableResult <- lapply(sub$VariableResult, toupper)

  lengths <- function(data){
    length(which(((data != "NOT RECORDED") &(data != "NA"))&(data != "FNOT RECORDED") & (!is.na(data))))}
  totals <- tapply(unlist(sub$VariableResult), sub$id, lengths)
  tnames <- as.vector(dimnames(totals))
  qq <-unlist(tnames)
  l <- matrix(NA, ncol=length(metric), nrow=length(totals))
  
  for(j in 1:length(qq))
    for(i in 1:length(metric)){
      l[j, i] <- length(which(sub$VariableResult[sub$id == qq[j]] == metric[i]))
    }
  divd <- function(data) data*100/totals
  result <- as.data.frame(apply(l, 2, divd))
  if(length(colnames(result))==1){
    result <- t(result)
    rownames(result) <- unique(sub$id)
    result <- as.data.frame(result)
  }
  colnames(result) <- c("PCT_RS.result","PCT_RR.result","PCT_RC.result","PCT_XB.result","PCT_SB.result","PCT_CB.result",
                        "PCT_GC.result","PCT_GF.result","PCT_SA.result","PCT_FN.result","PCT_HP.result",
                        "PCT_WD.result","PCT_OT.result")
  
  
  # Below lines are to add counts to the results dataframe
  # it kind of scares me though, because in this way, I am not sure if the counts will be assigned out of order
  # We will have to test this thoroughly
  # print("creating the PCTs vector")
  PCTs <- gsub(".result", ".count", colnames(result)[grepl("PCT_", colnames(result))])
  for (name in PCTs){
    result[[name]] <- totals
  }
  
  # print("calculating the BDRK, BIGR, SFGF, SAFN")
  result$PCT_BDRK.result <- result$PCT_RS.result + result$PCT_RR.result
  result$PCT_BIGR.result <- result$PCT_RS.result + result$PCT_RR.result + result$PCT_XB.result + result$PCT_SB.result + result$PCT_CB.result + result$PCT_GC.result
  result$PCT_SFGF.result <- result$PCT_GF.result + result$PCT_SA.result + result$PCT_FN.result
  result$PCT_SAFN.result <- result$PCT_SA.result + result$PCT_FN.result
  
  # print("Getting the counts for those metrics")
  result$PCT_BDRK.count <- rowSums(!is.na(result[,c('PCT_RS.result', 'PCT_RR.result')]))
  result$PCT_BIGR.count <- rowSums(!is.na(result[,c('PCT_RS.result', 'PCT_RR.result', 'PCT_XB.result', 'PCT_SB.result', 'PCT_CB.result', 'PCT_GC.result')]))
  result$PCT_SFGF.count <- rowSums(!is.na(result[,c('PCT_GF.result', 'PCT_SA.result', 'PCT_FN.result')]))
  result$PCT_SAFN.count <- rowSums(!is.na(result[,c('PCT_SA.result', 'PCT_FN.result')]))
  
  result <- round(result)
    
  
  # H_SubNat, Ev_SubNat
  SubNat <- sub %>% 
    dplyr::select(id, LocationCode, VariableResult) %>% 
    tidyr::unnest() %>% 
    dplyr::group_by(id) %>% 
    tidyr::nest() %>% 
    dplyr::mutate(
      H_SubNat.result = purrr::map(data, function(VariableResult){
  
        VariableResult <- VariableResult %>% dplyr::pull(VariableResult)
        
        # step 2 and 3
        # the argument that says length in the aggregate function shoud probably be lengthna for correct measurement.
        # I believe I put length, to get it to match the (what we are pretty sure is) wrong legacy calculation.
        uniques <- aggregate(data.frame(count = VariableResult), list(value = VariableResult), lengthna) %>% dplyr::filter(!toupper(value) %in% c('RC', 'NOT RECORDED'))
        
        if (length(intersect(c('RS','RR','HP'), uniques$value)) != 0){
          RSRRHPgroup <- data.frame('RSRRHP', sum(uniques[uniques$value %in% c('RS','RR','HP'),]$count))
          names(RSRRHPgroup) <- c('value','count')
          uniques <- rbind(uniques, RSRRHPgroup)
        }
        uniques <- uniques %>% dplyr::filter(!value %in% c('RS','RR','HP'))
      
        if ((sum(uniques$count) == 0) | (uniques %>% nrow == 0)) { return(0) }
      
        # step 4
        uniques$pi <- uniques$count / sum(uniques$count)
      
        # step 5
        uniques$imlt <- uniques$pi * log(uniques$pi)
 
        # step 6
        res <- round(sum(uniques$imlt) * (-1), 2)
        
        return(res)
        
        }
      ),
      H_SubNat.count = purrr::map(data, function(VariableResult){
        
        VariableResult <- VariableResult %>% dplyr::pull(VariableResult)
        
        # total number of size classes used to calculate H_SubNat
        uniques <- aggregate(data.frame(count = VariableResult), list(value = VariableResult), lengthna) %>% dplyr::filter(!toupper(value) %in% c('RC', 'NOT RECORDED'))
      
        if (length(intersect(c('RS','RR','HP'), uniques$value)) != 0){
          RSRRHPgroup <- data.frame('RSRRHP', sum(uniques[uniques$value %in% c('RS','RR','HP'),]$count))
          names(RSRRHPgroup) <- c('value','count')
        uniques <- rbind(uniques, RSRRHPgroup)
        }
        uniques <- uniques %>% dplyr::filter(!value %in% c('RS','RR','HP'))
            
        n_size_classes <- length(uniques$value)
        return(n_size_classes)
       }),
      Ev_SubNat.result = purrr::pmap(list(data, H_SubNat.result), function(VariableResult, H_SubNat.result){
        
        VariableResult <- VariableResult %>% dplyr::pull(VariableResult)
        
        # total number of size classes used to calculate H_SubNat
        uniques <- aggregate(data.frame(count = VariableResult), list(value = VariableResult), length) %>% dplyr::filter(!toupper(value) %in% c('RC', 'NOT RECORDED'))
      
        if (length(intersect(c('RS','RR','HP'), uniques$value)) != 0){
          RSRRHPgroup <- data.frame('RSRRHP', sum(uniques[uniques$value %in% c('RS','RR','HP'),]$count))
          names(RSRRHPgroup) <- c('value','count')
        uniques <- rbind(uniques, RSRRHPgroup)
        }
        uniques <- uniques %>% dplyr::filter(!value %in% c('RS','RR','HP'))
      
        if ((sum(uniques$count) == 0) | (uniques %>% nrow == 0)) { 
          return(0) 
        } else {
          n_size_classes <- length(uniques$value)
          if (n_size_classes > 1) {
            return(round(H_SubNat.result / log(n_size_classes), 2))
          } else {
            return(0)
          }
        }
      }), 
      Ev_SubNat.count = H_SubNat.count
    ) %>% 
    dplyr::select(-data) %>% 
    tidyr::unnest() %>% 
    as.data.frame(stringsAsFactors = F) %>% 
    tibble::column_to_rownames('id')

  ###Second set of computation
  # I believe the metrics from here on out needed Reach to be in there
  sub$value <- rep(NA, length(sub$id))
  sub$value[which(!is.na(sub$Result))] <- sub$Result[which(!is.na(sub$Result))]
  sub$value[which(sub$VariableResult == "RR")] <- 5660.0
  sub$value[which(sub$VariableResult == "RS")] <- 5660.0
  sub$value[which(sub$VariableResult == "XB")] <- 2500.0
  sub$value[which(sub$VariableResult == "SB")] <- 625.0
  sub$value[which(sub$VariableResult == "CB")] <- 157.0
  sub$value[which(sub$VariableResult == "GC")] <- 40.0
  sub$value[which(sub$VariableResult == "GF")] <- 9.0
  sub$value[which(sub$VariableResult == "SA")] <- 1.03
  sub$value[which(sub$VariableResult == "FN")] <- 0.03
  sub$value[which(sub$VariableResult == "HP")] <- 5660.0
  sub$value[which(sub$VariableResult == "RC")] <- 5660.0
  
  # Thi put this in because the instructions say "If result column contains a value, leave as is"
  sub <- sub %>% dplyr::mutate(value = dplyr::case_when(
    is.na(Result) ~ value,
    TRUE ~ Result
  ))
  
  
  sub$value <- as.numeric(as.character(sub$value))
  sub$log <- log10(sub$value)
  
  XSDGM_sum <- tapply(sub$log, sub$id, sumna)
  XSDGM_count <- tapply(sub$log, sub$id, lengthna)
  XSDGM <- 10^(XSDGM_sum/XSDGM_count)
  result$XSDGM.result <- XSDGM %>% round(1)
  result$XSDGM.count <- XSDGM_count
  
  sub$value2 <- rep(NA, length(sub$id))
  sub$value2[which(!is.na(sub$Result))] <- sub$Result[which(!is.na(sub$Result))]
  sub$value2[which(sub$VariableResult == "RR")] <- NA
  sub$value2[which(sub$VariableResult == "RS")] <- NA
  sub$value2[which(sub$VariableResult == "XB")] <- 2500.0
  sub$value2[which(sub$VariableResult == "SB")] <- 625.0
  sub$value2[which(sub$VariableResult == "CB")] <- 157.0
  sub$value2[which(sub$VariableResult == "GC")] <- 40.0
  sub$value2[which(sub$VariableResult == "GF")] <- 9.0
  sub$value2[which(sub$VariableResult == "SA")] <- 1.03
  sub$value2[which(sub$VariableResult == "FN")] <- 0.03
  sub$value2[which(sub$VariableResult == "HP")] <- NA
  sub$value2[which(sub$VariableResult == "RC")] <- NA
  
  #Result value should be preserved, midpoint value should only be used when Result is NA
  sub <- sub %>% 
    dplyr::mutate(value2 = dplyr::case_when(
      is.na(Result) ~ value2,
      TRUE ~ Result
    ))
  
  sub$value2 <- as.numeric(as.character(sub$value2))
  sub$log2 <- log10(sub$value2)
  
  XSPDGM_sum <- tapply(sub$log2, sub$id, sumna)
  XSPDGM_count <- tapply(sub$log2, sub$id, lengthna)
  XSDPGM <- 10^(XSPDGM_sum/XSPDGM_count)
  result$XSPGM.result <- XSDPGM
  
  # Below is code that does what the original VBA code did. Sorting values and grabbing a value from a certain index
  # It appears as if SWAMP takes the floor instead of rounding
  PT_ind <- sub %>% dplyr::select(id, value) %>% dplyr::group_by(id) %>% tidyr::nest() %>% 
  dplyr::mutate(perc = purrr::map(data, function(df){
    percentiles <- c('PTD10index','PTD25index','PTD50index','PTD75index','PTD90index')
    indices <- (sum(!is.na(df$value)) * c(0.1,0.25,0.5,0.75,0.9)) %>% ceiling #I think SWAWMP does ceiling rather than rounding
    output <- data.frame(percentiles = percentiles, indices = indices)
    return(output)
  })) %>% 
  dplyr::select(-data) %>% tidyr::unnest() %>% dplyr::group_by_at(dplyr::vars(id)) %>% tidyr::spread(key = percentiles, value = indices) 

  PP_ind <- sub %>% dplyr::select(id, value2) %>% dplyr::group_by(id) %>% tidyr::nest() %>% 
  dplyr::mutate(perc = purrr::map(data, function(df){
    percentiles <- c('PPD10index','PPD25index','PPD50index','PPD75index','PPD90index')
    indices <- (sum(!is.na(df$value2)) * c(0.1,0.25,0.5,0.75,0.9)) %>% ceiling #I think SWAWMP does ceiling rather than rounding
    indices <- replace(indices, which(indices == 0), 1)
    output <- data.frame(percentiles = percentiles, indices = indices)
    return(output)
  })) %>% 
  dplyr::select(-data) %>% tidyr::unnest() %>% dplyr::group_by_at(dplyr::vars(id)) %>% tidyr::spread(key = percentiles, value = indices) 

  sub <- merge(sub, PT_ind, by = 'id')
  sub <- merge(sub, PP_ind, by = 'id')

  percentiles <- sub %>%
    dplyr::group_by(id) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      SB_PT_D50.result = purrr::map(data, function(df){
        #sort(df$value)[df$PTD50index[1]]
        median(df$value, na.rm = T)
      }),
      SB_PT_D10.result = purrr::map(data, function(df){
        sort(df$value)[df$PTD10index[1]]
      }),
      SB_PT_D25.result = purrr::map(data, function(df){
        sort(df$value)[df$PTD25index[1]]
      }),
      SB_PT_D75.result = purrr::map(data, function(df){
        sort(df$value)[df$PTD75index[1]]
      }),
      SB_PT_D90.result = purrr::map(data, function(df){
        sort(df$value)[df$PTD90index[1]]
      }),
      SB_PP_D50.result = purrr::map(data, function(df){
        sort(df$value)[df$PPD50index[1]]
      }),
      SB_PP_D10.result = purrr::map(data, function(df){
        sort(df$value)[df$PPD10index[1]]
      }),
      SB_PP_D25.result = purrr::map(data, function(df){
        sort(df$value)[df$PPD25index[1]]
      }),
      SB_PP_D75.result = purrr::map(data, function(df){
        sort(df$value)[df$PPD75index[1]]
      }),
      SB_PP_D90.result = purrr::map(data, function(df){
        sort(df$value)[df$PPD90index[1]]
      }),
      SB_PT_D50.count = purrr::map(data, function(df){
        sum(!is.na(df$value))
      }),
      SB_PT_D10.count = purrr::map(data, function(df){
        sum(!is.na(df$value))
      }),
      SB_PT_D25.count = purrr::map(data, function(df){
        sum(!is.na(df$value))
      }),
      SB_PT_D75.count = purrr::map(data, function(df){
        sum(!is.na(df$value))
      }),
      SB_PT_D90.count = purrr::map(data, function(df){
        sum(!is.na(df$value))
      }),
      SB_PP_D50.count = purrr::map(data, function(df){
        sum(!is.na(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value))
      }),
      SB_PP_D10.count = purrr::map(data, function(df){
        sum(!is.na(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value))
      }),
      SB_PP_D25.count = purrr::map(data, function(df){
        sum(!is.na(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value))
      }),
      SB_PP_D75.count = purrr::map(data, function(df){
        sum(!is.na(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value))
      }),
      SB_PP_D90.count = purrr::map(data, function(df){
        sum(!is.na(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value))
      })
    ) %>% dplyr::select(-data) %>%
    tidyr::unnest() %>% as.data.frame %>% tibble::column_to_rownames('id')

  
  
  # Below is code that we believe does what is specified in the instructions. The built in quantile function 
  # calculates the distribution and then grabs whatever percentile from that distribution.
  # VBA was simply sorting and grabbing a value from a certain index.
  # it depends in what Rafi wants though i think.
  # percentiles <- sub %>%
  #   dplyr::group_by(id) %>%
  #   tidyr::nest() %>%
  #   dplyr::mutate(
  #     SB_PT_D50.result = purrr::map(data, function(df){
  #       quantile(df$value, 0.5, na.rm = T)
  #     }),
  #     SB_PT_D10.result = purrr::map(data, function(df){
  #       quantile(df$value, 0.1, na.rm = T)
  #     }),
  #     SB_PT_D25.result = purrr::map(data, function(df){
  #       quantile(df$value, 0.25, na.rm = T)
  #     }),
  #     SB_PT_D75.result = purrr::map(data, function(df){
  #       quantile(df$value, 0.75, na.rm = T)
  #     }),
  #     SB_PT_D90.result = purrr::map(data, function(df){
  #       quantile(df$value, 0.90, na.rm = T)
  #     }),
  #     SB_PP_D50.result = purrr::map(data, function(df){
  #       quantile(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value, 0.5, na.rm = T)
  #     }),
  #     SB_PP_D10.result = purrr::map(data, function(df){
  #       quantile(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value, 0.1, na.rm = T)
  #     }),
  #     SB_PP_D25.result = purrr::map(data, function(df){
  #       quantile(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value, 0.25, na.rm = T)
  #     }),
  #     SB_PP_D75.result = purrr::map(data, function(df){
  #       quantile(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value, 0.75, na.rm = T)
  #     }),
  #     SB_PP_D90.result = purrr::map(data, function(df){
  #       quantile(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value, 0.90, na.rm = T)
  #     }),
  #     SB_PT_D50.count = purrr::map(data, function(df){
  #       sum(!is.na(df$value))
  #     }),
  #     SB_PT_D10.count = purrr::map(data, function(df){
  #       sum(!is.na(df$value))
  #     }),
  #     SB_PT_D25.count = purrr::map(data, function(df){
  #       sum(!is.na(df$value))
  #     }),
  #     SB_PT_D75.count = purrr::map(data, function(df){
  #       sum(!is.na(df$value))
  #     }),
  #     SB_PT_D90.count = purrr::map(data, function(df){
  #       sum(!is.na(df$value))
  #     }),
  #     SB_PP_D50.count = purrr::map(data, function(df){
  #       sum(!is.na(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value))
  #     }),
  #     SB_PP_D10.count = purrr::map(data, function(df){
  #       sum(!is.na(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value))
  #     }),
  #     SB_PP_D25.count = purrr::map(data, function(df){
  #       sum(!is.na(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value))
  #     }),
  #     SB_PP_D75.count = purrr::map(data, function(df){
  #       sum(!is.na(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value))
  #     }),
  #     SB_PP_D90.count = purrr::map(data, function(df){
  #       sum(!is.na(df[!(df$VariableResult %in% c('HP','RS','RR','RC','WD','OT')),]$value))
  #     })
  #     
  #   ) %>% dplyr::select(-data) %>%
  #   tidyr::unnest() %>% as.data.frame %>% tibble::column_to_rownames('id')
 
  # I suspect that the metrics were calculated correctly, but were jumbled around.
  # I re did it to ensure the metrics matched with the correct stations, but still numbers are a little off.
  #qant <- function(data)quantile(data, c(.5, .1, .25, .75, .9), na.rm=T)
  #otwd <- which(!(sub$VariableResult %in% c("OT", "WD")))
  #temp <-tapply(sub$value[otwd], sub$id[otwd], qant)
  #for(i in 1:length(temp)){
  #  result$SB_PT_D50.result[i] <- temp[[i]][1]
  #  result$SB_PT_D10.result[i] <- temp[[i]][2]
  #  result$SB_PT_D25.result[i] <- temp[[i]][3]
  #  result$SB_PT_D75.result[i] <- temp[[i]][4]
  #  result$SB_PT_D90.result[i] <- temp[[i]][5]
  #}
  #OTWDHP <- which(!(sub$VariableResult %in% c("OT", "WD", "HP", "RS", "RR", "RC")))
  #temp2 <-tapply(sub$value[OTWDHP], sub$id[OTWDHP], qant)
  #for(i in 1:length(temp2)){
  #  result$SB_PP_D50.result[i] <- temp2[[i]][1]
  #  result$SB_PP_D10.result[i] <- temp2[[i]][2]
  #  result$SB_PP_D25.result[i] <- temp2[[i]][3]
  #  result$SB_PP_D75.result[i] <- temp2[[i]][4]
  #  result$SB_PP_D90.result[i] <- temp2[[i]][5]
  #}
  sdna <- function(data) sd(data, na.rm=T)
  embed <- original.data[which((original.data$AnalyteName=="Embeddedness")&
                             (!(original.data$LocationCode=="X"))),]
  embed$Result <- as.numeric(as.character(embed$Result))
  XEMBED_sum <- tapply(embed$Result, embed$id, sumna)
  XEMBED_count <- tapply(embed$Result, embed$id, lengthna)
  result$XEMBED.result <- round(XEMBED_sum/XEMBED_count)
  result$XEMBED.count <- XEMBED_count
  result$XEMBED.sd <- round(tapply(embed$Result, embed$id, sdna), 1)

  cpom <- data[data$AnalyteName=="CPOM",]
  present <- function(data){
    sum(data == "Present", na.rm = TRUE)
  }
  cpomtotal <- function(data){
    sum((data == "Present") | (data == "Absent"), na.rm = TRUE)
  }
  cpresent <- tapply(cpom$VariableResult, cpom$id, present)
  ctotal <- tapply(cpom$VariableResult, cpom$id, cpomtotal)
  result$PCT_CPOM.result <- round(cpresent*100/ctotal)
  result$PCT_CPOM.count <- ctotal
  
  # add H_SubNat, Ev_SubNat
  result$H_SubNat.result <- SubNat$H_SubNat.result
  result$H_SubNat.count <- SubNat$H_SubNat.count
  result$Ev_SubNat.result <- SubNat$Ev_SubNat.result
  result$Ev_SubNat.count <- SubNat$Ev_SubNat.count
  
  # merge result with the percentile metrics on row names
  result <- merge(result, percentiles, by = 'row.names') %>% tibble::column_to_rownames('Row.names')
  print("End substrate")
  return(result)
  
}
