#' Algae metrics
#'
#' @param data Input data
#' 
#' @export
#' 
#' @examples 
#' sampdat <- phabformat(sampdat)
#' algae(sampdat)
algae <- function(data){

  data <- data[which(data$AnalyteName %in% c('Microalgae Thickness', 'Macrophyte Cover', 'Macroalgae Cover, Attached', 'Macroalgae Cover, Unattached')),]
  
  lengthna <- function(x){
    return(sum(!is.na(x)))
  }
  
  ###Slice for microalgae###
  microalgae <- data.frame(cbind(data$id[which(data$AnalyteName == 'Microalgae Thickness')], as.character(data$VariableResult[which(data$AnalyteName == 'Microalgae Thickness')])))
  colnames(microalgae) <- c("id", "VariableResult")
  
  ###Compute PCT_MIATP###
  
  FUN_PCT_MIATP <- function(data){
    x <- {1:length(data)}
    present_calculation <- function(number){
      for(i in 1:length(data)){
        if(data[i] == number ){
          x[i] <- 1
        }else{
          x[i] <- 0
        }
      }
      present <- sum(x)
      return(present) 
    }
    present_subtotals <- tapply(1:5, as.factor(1:5), present_calculation)
    present <- sum(present_subtotals)
    
    total_calculation <- function(number){
      for(i in 1:length(data)){
        if(data[i] == number ){
          x[i] <- 1
        }else{
          x[i] <- 0
        }
      }
      total <- sum(x)
      return(total) 
    }
    total_subtotals <- tapply(0:5, as.factor(0:5), total_calculation)
    total <- sum(total_subtotals)
    result <- round((present/total)*100)
    return(result)
  }
  PCT_MIATP.result <- round(tapply(microalgae$VariableResult, microalgae$id, FUN_PCT_MIATP))
  PCT_MIATP.count <- tapply(microalgae$VariableResult, microalgae$id, function(x){
    return(sum(x %in% c('0','1','2','3','4','5')))
  })
  
  
  ###Compute PCT_MIAT1###
  
  FUN_PCT_MIAT1 <- function(data){
    x <- {1:length(data)}
    present_calculation <- function(number){
      for(i in 1:length(data)){
        if(data[i] == number ){
          x[i] <- 1
        }else{
          x[i] <- 0
        }
      }
      present <- sum(x)
      return(present) 
    }
    present_subtotals <- tapply(3:5, as.factor(3:5), present_calculation)
    present <- sum(present_subtotals)
    
    total_calculation <- function(number){
      for(i in 1:length(data)){
        if(data[i] == number ){
          x[i] <- 1
        }else{
          x[i] <- 0
        }
      }
      total <- sum(x)
      return(total) 
    }
    total_subtotals <- tapply(0:5, as.factor(0:5), total_calculation)
    total <- sum(total_subtotals)
    result <- (present/total)*100
    return(result)
  }
  PCT_MIAT1.result <- round(tapply(microalgae$VariableResult, microalgae$id, FUN_PCT_MIAT1))
  PCT_MIAT1.count <- tapply(microalgae$VariableResult, microalgae$id, function(x){
    return(sum(x %in% c('0','1','2','3','4','5')))
  })
  
  
  ###Compute PCT_MIAT1P###
  
  FUN_PCT_MIAT1P <- function(data){
    x <- {1:length(data)}
    present_calculation <- function(number){
      for(i in 1:length(data)){
        if(data[i] == number ){
          x[i] <- 1
        }else{
          x[i] <- 0
        }
      }
      present <- sum(x)
      return(present) 
    }
    present_subtotals <- tapply(3:5, as.factor(3:5), present_calculation)
    present <- sum(present_subtotals)
    
    total_calculation <- function(number){
      for(i in 1:length(data)){
        if(data[i] == number ){
          x[i] <- 1
        }else{
          x[i] <- 0
        }
      }
      total <- sum(x)
      return(total) 
    }
    total_subtotals <- tapply(1:5, as.factor(1:5), total_calculation)
    total <- sum(total_subtotals)
    result <- (present/total)*100
    return(result)
  }
  PCT_MIAT1P.result <- round(tapply(microalgae$VariableResult, microalgae$id, FUN_PCT_MIAT1P))
  PCT_MIAT1P.result[is.na(PCT_MIAT1P.result)] <- 0
  PCT_MIAT1P.count <- tapply(microalgae$VariableResult, microalgae$id, function(x){
    return(sum(x %in% c('1','2','3','4','5')))
  })
  
  ###Convert data values for XMIAT and XMIATP###
  XMIAT_data <- microalgae$VariableResult
  XMIAT_data <- as.character(XMIAT_data)
  XMIAT_data <- dplyr::case_when(
    XMIAT_data == '1' ~ '0.25',
    XMIAT_data == '2' ~ '0.5',
    XMIAT_data == '4' ~ '12.5',
    XMIAT_data == '5' ~ '20', 
    !XMIAT_data %in% c('0', '0.25', '0.5', '3', '12.5', '20') ~ NA_character_, 
    TRUE ~ XMIAT_data
  )
  XMIAT_data <- as.numeric(XMIAT_data)
  XMIAT_frame <- microalgae
  XMIAT_frame$result <- XMIAT_data
  
  ###Compute XMIAT###
  
  XMIAT_countss <- function(data){
    XMIAT_count <- sum(!is.na(data))
    return(XMIAT_count)	
  }
  XMIAT_meanss <- function(data){
    XMIAT_count <- sum(!is.na(data))
    XMIAT_mean <- mean(data, na.rm=TRUE)
    return(XMIAT_mean)	
  }
  XMIAT_SDSs <- function(data){
    XMIAT_SD <- round(sd(data, na.rm=TRUE), 2)
    return(XMIAT_SD)
  }
  XMIAT_countst <- tapply(XMIAT_frame$result, XMIAT_frame$id, XMIAT_countss)
  XMIAT_meanst <- round(tapply(XMIAT_frame$result, XMIAT_frame$id, XMIAT_meanss), 1)
  XMIAT_sdst <- tapply(XMIAT_frame$result, XMIAT_frame$id, XMIAT_SDSs)
  
  XMIAT <- cbind(XMIAT_meanst, XMIAT_countst, XMIAT_sdst)
  colnames(XMIAT) <- c("XMIAT.result", "XMIAT.count", "XMIAT.sd")
  
  ###Compute XMIATP###
  
  XMIATP_countss <- function(data){
    XMIATP_count<- sum(!is.na(data))-length(which(data == 0))
    return(XMIATP_count)	
  }
  XMIATP_meanss <- function(data){
    XMIATP_count <- sum(!is.na(data))-length(which(data == 0))
    XMIATP_mean<- sum(data, na.rm=TRUE)/XMIATP_count
    if(XMIATP_mean == "NaN"){XMIATP_mean <- 0}
    return(XMIATP_mean)	
  }
  XMIATP_SDSs <- function(data){
    XMIATP_SD <- round(sd(data[which(data != 0)], na.rm=TRUE), 2)
    return(XMIATP_SD)
  }
  XMIATP_countst <- tapply(XMIAT_frame$result, XMIAT_frame$id, XMIATP_countss)
  XMIATP_meanst <- round(tapply(XMIAT_frame$result, XMIAT_frame$id, XMIATP_meanss), 1)
  XMIATP_sdst <- tapply(XMIAT_frame$result, XMIAT_frame$id, XMIATP_SDSs)
  
  XMIATP <- cbind(XMIATP_meanst, XMIATP_countst, XMIATP_sdst)
  colnames(XMIATP) <- c("XMIATP.result", "XMIATP.count", "XMIATP.sd")
  XMIATP
  
  ###Slice for macrophyte cover data###
  
  macrophyte_cover <- data.frame(cbind(data$id[which(data$AnalyteName == 'Macrophyte Cover')], as.character(data$VariableResult[which(data$AnalyteName == 'Macrophyte Cover')])))
  colnames(macrophyte_cover) <- c("id", "VariableResult")
  
  
  ###Compute PCT_MCP###
  
  PCT_MCP_stats <- function(data){
    present <- length(which(data == "Present"))
    total <- length(which(data == "Present"))+
      length(which(data == "Absent"))
    result <- (present/total)*100
    return(result)
  }
  PCT_MCP.result <- tapply(macrophyte_cover$VariableResult, macrophyte_cover$id, PCT_MCP_stats) %>% round
  PCT_MCP.count <- tapply(macrophyte_cover$VariableResult, macrophyte_cover$id, function(data){
    present <- length(which(data == "Present"))
    total <- length(which(data == "Present")) + length(which(data == "Absent"))
    return(total)
  })
  
  
  ###Call macrophyte cover attached data###
  macroalgae_cover_attached <- data.frame(cbind(data$id[which(data$AnalyteName == 'Macroalgae Cover, Attached')], as.character(data$VariableResult[which(data$AnalyteName == 'Macroalgae Cover, Attached')])))
  colnames(macroalgae_cover_attached) <- c("id", "VariableResult")
  
  ###Compute PCT_MAA###
  
  PCT_MAA_stats <- function(data){
    present <- length(which(data == "Present"))
    total <- length(which(data == "Present"))+
      length(which(data == "Absent"))
    result <- (present/total)*100
    return(result)
  }
  PCT_MAA.result <- tapply(macroalgae_cover_attached$VariableResult, macroalgae_cover_attached$id, PCT_MAA_stats) %>% round
  PCT_MAA.count <- tapply(macroalgae_cover_attached$VariableResult, macroalgae_cover_attached$id, function(data){
    present <- length(which(data == "Present"))
    total <- length(which(data == "Present")) + length(which(data == "Absent"))
    return(total)
  })
  
  ###Call macrophyte cover unattached data###
  macroalgae_cover_unattached <- data.frame(cbind(data$id[which(data$AnalyteName == 'Macroalgae Cover, Unattached')], as.character(data$VariableResult[which(data$AnalyteName == 'Macroalgae Cover, Unattached')])))
  colnames(macroalgae_cover_unattached) <- c("id", "VariableResult")
  
  ###Compute PCT_MAU###
  
  PCT_MAU_stats <- function(data){
    present <- length(which(data == "Present"))
    total <- length(which(data == "Present"))+
      length(which(data == "Absent"))
    result <- (present/total)*100
    return(result)
  }
  PCT_MAU.result <- tapply(macroalgae_cover_unattached$VariableResult, macroalgae_cover_unattached$id, PCT_MAA_stats) %>% round
  PCT_MAU.count <- tapply(macroalgae_cover_unattached$VariableResult, macroalgae_cover_unattached$id, function(data){
    present <- length(which(data == "Present"))
    total <- length(which(data == "Present")) + length(which(data == "Absent"))
    return(total)
  })
  
  ###Compute PCT_MAP###

  colnames(macroalgae_cover_unattached)<- c("id", "VariableResult2")
  macroalgae_cover <- cbind(macroalgae_cover_unattached, macroalgae_cover_attached$VariableResult)
  colnames(macroalgae_cover) <- c("id", "unattached", "attached")
  
  macroalgae_cover$PCT_MAP <- 1:length(macrophyte_cover$id)
  for(i in 1:length(macrophyte_cover$id)){
    if(((macroalgae_cover$unattached[i] == "Present")|(macroalgae_cover$attached[i] == "Present"))){macroalgae_cover$PCT_MAP[i] <- "Present"} else
      if (((macroalgae_cover$unattached[i] == "Absent")&(macroalgae_cover$attached[i] == "Absent"))) {macroalgae_cover$PCT_MAP[i] <- "Absent"
      }
  }
  
  PCT_MAP_stats <- function(data){
    present <- length(which(data=="Present"))
    total <- length(which(data=="Absent"))+present
    result <- 100*(present/total)
    return(result)
  }
  PCT_MAP.result <- tapply(macroalgae_cover$PCT_MAP, macroalgae_cover$id, PCT_MAP_stats) %>% round
  PCT_MAP.count <- tapply(macroalgae_cover$PCT_MAP, macroalgae_cover$id, function(x){
    return(length(which(x %in% c('Present','Absent'))))
  })
  print("PCT_MAP.count")
  print(PCT_MAP.count)
  
  ###Compute PCT_NSA###
  
  macroalgae_cover$PCT_NSA_characters <- as.character(microalgae$VariableResult)
  
  for(i in 1:length(microalgae$VariableResult)){
    if(microalgae$VariableResult[i] == "3"){macroalgae_cover$PCT_NSA_characters[i] <- "Present"} else
      if(microalgae$VariableResult[i] == "4"){macroalgae_cover$PCT_NSA_characters[i] <- "Present"} else
        if(microalgae$VariableResult[i] == "5"){macroalgae_cover$PCT_NSA_characters[i] <- "Present"} else
          if(microalgae$VariableResult[i] == "0"){macroalgae_cover$PCT_NSA_characters[i] <- "Absent"} else
            if(microalgae$VariableResult[i] == "1"){macroalgae_cover$PCT_NSA_characters[i] <- "Absent"} else
              if(microalgae$VariableResult[i] == "2"){macroalgae_cover$PCT_NSA_characters[i] <- "Absent"} 
  }
  macroalgae_cover$PCT_NSA <- 1:length(macrophyte_cover$id)
  for(i in 1:length(macrophyte_cover$id)){
    if(((macroalgae_cover$PCT_MAP[i] == "Present")|(macroalgae_cover$PCT_NSA_characters[i] == "Present"))){macroalgae_cover$PCT_NSA[i] <- "Present"} else
      if (((macroalgae_cover$PCT_MAP[i] == "Absent")&(macroalgae_cover$PCT_NSA_characters[i] == "Absent"))) {macroalgae_cover$PCT_NSA[i] <- "Absent"
      }
  }
  PCT_NSA_sum <- function(data){
    result <- length(which(data=="Present"))
    return(result)}
  
  macroalgae_cover$PCT_NSA_total <- 1:length(macroalgae_cover$id)
  for(i in 1:length(macroalgae_cover$id)){
    if(macroalgae_cover$unattached[i] == "Dry"){macroalgae_cover$PCT_NSA_total[i] <- "blank"} else{
      if(macroalgae_cover$unattached[i] == "Not Recorded"){macroalgae_cover$PCT_NSA_total[i] <- "blank"} else{
        if(macroalgae_cover$attached[i] == "Not Recorded"){macroalgae_cover$PCT_NSA_total[i] <- "blank"} else{
          if(macroalgae_cover$attached[i] == "Dry"){macroalgae_cover$PCT_NSA_total[i] <- "blank"} else{
            if(macroalgae_cover$PCT_NSA_characters[i] == "Dry"){macroalgae_cover$PCT_NSA_total[i] <- "blank"} else{		
              if(macroalgae_cover$PCT_NSA_characters[i] == "Not Recorded"){macroalgae_cover$PCT_NSA_total[i] <- "blank"}}}}}}}
  
  PCT_NSA_total <- function(data){
    result <- length(which(data != "blank"))
    return(result)}
  
  PCT_NSA_sums <- tapply(macroalgae_cover$PCT_NSA, macroalgae_cover[[1]], PCT_NSA_sum)
  PCT_NSA_totals <- tapply(macroalgae_cover$PCT_NSA_total, macroalgae_cover[[1]], PCT_NSA_total)
  PCT_NSA.result <- round((PCT_NSA_sums/PCT_NSA_totals)*100)
  PCT_NSA.count <- PCT_NSA_totals
  
  
  
  ###Write the results to file###
  
  algae_results1 <- cbind(PCT_MIATP.result, PCT_MIAT1.result, PCT_MIAT1P.result, PCT_MAA.result, PCT_MCP.result,
                          PCT_MAU.result, PCT_MAP.result, PCT_NSA.result, PCT_MAA.count, PCT_MAU.count, PCT_MCP.count, 
                          PCT_MAP.count, PCT_NSA.count, PCT_MIAT1.count, PCT_MIAT1P.count, PCT_MIATP.count)
  algae_results_final <- cbind(XMIAT, XMIATP, algae_results1)
  
  #results$PCT_MIAT1 <- round(results$PCT_MIAT1)
  #results$PCT_MIAT1P <- round(results$PCT_MIAT1P)
  #results$XMIAT <- round(results$XMIAT, 1)
  #results$XMIATP <- round(results$XMIATP, 1)
  
    
  return(algae_results_final)
}
