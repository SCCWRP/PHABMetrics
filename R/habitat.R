#' Habitat metrics
#'
#' @param data Input data
#' 
#' @export
#' 
#' @examples 
#' habitat(sampdat)
habitat <- function(data){
  data <- data[which(data$AnalyteName %in% c('Fish Cover Macrophytes', 'Fish Cover Artificial Structures', 'Fish Cover Boulders', 'Fish Cover Filamentous Algae', 'Fish Cover Woody Debris >0.3 m', 'Fish Cover Live Trees/Roots', 'Fish Cover Overhang.Veg', 'Fish Cover Woody Debris <0.3 m', 'Fish Cover Undercut Banks')),]
  
  data$convert <- dplyr::case_when(
    
    data$VariableResult == '1' ~ '5', 
    data$VariableResult == '2' ~ '25', 
    data$VariableResult == '3' ~ '57.5', 
    data$VariableResult == '4' ~ '87.5', 
    data$VariableResult == 'Not Recorded' ~ NA_character_, 
    TRUE ~ data$VariableResult
    
  )
  
  ###Compute Stats
  analytes <- c("Fish Cover Macrophytes", "Fish Cover Artificial Structures", "Fish Cover Boulders",
                "Fish Cover Filamentous Algae", "Fish Cover Woody Debris >0.3 m", 
                "Fish Cover Live Trees/Roots", "Fish Cover Overhang.Veg", "Fish Cover Woody Debris <0.3 m",
                "Fish Cover Undercut Banks")
  statname <- c("XFC_AQM",  "XFC_HUM",  "XFC_RCK",  "XFC_ALG",	"XFC_LWD",
                "XFC_LTR",	"XFC_OHV",	"XFC_BRS",	"XFC_UCB",	
                "XFC_BIG.result",	"XFC_NAT_EMAP.result",	"XFC_NAT_SWAMP.result",	
                "CFC_AQM.result",	"CFC_HUM.result",	"CFC_RCK.result",	"CFC_ALG.result",	"CFC_LWD.result",
                "CFC_LTR.result",	"CFC_OHV.result",	"CFC_BRS.result",	"CFC_UCB.result",	
                "CFC_ALL_EMAP.result",	"CFC_ALL_SWAMP.result")
  
  result <- matrix(NA, nrow=length(unique(data$id)), 
                   ncol=((length(statname[1:9])*3)+length(statname[10:23])))
  result <- as.data.frame(result)
  rownames(result) <- unique(data$id)
  snames <- paste(rep(statname[1:9], each=3), c(".result", ".count", ".sd"), sep="")
  colnames(result) <- c(snames, statname[10:23])
  
  sumna <- function(data){sum(data, na.rm=T)}
  lengthna <- function(data){sum(!is.na(data))}
  
  data$convert <- as.numeric(data$convert)
  
  for(i in 1:9){
    analyte <- subset(data, data$AnalyteName == analytes[i])
    analytesum <- tapply(analyte$convert, analyte$id, sumna)
    analytesum <- analytesum[rownames(result)]
    analytetotal <- tapply(analyte$convert, analyte$id, lengthna)
    analytetotal <- analytetotal[rownames(result)]
    analytemean <- analytesum/analytetotal
    analytesd <- round(tapply(analyte$convert, analyte$id, sd), 1)
    analytesd <- analytesd[rownames(result)]
    result[[((i-1)*3)+1]] <- round(analytemean, 1)
    result[[((i-1)*3)+2]] <- analytetotal
    result[[((i-1)*3)+3]] <- analytesd
  }

  result$XFC_BIG.result <-  result$XFC_LWD.result + result$XFC_RCK.result + 
    result$XFC_UCB.result + result$XFC_HUM.result
  
  result$XFC_BIG.count <- rowSums(!is.na(result[,c('XFC_LWD.result','XFC_RCK.result','XFC_UCB.result','XFC_HUM.result')]))
  
  result$XFC_NAT_EMAP.result <- result$XFC_LWD.result + result$XFC_BRS.result +
    result$XFC_OHV.result + result$XFC_RCK.result + result$XFC_UCB.result
  
  result$XFC_NAT_EMAP.count <- rowSums(!is.na(result[,c('XFC_LWD.result','XFC_BRS.result','XFC_OHV.result','XFC_RCK.result','XFC_UCB.result')]))
  
  result$XFC_NAT_SWAMP.result <- result$XFC_LWD.result + result$XFC_BRS.result +
    result$XFC_OHV.result + result$XFC_RCK.result + result$XFC_UCB.result +
    result$XFC_LTR.result + result$XFC_AQM.result
  
  result$XFC_NAT_SWAMP.count <- rowSums(!is.na(result[,c('XFC_LWD.result','XFC_BRS.result','XFC_OHV.result','XFC_RCK.result','XFC_UCB.result','XFC_LTR.result','XFC_AQM.result')]))
  

  data$present <- ifelse(data$VariableResult %in% c('1', '2', '3', '4'), TRUE, FALSE)
  
  for(i in 1:9){
    analyte <- subset(data, data$AnalyteName == analytes[i])
    analytesum <- tapply(analyte$present, analyte$id, sumna)
    analytesum <- analytesum[rownames(result)]
    result[[i+30]] <- analytesum
  }
  
  t <- result[,c("XFC_AQM.result", "XFC_HUM.result", "XFC_RCK.result", "XFC_ALG.result", "XFC_LWD.result", "XFC_OHV.result", "XFC_BRS.result", "XFC_UCB.result")]
  result$CFC_ALL_EMAP.result <- rowSums((t>0), na.rm=T)
  result$CFC_ALL_EMAP.count <- rowSums(!is.na(t))
  
  q <- result[,c("XFC_LTR.result", "XFC_AQM.result", "XFC_HUM.result", "XFC_RCK.result", "XFC_ALG.result", "XFC_LWD.result", "XFC_OHV.result", "XFC_BRS.result", "XFC_UCB.result")]
  result$CFC_ALL_SWAMP.result <- rowSums((q>0), na.rm=T)
  result$CFC_ALL_SWAMP.count <- rowSums(!is.na(q))

  # H_AqHab, Ev_AqHab
  AqHab <- data %>% 
    dplyr::select(id, AnalyteName, convert) %>% 
    tidyr::unnest() %>% 
    dplyr::group_by(id) %>% 
    tidyr::nest() %>% 
    dplyr::mutate(
      H_AqHab.result = purrr::map(data, function(data){
        
        # step 2
        sms <- data %>% 
          dplyr::group_by(AnalyteName) %>% 
          dplyr::summarise(convert = sumna(convert)) %>%
          dplyr::filter(AnalyteName != "Fish Cover Artificial Structures")
        
        # step 3
        smgrz <- sum(sms$convert, na.rm = T)
        
        # step 4
        smspi <- sms$convert / smgrz
        
        # step 5
        smspimlt <- smspi * log(smspi)
        
        # step 6
        res <- sum(smspimlt, na.rm = T) * -1
        
        return(res)
        
      }
      ),
      H_AqHab.count = purrr::map(data, function(data){
        
        # number of analytes that were recorded (non NA)
        cnt <- data %>% 
          dplyr::group_by(AnalyteName) %>% 
          dplyr::summarise(convert = sumna(convert)) %>% 
          dplyr::filter(convert > 0) %>%
          dplyr::filter(AnalyteName != "Fish Cover Artificial Structures") %>%
          nrow()
        
        return(cnt)
        
      }),
      Ev_AqHab.result = purrr::pmap(list(H_AqHab.count, H_AqHab.result), function(H_AqHab.count, H_AqHab.result){
        
        if (H_AqHab.count > 1) {
          return(H_AqHab.result / log(H_AqHab.count))
        } else {
          return(0)
        }

      }),
      Ev_AqHab.count = H_AqHab.count
    ) %>% 
    dplyr::select(-data) %>% 
    tidyr::unnest() %>% 
    as.data.frame(stringsAsFactors = F) %>% 
    tibble::column_to_rownames('id')

  # add H_AqHab, Ev_AqHab to results
  result$H_AqHab.result <- round(AqHab$H_AqHab.result, 2)
  result$H_AqHab.count <- AqHab$H_AqHab.count
  result$Ev_AqHab.result <- round(AqHab$Ev_AqHab.result, 2)
  result$Ev_AqHab.count <- AqHab$Ev_AqHab.count
    
  counts <- data %>% 
  dplyr::filter(AnalyteName == 'Fish Cover Macrophytes') %>%
  dplyr::group_by(id) %>%
  tidyr::nest() %>%
  dplyr::mutate(
    CFC_ALG.count = purrr::map(data, function(df){
      sum(!is.na(df$VariableResult))
    }),
    CFC_AQM.count = purrr::map(data, function(df){
      sum(!is.na(df$VariableResult))
    }),
    CFC_BRS.count = purrr::map(data, function(df){
      sum(!is.na(df$VariableResult))
    }),
    CFC_HUM.count = purrr::map(data, function(df){
      sum(!is.na(df$VariableResult))
    }),
    CFC_LTR.count = purrr::map(data, function(df){
      sum(!is.na(df$VariableResult))
    }),
    CFC_LWD.count = purrr::map(data, function(df){
      sum(!is.na(df$VariableResult))
    }),
    CFC_OHV.count = purrr::map(data, function(df){
      sum(!is.na(df$VariableResult))
    }),
    CFC_RCK.count = purrr::map(data, function(df){
      sum(!is.na(df$VariableResult))
    }),
    CFC_UCB.count = purrr::map(data, function(df){
      sum(!is.na(df$VariableResult))
    })
  ) %>% dplyr::select(-data) %>%
  tidyr::unnest() %>%
  as.data.frame %>%
  tibble:: column_to_rownames('id')

  result <- merge(result, counts, by='row.names') %>% tibble::column_to_rownames('Row.names')
  
  return(result)
  
}
