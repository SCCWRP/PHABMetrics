#' Channel sinuosity metrics
#'
#' @param data Input data
#' 
#' @export
#' 
#' @examples 
#' sampdat <- phabformat(sampdat)
#' channelsinuosity(sampdat)
channelsinuosity <- function(data){

  data <- data[which(data$AnalyteName %in% c('Slope', 'Length, Segment', 'Elevation Difference', 'Bearing', 'Proportion', 'Length, Reach')),]
  
  # XSLOPE data ----------------------------------------------------------------------------------
  data_slope <- data %>%
    dplyr::group_by(id) %>%
    arrange(id) %>% 
    dplyr::mutate(
      Result = dplyr::case_when(
        AnalyteName == 'Proportion' ~ Result/100, # convert % to proportion
        AnalyteName == 'Elevation Difference' ~ Result/100,
        TRUE ~ Result
      )
    ) %>% 
    select(id, LocationCode, AnalyteName, Result, FractionName) %>% 
    group_by(id, LocationCode, AnalyteName, FractionName) %>% 
    mutate(grouped_id = row_number()) %>%
    spread(AnalyteName, Result) %>% 
    mutate(
      Slope = if_else(is.na(Slope), `Elevation Difference`/`Length, Segment` * 100, Slope)
    ) %>% 
    mutate(
      p_slope = Slope * Proportion
    )
    
  ## XSLOPE calculation --------------------------------------------------------------------------
  XSLOPE <- data_slope %>% 
    group_by(id, LocationCode) %>% 
    summarize(p_slope = sum(p_slope)) %>% 
    group_by(id) %>% 
    summarize(
      XSLOPE.count = sum(na.omit(p_slope) <= 0),
      XSLOPE.result = mean(p_slope, na.rm = T),
      XSLOPE.sd = sd(p_slope, na.rm = T),
      SLOPE_0.count = length(na.omit(p_slope) <= 0)
    )
    
  ## SLOPE_pcnt calculation -------------------------------------------------------------------------
  SLOPE_pcnt <- data_slope %>% 
    group_by(id) %>% 
    mutate(
      slope_0   = p_slope <= 0,
      slope_0_5 = p_slope <= 0.5,
      slope_1   = p_slope <= 1,
      slope_2   = p_slope <= 2
    ) %>% 
    summarize(
      SLOPE_0.count = sum(slope_0),
      SLOPE_0_5.count = sum(slope_0_5),
      SLOPE_1.count = sum(slope_1),
      SLOPE_2.count = sum(slope_2),
      SLOPE_0.result = sum(`Length, Segment`[slope_0])/sum(`Length, Segment`) * 100,
      SLOPE_0_5.result = sum(`Length, Segment`[slope_0_5])/sum(`Length, Segment`) * 100,
      SLOPE_1.result = sum(`Length, Segment`[slope_1])/sum(`Length, Segment`) * 100,
      SLOPE_2.result = sum(`Length, Segment`[slope_2])/sum(`Length, Segment`) * 100
    )
  
  ###XBEARING###
  
  data_bearing <- data %>%
    dplyr::group_by(id) %>%
    arrange(id) %>% 
    dplyr::mutate(
      Result = dplyr::case_when(
        AnalyteName == 'Proportion' ~ Result/100, # convert % to proportion
        TRUE ~ Result
      )
    ) %>% 
    dplyr::select(-c('MethodName','Replicate','UnitName')) %>% 
    dplyr::group_by(id, LocationCode, FractionName) %>%
    tidyr::spread(AnalyteName, Result) %>%
    dplyr::mutate(
      Proportion_x_Bearing = `Proportion` * `Bearing`
    ) %>% 
    dplyr:: group_by(id, LocationCode) %>%
    dplyr::summarize(
      total_proportion = sum(Proportion, na.rm = T),
      total_bearing = sum(Proportion_x_Bearing, na.rm = T)
    ) %>%
    dplyr::group_by(id) %>%
    dplyr::summarize(
      XBEARING.result = round(sum(total_bearing, na.rm = T) / sum(total_proportion == 1, na.rm = T) ),
      XBEARING.count = sum(total_proportion == 1),
      XBEARING.sd = sd(total_bearing[total_proportion == 1], na.rm = T) %>% round(1)
    )
    
  return(data_bearing)
  
  ###SINU###
  
  cos1 <- function(i, Segment, Bearing){(Segment[i] * cos((Bearing[i]/360)*2*pi))}
  sin1 <- function(i, Segment, Bearing){(Segment[i] * sin((Bearing[i]/360)*2*pi))}
  
  #cast(data, id + FractionName ~ AnalyteName, value = "Result", fun.aggregate=mean)
  casted$cos <- unlist(lapply(1:length(casted$Segment), Segment=casted$Segment, FUN=cos1, Bearing = casted$Bearing))
  casted$sin <- unlist(lapply(1:length(casted$Segment), Segment=casted$Segment, FUN=sin1, Bearing = casted$Bearing))
  
  
  distance <- tapply(casted$Segment, casted$id, sumna)
  sin2 <- tapply(casted$sin, casted$id, sumna)
  cos2 <- tapply(casted$cos, casted$id, sumna)
  casted$ttt <- unlist(lapply(1:length(casted$id), function(i, si, co) 2*si[i], si=casted$sin, co=casted$cos))
  SINU.NOT_WORKING <- distance/(tapply(casted$ttt, casted$id, sumna))
  
  ###Write to file###
  
  result <- cbind(XSLOPE.result, XSLOPE.count, XSLOPE.sd, SLOPE_0.result, SLOPE_0.count, SLOPE_0_5.result,
                  SLOPE_0_5.count, SLOPE_1.result, SLOPE_1.count, SLOPE_2.result, SLOPE_2.count, XBEARING.result, XBEARING.count, XBEARING.sd, SINU.NOT_WORKING)

  return(result)
  
}
