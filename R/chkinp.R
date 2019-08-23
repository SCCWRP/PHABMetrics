#' Check input data for PHABMetrics
#'
#' Check input data for PHABMetrics
#' 
#' @param data Input data
#' @param purge If true, a data frame will be returned
#' with problematic rows removed, see details. 
#' @param msgs logical, if \code{FALSE} a purged or non-purged data frame, if \code{TRUE} a
#' two-element list with the data frame and concatenated list of messages, see the return value
#' 
#' @return An error message is returned if the input data are not correctly formatted.
#' 
#' @importFrom magrittr "%>%"
#' 
#' @details 
#' This function checks the following, relevant for the specified class of metrics:
#' \describe{
#' \item{}{\code{\link{algae}}: There are no conflicting values for every unique combination of \code{id}, \code{LocationCode}, \code{AnalyteName}, and \code{VariableResult} combination should have only one entry in \code{VariableResult} where \code{AnalyteName} is equal to \code{"Microalgae Thickness"}, \code{"Macrophyte Cover"}, \code{"Macroalgae Cover, Attached"}, or \code{"Macroalgae Cover, Unattached"}. This check is done for \code{algae()} metrics.}
#' \item{}{\code{\link{channelsinuosity}}: There are no conflicting values for every unique combination of \code{id}, \code{LocationCode}, \code{AnalyteName}, and \code{Result} combination should have only one entry in \code{Result} where \code{AnalyteName} is equal to \code{"Slope"}, \code{"Length, Segment"}, \code{"Elevation Difference"}, \code{"Bearing"}, \code{"Proportion"}, or \code{"Length, Reach"}.}
#' }
#' 
#' @return 
#' If \code{msgs = FALSE} (default), a data frame is returned that is either the same 
#' as the input if all checks have passed or a purged (\code{purge = TRUE}) or non-purged 
#' \code{purge = FALSE}) with or without offending rows removed.  If \code{msgs = TRUE}, a two-element list is returned, where 
#' the first element \code{data} is the data frame that would be returned if \code{msgs = FALSE}
#' and the second element is \code{msgs} with a concatenated character string of messages
#' indicating if all checks have passed and if not, which issues were encountered.  In the 
#' latter case, row numbers in the messages indicate which observations in the input data 
#' had issues.
#' 
#' @export
#'
#' @examples
#' dat <- phabformat(sampdat)
#' 
#' # get messages
#' datmsg <- chkinp(dat, msgs = TRUE)
#' datmsg$msgs
#' 
#' # get messages and purge
#' datprg <- chkinp(dat, msgs = TRUE, purge = TRUE)
#' dim(datprg$data)
#' 
chkinp <- function(data, purge = FALSE, msgs = FALSE){
  print("chkinp")
  msg <- NULL
  prg <- NULL
  
  # add index to data
  data <- data %>% 
    dplyr::mutate(ind = 1:nrow(.))
  
  ## 
  # no duplicate or conflicting values for all metrics
  
  # analytename values to check for specific metrics
  algae <- c('Microalgae Thickness', 'Macrophyte Cover', 'Macroalgae Cover, Attached', 'Macroalgae Cover, Unattached')
  channelsinuosity <- c('Slope', 'Length, Segment', 'Elevation Difference', 'Bearing', 'Proportion', 'Length, Reach')
  densiometer <- c('Canopy Cover')
  ripveg <- c('Riparian GroundCover Barren', 'Riparian GroundCover NonWoody Plants', 'Riparian GroundCover Woody Shrubs', 'Riparian Lower Canopy All Vegetation', 'Riparian Upper Canopy All Trees', 'Riparian Lower Canopy All Vegetation', 'Riparian Upper Canopy All Trees', 'Riparian GroundCover Woody Shrubs', 'Riparian GroundCover NonWoody Plants')
  sels <- c(algae, channelsinuosity, densiometer, ripveg)
  
  # see if duplicate id, locationcode, analytename, fractionname
  chk <- data %>% 
    dplyr::filter(AnalyteName %in% sels) %>% 
    dplyr::select(
      ind, id, LocationCode, AnalyteName, FractionName, VariableResult
    ) %>% 
    dplyr::group_by(id, LocationCode, AnalyteName, FractionName) %>% 
    dplyr::mutate(n = n()) %>% 
    dplyr::ungroup() %>% 
    dplyr::arrange(id, LocationCode, AnalyteName, FractionName) %>% 
    dplyr::mutate(dup = duplicated(cbind(id, LocationCode, AnalyteName, FractionName))) %>% 
    dplyr::filter(dup) %>%                  
    dplyr::pull(ind) %>% 
    sort
  
  if(any(chk)){
    
    msg <- c(msg, 
             paste0('Duplicate or multiple entries for id, LocationCode, and AnalyteName relevnt for algae metrics, rows ',
                    paste(chk, collapse = ', ')
             )
    )
                    
    prg <- c(prg, chk)
    
  }
  
  # remove bad rows if true
  if(purge){
    data <- data %>% 
      dplyr::filter(!ind %in% prg)
  }
  
  # remove index rows
  out <- data %>% 
    dplyr::select(-ind)
  
  # make checks passed message if no messages
  if(is.null(msg))
    msg <- 'All checks passed!'
  
  # add messages 
  if(msgs) 
    out <- list(
      data = out, 
      msgs = msg
    )
  out <- as.data.frame(out)
  print("End chkinp")
  return(out)
  
}
