#' Bank morphology metrics
#'
#' @param data Input data
#' 
#' @export
#' 
#' @importFrom magrittr "%>%"
#' 
#' @examples 
#' sampdat <- phabformat(sampdat)
#' bankmorph(sampdat)
bankmorph <- function(data){
  print("bankmorph")
  data <- data[which(data$AnalyteName %in% c('Bankfull Height', 'Bankfull Width', 'StationWaterDepth', 'Wetted Width')),]
  data <- data[which(!(data$LocationCode == "X")),]
  data$Result[data$Result == -88] <- NA
  ###Slice Bankfull Height Data ###
  
  heightindex <- which(data$AnalyteName == "Bankfull Height")
  bankfullheight <- data.frame(
    cbind(
      data$id[heightindex],
      as.character(data$AnalyteName[heightindex]),
      as.character(data$Result[heightindex])
      )
    )
  colnames(bankfullheight) <- c("id", "AnalyteName", "result")
  bankfullheight$result <- as.numeric(as.character(bankfullheight$result))
  head(bankfullheight)
  
  ###Compute XBKF_H###
  sumna <- function(data){
    sum(as.numeric(as.character(data)), na.rm = T)
  }
  XBKF_sum <- tapply(bankfullheight$result, bankfullheight$id, sumna)
  lengthna <- function(data){
    sum(!is.na(data))
  }
  XBKF_H.count <- tapply(bankfullheight$result, bankfullheight$id, lengthna)
  XBKF_H.result <- round(XBKF_sum/XBKF_H.count,1)
  sdna <- function(data){
    sd(data, na.rm = T)
  }
  XBKF_H.sd <- round(tapply(as.numeric(bankfullheight$result), bankfullheight$id, sdna), 2)
  XBKF_H <- data.frame(cbind(XBKF_H.result, XBKF_H.count, XBKF_H.sd))
  
  ###Slice Bankfull Width###
  
  widthindex <- which(data$AnalyteName == "Bankfull Width")
  bankfullwidth <- data.frame(cbind(data$id[widthindex], as.character(data$AnalyteName[widthindex]),
                                    as.character(data$Result[widthindex])))
  colnames(bankfullwidth) <- c("id", "AnalyteName", "result")
  bankfullwidth$result <- as.numeric(as.character(bankfullwidth$result))

  ###Compute XBKF_W###
  
  XBKF_W_sum <- tapply(bankfullwidth$result, bankfullwidth$id, sumna)
  XBKF_W.count <- tapply(bankfullwidth$result, bankfullwidth$id, lengthna)
  XBKF_W.result <- round(XBKF_W_sum/XBKF_W.count,1)
  XBKF_W.sd <- round(tapply(as.numeric(bankfullwidth$result), bankfullwidth$id, sdna), 2)
  XBKF_W <- data.frame(cbind(XBKF_W.result, XBKF_W.count, XBKF_W.sd))
  
  ###XWDEPTH###
  XWDEPTHdata <- data %>% 
    filter(
      AnalyteName == 'StationWaterDepth',
      MethodName == 'FieldMeasure'
    ) %>%
    select(
      id, Result
    )
                            
  colnames(XWDEPTHdata) <- c("id", "result")
  XWDEPTH_sum <- tapply(XWDEPTHdata$result, XWDEPTHdata$id, sumna)
  XWDEPTH.count <- tapply(XWDEPTHdata$result, XWDEPTHdata$id, lengthna)
  XWDEPTH.result <- round(XWDEPTH_sum/XWDEPTH.count, 1)
  XWDEPTH.sd <- round(tapply(as.numeric(as.character(XWDEPTHdata$result)), XWDEPTHdata$id, sdna), 2)
  
  ###XWIDTH###
  
  XWIDTHdata <- data %>%
    filter(
      AnalyteName == 'Wetted Width',
      MethodName == 'FieldMeasure'
    ) %>%
    select(
      id, Result
    )
  # Just because I don't know how many other times he references the column 'result' with lowercase r in the script
  # This below line was in the code before
  colnames(XWIDTHdata) <- c("id", "result")
  
  XWIDTH_sum <- tapply(XWIDTHdata$result, XWIDTHdata$id, sumna)
  XWIDTH.count <- tapply(XWIDTHdata$result, XWIDTHdata$id, lengthna)
  XWIDTH.result <- round(XWIDTH_sum/XWIDTH.count, 1)
  
  # print("XWIDTHdata")
  # print(XWIDTHdata %>% dplyr::filter(grepl('404M07362',id)))
  XWIDTH.sd <- tapply(as.numeric(as.character(XWIDTHdata$result)), XWIDTHdata$id, sdna) %>% round(2)
  # print("XWIDTH.sd")
  # print(XWIDTH.sd)
  ###XWDR###
  
  XWDR.result <- (XWIDTH.result/XWDEPTH.result)*100
  XWDR.count<- XWIDTH.count
  ###XWDA###
  
  XWDA.result <- XWDEPTH.result/(XWIDTH.result*10)
  XWDA.count <- XWDEPTH.count
  ###XWDM###

  data$LocationCode2 <- gsub("Tran.(\\w)", "\\1", data$LocationCode)

  ll <- c( ", LCtr" , ", Ctr" , ", RCtr",
           ", Right", ", Left")
  for(i in 1:length(ll)){
    data$LocationCode2 <-gsub(ll[i], "", data$LocationCode2)}
  data$Result <- as.numeric(as.character(data$Result))
  XWDM <- data %>% 
    dplyr::filter(AnalyteName == 'StationWaterDepth', MethodName == 'FieldMeasure') %>% 
    dplyr::group_by(id, LocationCode2) %>% 
    dplyr::summarize(Result = max(Result, na.rm = T)) %>% 
    dplyr::group_by(id) %>% 
    tidyr::nest() %>%
    dplyr::mutate(
      XWDM.count = purrr::map(data, function(df){
        sum(!is.na(df$Result))
      }),
      XWDM.result = purrr::map(data, function(df){
        round(mean(df$Result, na.rm = T), 1)
      }),
      XWDM.sd = purrr::map(data, function(df){
        round(sd(df$Result, na.rm = T), 1)
      })
    ) %>% dplyr::select(-data) %>% tidyr::unnest() %>% as.data.frame %>% tibble::column_to_rownames('id')
  
  
  
  ###Write to file###
  results <- cbind(XBKF_H.result, XBKF_H.count, XBKF_H.sd, XBKF_W.result, XBKF_W.count, XBKF_W.sd, XWDEPTH.result, 
                   XWDEPTH.count, XWDEPTH.sd, XWIDTH.result, XWIDTH.count, XWIDTH.sd, XWDR.result, XWDR.count, 
                   XWDA.result, XWDA.count)
  results <- merge(results, XWDM, by = 'row.names') %>% tibble::column_to_rownames('Row.names')
  print("End bankmorph")
  return(results)
}
