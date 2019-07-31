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
  ###XSLOPE###
  data$Result[data$Result==-88] <- NA
  
  casted <- reshape::cast(data, id + FractionName +LocationCode ~ AnalyteName, value = "Result", fun.aggregate='length')
  casted <- as.data.frame(casted)
  colnames(casted)[colnames(casted)=="Length, Segment"] <- "Segment"
  casted$index <- as.factor(1:length(casted$id))
  if(is.null(casted$Slope))casted$Slope <- rep(NA, length(casted$id))
  if(is.null(casted$"Elevation Difference"))casted$Elevation <- rep(NA, length(casted$id))
  
  convert <- function(i, Slope, Elevation, Segment){
    if(!is.na(Slope[i])){Slope[i]} else
      if(!is.na(Elevation[i])){Elevation[i]/Segment[i]} else
        if(is.na(Slope[i])&is.na(Elevation[i])){NA}}
  
  casted$convert <- unlist(lapply(X=casted$index, FUN=convert, Slope=casted$Slope, Elevation=casted$Elevation, Segment=casted$Segment ))
  casted$convert <- casted$convert * ((casted$Proportion)/100)
  
  sumna <- function(data)sum(as.numeric(as.character(data)), na.rm = T) 
  sdna <- function(data)sd(data, na.rm = T)
  lengthna <- function(data)sum(!is.na(data))
  
  XSLOPE_sum <- tapply(casted$convert, casted$id, sumna)
  XSLOPE.count <- tapply(casted$convert, casted$id, lengthna)
  XSLOPE.result <- XSLOPE_sum/XSLOPE.count
  XSLOPE.sd <- tapply(casted$convert, casted$id, sdna)
  
  
  ###Make segment/proportion column###

  casted$segpro <- (casted$Segment/casted$Proportion)*100
  casted$convert[is.na(casted$convert)] <- -88
  ###SLOPE_0###
  casted$sumna5 <- lapply(1:length(casted$id), function(i, d, p)if(casted$convert[i] == 0){d[i]}else{NA}, d=casted$segpro, p=casted$convert)
  SLOPE_0_sum <- tapply(unlist(casted$sumna5), casted$id, sumna)
  counts <- tapply(casted$segpro, casted$id, lengthna)
  
  SLOPE_0_reach <- as.array(data$Result[data$AnalyteName=="Length, Reach"])
  dimnames(SLOPE_0_reach) <- list(data$id[data$AnalyteName=="Length, Reach"])

  reach <- array(rep(NA), length(SLOPE_0_sum))
  dimnames(reach) <- dimnames(SLOPE_0_sum)
  reach[which(unlist(dimnames(reach)) %in% 
                unlist(dimnames(SLOPE_0_reach)))] <- SLOPE_0_reach
  
  
  missing <- names(which(is.na(reach)))
  
  alternate <- tapply(casted[casted$id %in% missing, "Segment"], 
                      casted[casted$id %in% missing, "id"], sumna)
  
  SLOPE_0.notes <- array(rep(NA), length(SLOPE_0_sum))
  dimnames(SLOPE_0.notes) <- dimnames(SLOPE_0_sum)
  SLOPE_0.notes[which(unlist(dimnames(SLOPE_0.notes)) %in% 
                        unlist(dimnames(SLOPE_0_reach)))] <- "Reach length pulled from analyte 'Reach, length'"
  SLOPE_0.notes[which(unlist(dimnames(SLOPE_0.notes)) %in% 
                        unlist(dimnames(alternate)))] <- "Reach length calculated from sum of segments"
  
  reach[which(unlist(dimnames(reach)) %in% 
                unlist(dimnames(alternate)))] <- alternate
  
  
  SLOPE_0.result <- (SLOPE_0_sum/unlist(reach))*100
  SLOPE_0.count <-counts
  
  ###SLOPE_0_5###
  casted$sumna5 <- lapply(1:length(casted$id), function(i, d, p)if(casted$convert[i] > 0 && 0.5 >= casted$convert[i]){d[i]}else{NA}, d=casted$segpro, p=casted$convert)
  SLOPE_0_5_sum <- tapply(unlist(casted$sumna5), casted$id, sumna)
  SLOPE_0_5.result <- (SLOPE_0_5_sum/reach)*100
  SLOPE_0_5.count <-counts
  
  ###SLOPE_1
  casted$sumna1 <- lapply(1:length(casted$id), function(i, d, p)if(casted$convert[i] > 0 && 1 >= casted$convert[i]){d[i]}else{NA}, d=casted$segpro, p=casted$convert)
  SLOPE_1_sum <- tapply(unlist(casted$sumna1), casted$id, sumna)
  SLOPE_1.result <- (SLOPE_1_sum/reach)*100
  SLOPE_1.count <-counts
  
  ###SLOPE_2
  casted$sumna2 <- lapply(1:length(casted$id), function(i, d, p)if(casted$convert[i] > 0 && 2 >= casted$convert[i]){d[i]}else{NA}, d=casted$segpro, p=casted$convert)
  SLOPE_2_sum <- tapply(unlist(casted$sumna2), casted$id, sumna)
  SLOPE_2.result <- (SLOPE_2_sum/reach)*100
  SLOPE_2.count <-counts
  
  ###XBEARING###
  
  casted$XBEARING <- casted$Bearing * (casted$Proportion/100)
  XBEARING_sum <- tapply(casted$XBEARING, casted$id, sumna)
  XBEARING.count <- tapply(casted$XBEARING, casted$id, lengthna)
  XBEARING.result <- XBEARING_sum/XBEARING.count
  XBEARING.sd <- tapply(casted$XBEARING, casted$id, sdna)
  
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
