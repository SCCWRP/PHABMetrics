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
  # We believe that SWAMP was mistakenly counting fractions as if they were unique locations, thus throwing off the 
  #  value for XSLOPE.count
  XSLOPE <- data_slope %>% 
    group_by(id, LocationCode) %>% 
    summarize(p_slope = sum(p_slope)) %>% 
    group_by(id) %>% 
    summarize(
      XSLOPE.count = sum(!is.na(p_slope)),
      XSLOPE.result = round(mean(p_slope, na.rm = T), 1),
      XSLOPE.sd = round(sd(p_slope, na.rm = T), 2)
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
      SLOPE_0.count = sum(!is.na(slope_0)),
      SLOPE_0_5.count = sum(!is.na(slope_0_5)),
      SLOPE_1.count = sum(!is.na(slope_1)),
      SLOPE_2.count = sum(!is.na(slope_2)),
      SLOPE_0.result = sum(`Length, Segment`[slope_0])/sum(`Length, Segment`) * 100,
      SLOPE_0_5.result = sum(`Length, Segment`[slope_0_5])/sum(`Length, Segment`) * 100,
      SLOPE_1.result = sum(`Length, Segment`[slope_1])/sum(`Length, Segment`) * 100,
      SLOPE_2.result = sum(`Length, Segment`[slope_2])/sum(`Length, Segment`) * 100
    )
  
  ###XBEARING AND SINU###
  
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
    ) 
    
    
  ### XBEARING ###
  # Sum of total proportions for all Fractions at one location should add to one, otherwise, that location is excluded from the count
  XBEARING <- data_bearing %>%
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
    
  ###SINU###
  
  SINU <- data_bearing %>%
    dplyr::group_by(id) %>%
    dplyr::mutate(
      bearing_radians = Bearing * pi / 180,
      cos_bearing = cos(bearing_radians),
      sin_bearing = sin(bearing_radians)
    ) %>% 
    dplyr::summarize(
      SINU.count = sum((!is.na(`Length, Segment`)) & (!is.na(Bearing)) ),
      SINU.result = sum(`Length, Segment`) / sqrt((sum(`Length, Segment` * cos_bearing)^2) + (sum(`Length, Segment` * sin_bearing)^2)),
      SINU.result = round(SINU.result, 2)
    )
  

  # Return final result #
  result <- dplyr::inner_join(XSLOPE, SLOPE_pcnt, by = 'id') %>% 
    dplyr::inner_join(XBEARING, by = 'id') %>%
    dplyr::inner_join(SINU, by = 'id') %>%
    tibble::column_to_rownames('id')
  
  return(result)
}
