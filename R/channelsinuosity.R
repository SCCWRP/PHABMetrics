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
  
  data <- data %>%
    dplyr::filter(AnalyteName %in% c('Slope', 'Length, Segment', 'Elevation Difference', 'Bearing', 'Proportion', 'Length, Reach'))
  
  if ((data %>% dplyr::filter(AnalyteName == 'Elevation Difference' & UnitName != 'cm') %>% nrow) > 0) {
    stop(
      'There are records for the analyte Elevation Difference that were not reported in cm. This will cause an inaccurate calculation of XSlope'
    )
  }
  if ((data %>% dplyr::filter(AnalyteName == 'Length, Segment' & UnitName != 'm') %>% nrow) > 0) {
    stop(
      'There are records for the analyte Length, Segment that were not reported in m. This will cause an inaccurate calculation of XSlope'
    )
  }
  
  # XSLOPE data ----------------------------------------------------------------------------------
  data_spread <- data %>%
    dplyr::group_by(id) %>%
    dplyr::arrange(id) %>% 
    dplyr::mutate(
      Result = dplyr::case_when(
        AnalyteName == 'Proportion' ~ Result/100, # convert % to proportion
        AnalyteName == 'Elevation Difference' ~ Result/100, # convert from cm to m
        TRUE ~ Result
      )
    ) %>% 
    dplyr::mutate(
      # Negative slope values were appearing in the PHAB Metrics - take the absolute value.
      Result = abs(Result)
    ) %>% 
    dplyr::select(id, LocationCode, AnalyteName, Result, FractionName) %>% 
    dplyr::group_by(id, LocationCode, AnalyteName, FractionName) %>% 
    dplyr::mutate(grouped_id = dplyr::row_number()) %>%
    tidyr::spread(AnalyteName, Result)
  
  if (all(c('Elevation Difference', 'Length, Segment', 'Slope') %in% colnames(data_spread))) {
    data_spread <- data_spread %>%
      dplyr::mutate(
        Slope = ifelse(is.na(Slope), `Elevation Difference`/`Length, Segment` * 100, Slope) ,
        p_slope = Slope * Proportion,
        p_bear = Bearing * Proportion
      )
  } else if (all(c('Elevation Difference','Length, Segment') %in% colnames(data_spread))) {
    data_spread <- data_spread %>%
      dplyr::mutate(
        Slope = `Elevation Difference`/`Length, Segment` * 100,
        p_slope = Slope * Proportion,
        p_bear = Bearing * Proportion
      )
  } else if ('Slope' %in% colnames(data_spread)) {
    data_spread <- data_spread %>%
      dplyr::mutate(
        # Slope = Slope,
        p_slope = Slope * Proportion,
        p_bear = Bearing * Proportion
      )
  } else {
    stop("Unable to calculate metrics for channelsinuosity. Missing Analytes 'Slope', and/or 'Elevation Difference'")
    return(data.frame())
  }
  
  ## XSLOPE calculation --------------------------------------------------------------------------
  XSLOPE <- data_spread %>% 
    dplyr::group_by(id, LocationCode) %>%
    dplyr::summarize(p_slope = sum(p_slope)) %>%  #sum across all FractionName for each LocationCode
    dplyr::group_by(id) %>% 
    dplyr::summarize(
      XSLOPE.count = length(na.omit(p_slope)),
      XSLOPE.result = mean(p_slope, na.rm = T) %>% round(1) %>% abs(),
      XSLOPE.sd = sd(p_slope, na.rm = T) %>% round(2)
    )
  
  ## SLOPE_pcnt calculation -------------------------------------------------------------------------
  SLOPE_pcnt <- data_spread %>% 
    dplyr::group_by(id) %>% 
    dplyr::mutate(
      slope_0   = Slope <= 0,
      slope_0_5 = Slope <= 0.5,
      slope_1   = Slope <= 1,
      slope_2   = Slope <= 2
    ) %>% 
    dplyr::summarize(
      SLOPE_0.count = sum(!is.na(slope_0)),
      SLOPE_0_5.count = sum(!is.na(slope_0_5)),
      SLOPE_1.count = sum(!is.na(slope_1)),
      SLOPE_2.count = sum(!is.na(slope_2)),
      SLOPE_0.result = sum(`Length, Segment`[slope_0], na.rm = T)/sum(`Length, Segment`, na.rm = T) * 100,
      SLOPE_0_5.result = sum(`Length, Segment`[slope_0_5], na.rm = T)/sum(`Length, Segment`, na.rm = T) * 100,
      SLOPE_1.result = sum(`Length, Segment`[slope_1], na.rm = T)/sum(`Length, Segment`, na.rm = T) * 100,
      SLOPE_2.result = sum(`Length, Segment`[slope_2], na.rm = T)/sum(`Length, Segment`, na.rm = T) * 100
    )
  
  # XBEAR -------------------------------------------------------------------------------------
  
  XBEAR <- data_spread %>% 
    dplyr::arrange(id) %>%
    dplyr::group_by(id, LocationCode) %>%
    dplyr::summarize(
      total_proportion = sum(Proportion, na.rm = T),
      total_bearing = sum(p_bear, na.rm = T)
    ) %>%
    dplyr::summarize(
      XBEARING.count = sum(total_proportion == 1, na.rm = T),
      XBEARING.result = sum(total_bearing, na.rm = T) / XBEARING.count %>% round,
      XBEARING.sd = sd(total_bearing[total_proportion == 1], na.rm = T) %>% round(1)
    )
  
  # SINUS -------------------------------------------------------------------------------------
  
  SINUS <- data_spread %>% 
    dplyr::group_by(id, LocationCode, FractionName) %>% 
    dplyr::mutate(angle = Bearing/360 * 2*pi) %>% 
    dplyr::group_by(id) %>% 
    dplyr::summarize(
      cos_ = sum((`Length, Segment` * cos(angle)), na.rm = T)^2,
      sin_ = sum((`Length, Segment` * sin(angle)), na.rm = T)^2,
      SINU.result = round(sum(`Length, Segment`, na.rm = T)/sqrt(sum(cos_, sin_, na.rm=T)), 2 ),
      SINU.count = sum((!is.na(`Length, Segment`)) & (!is.na(Bearing)) )
    ) %>% 
    dplyr::mutate(
      cos_ = NULL,
      sin_ = NULL
    )
  
  result <- XSLOPE %>% 
    dplyr::inner_join(SLOPE_pcnt, by = 'id') %>% 
    dplyr::inner_join(XBEAR, by = 'id') %>% 
    dplyr::inner_join(SINUS, by = 'id') %>% 
    tibble::column_to_rownames('id')
  
  return(result)
}
