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
  print("Algae")
  data <- data[which(data$AnalyteName %in% c('Microalgae Thickness', 'Macrophyte Cover', 'Macroalgae Cover, Attached', 'Macroalgae Cover, Unattached')),]
  
  lengthna <- function(x){
    return(sum(!is.na(x)))
  }
  
  ###Slice for microalgae###
  microalgae <- data.frame(cbind(data$id[which(data$AnalyteName == 'Microalgae Thickness')], 
                                 as.character(data$VariableResult[which(data$AnalyteName == 'Microalgae Thickness')])))
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
 
  # Code below should fix the counts for PCT_MAP
  PCT_MAP.count <- data %>% 
    dplyr::filter(
      grepl('Macroalgae Cover, ', AnalyteName),
      VariableResult %in% c("Present", "Absent")
   ) %>% 
    dplyr::group_by(id) %>% 
    dplyr::summarize(
      PCT_MAP.count = length(unique(LocationCode))
    ) %>% 
    as.data.frame %>% 
    tibble::column_to_rownames('id')
  
  PCT_MAP <- data %>%
    dplyr::filter(
      grepl('Macroalgae Cover, ', AnalyteName),
      VariableResult %in% c("Present", "Absent")
    ) %>% 
    dplyr::group_by(id) %>% 
    tidyr::nest() %>%
    dplyr::mutate(
      PCT_MAP.count = purrr::map(data, function(df){
        return(length(unique(df$LocationCode)))
      }),
      PCT_MAP.result = purrr::map(data, function(df){
        number_present <- df[df$VariableResult == 'Present',]$LocationCode %>% unique %>% length
        return(round( (100 * number_present) / length(unique(df$LocationCode))))
      })
    ) %>% 
    dplyr::select(-data) %>%
    tidyr::unnest() %>%
    as.data.frame %>%
    tibble::column_to_rownames('id')
    

  ###Compute PCT_NSA###
  
  
  PCT_NSA <- data %>%
    dplyr::filter(AnalyteName %in% c('Microalgae Thickness','Macroalgae Cover, Unattached','Macroalgae Cover, Attached')) %>%
    dplyr::group_by(id) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      PCT_NSA.count = purrr::map(data, function(df){
        df <- df %>% 
          group_by(LocationCode) %>%
          dplyr::summarize(
            total_count = case_when(
              length(intersect(VariableResult, c('Present', 'Absent','0','1','2','3','4','5'))) > 0 ~ T,
              TRUE ~ F
            )
          )
        return(sum(df$total_count))
      }),
      PCT_NSA.present = purrr::map(data, function(df){
        df <- df %>%
          dplyr::filter(
            VariableResult %in% c('Present','3','4','5')
          )
        return(df$LocationCode %>% unique %>% length)
      })
    ) %>% 
    dplyr::select(-data) %>%
    tidyr::unnest() %>%
    dplyr::mutate(
      PCT_NSA.result = (100 * PCT_NSA.present / PCT_NSA.count) %>% round
    ) %>% 
    select(-PCT_NSA.present) %>%
    as.data.frame %>%
    tibble::column_to_rownames('id')
  
  
  ###Write the results to file###
  
  algae_results1 <- cbind(PCT_MIATP.result, PCT_MIAT1.result, PCT_MIAT1P.result, PCT_MAA.result, PCT_MCP.result,
                          PCT_MAU.result, PCT_MAA.count, PCT_MAU.count, PCT_MCP.count, 
                          PCT_MIAT1.count, PCT_MIAT1P.count, PCT_MIATP.count)
  algae_results_final <- cbind(XMIAT, XMIATP, algae_results1)
  
  algae_results_final <- merge(algae_results_final, PCT_MAP, by = 'row.names') %>%
    as.data.frame %>%
    tibble::column_to_rownames('Row.names') %>%
    merge(PCT_NSA, by = 'row.names') %>%
    as.data.frame %>%
    tibble::column_to_rownames('Row.names')

  print("End Algae")
  return(algae_results_final)
}
