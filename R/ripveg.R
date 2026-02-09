#' Riparian vegetation metrics
#'
#' @param data Input data
#'
#' @export
#'
#' @examples
#' sampdat <- phabformat(sampdat)
#' ripveg(sampdat)
ripveg <- function(data) {
  data <- data[
    which(
      data$AnalyteName %in%
        c(
          'Riparian GroundCover Barren',
          'Riparian GroundCover NonWoody Plants',
          'Riparian GroundCover Woody Shrubs',
          'Riparian Lower Canopy All Vegetation',
          'Riparian Upper Canopy All Trees',
          'Riparian Lower Canopy All Vegetation',
          'Riparian Upper Canopy All Trees',
          'Riparian GroundCover Woody Shrubs',
          'Riparian GroundCover NonWoody Plants'
        )
    ),
  ]
  ###Slice Riparian GroundCover Barren Data ###

  barrenindex <- which(data$AnalyteName == "Riparian GroundCover Barren")
  barren <- data.frame(cbind(
    data$id[barrenindex],
    as.character(data$AnalyteName[barrenindex]),
    as.character(data$VariableResult[barrenindex])
  ))
  colnames(barren) <- c("id", "AnalyteName", "result")
  barren$result <- as.character(barren$result)

  ###Compute XGB###

  barren$result <- dplyr::case_when(
    barren$result == '0' ~ 0,
    barren$result == '1' ~ 5,
    barren$result == '2' ~ 25,
    barren$result == '3' ~ 57.5,
    barren$result == '4' ~ 87.5,
    TRUE ~ NaN
  )

  sumna <- function(data) {
    sum(data, na.rm = T)
  }
  XGB_sum <- tapply(barren$result, barren$id, sumna)
  lengthna <- function(data) {
    sum(!is.na(data))
  }
  XGB.count <- tapply(barren$result, barren$id, lengthna)
  XGB.result <- round(XGB_sum / XGB.count)
  sdna <- function(data) {
    sd(data, na.rm = T)
  }
  XGB.sd <- round(tapply(barren$result, barren$id, sdna), 1)
  XGB <- data.frame(cbind(XGB.result, XGB.count, XGB.sd))

  ###Slice for Riparian GroundCover Nonwoody Plants###

  nonwoodyindex <- which(
    data$AnalyteName == "Riparian GroundCover NonWoody Plants"
  )
  nonwoody <- data.frame(cbind(
    data$id[nonwoodyindex],
    as.character(data$AnalyteName[nonwoodyindex]),
    as.character(data$VariableResult[nonwoodyindex])
  ))
  colnames(nonwoody) <- c("id", "AnalyteName", "result")
  nonwoody$result <- as.character(nonwoody$result)

  ###Compute XGH###
  nonwoody$result <- dplyr::case_when(
    nonwoody$result == '0' ~ 0,
    nonwoody$result == '1' ~ 5,
    nonwoody$result == '2' ~ 25,
    nonwoody$result == '3' ~ 57.5,
    nonwoody$result == '4' ~ 87.5,
    TRUE ~ NaN
  )

  sumna <- function(data) {
    sum(data, na.rm = T)
  }
  XGH_sum <- tapply(nonwoody$result, nonwoody$id, sumna)
  lengthna <- function(data) {
    sum(!is.na(data))
  }
  XGH.count <- tapply(nonwoody$result, nonwoody$id, lengthna)
  XGH.result <- round(XGH_sum / XGH.count)
  sdna <- function(data) {
    sd(data, na.rm = T)
  }
  XGH.sd <- round(tapply(nonwoody$result, nonwoody$id, sdna), 1)
  XGH <- data.frame(cbind(XGH.result, XGH.count, XGH.sd))

  ###Slice for Riparian GroundCover Woody Shrubs###

  woodyindex <- which(data$AnalyteName == "Riparian GroundCover Woody Shrubs")
  woody <- data.frame(cbind(
    data$id[woodyindex],
    as.character(data$AnalyteName[woodyindex]),
    as.character(data$VariableResult[woodyindex])
  ))
  colnames(woody) <- c("id", "AnalyteName", "result")

  woody$result[woody$result %in% 'Not Recorded'] <- NA
  woody$result <- as.numeric(as.character(woody$result))

  ###Compute XGW###

  woody$result <- dplyr::case_when(
    woody$result == '0' ~ 0,
    woody$result == '1' ~ 5,
    woody$result == '2' ~ 25,
    woody$result == '3' ~ 57.5,
    woody$result == '4' ~ 87.5,
    TRUE ~ NaN
  )

  sumna <- function(data) {
    sum(data, na.rm = T)
  }
  XGW_sum <- tapply(woody$result, woody$id, sumna)
  lengthna <- function(data) {
    sum(!is.na(data))
  }
  XGW.count <- tapply(woody$result, woody$id, lengthna)
  XGW.result <- round(XGW_sum / XGW.count)
  sdna <- function(data) {
    sd(data, na.rm = T)
  }
  XGW.sd <- round(tapply(woody$result, woody$id, sdna), 1)
  XGW <- data.frame(cbind(XGW.result, XGW.count, XGW.sd))

  ###Slice for Riparian Lower Canopy All Vegetation###

  lowercanopyindex <- which(
    data$AnalyteName == "Riparian Lower Canopy All Vegetation"
  )
  lowercanopy <- data.frame(cbind(
    data$id[lowercanopyindex],
    as.character(data$AnalyteName[lowercanopyindex]),
    as.character(data$VariableResult[lowercanopyindex])
  ))
  colnames(lowercanopy) <- c("id", "AnalyteName", "result")
  lowercanopy$result <- as.character(lowercanopy$result)

  ###Compute XM###

  lowercanopy$result <- dplyr::case_when(
    lowercanopy$result == '0' ~ 0,
    lowercanopy$result == '1' ~ 5,
    lowercanopy$result == '2' ~ 25,
    lowercanopy$result == '3' ~ 57.5,
    lowercanopy$result == '4' ~ 87.5,
    TRUE ~ NaN
  )

  sumna <- function(data) {
    sum(data, na.rm = T)
  }
  XM_sum <- tapply(lowercanopy$result, lowercanopy$id, sumna)
  lengthna <- function(data) {
    sum(!is.na(data))
  }
  XM.count <- tapply(lowercanopy$result, lowercanopy$id, lengthna)
  XM.result <- round(XM_sum / XM.count)
  sdna <- function(data) {
    sd(data, na.rm = T)
  }
  XM.sd <- round(tapply(lowercanopy$result, lowercanopy$id, sdna), 1)
  XM <- data.frame(cbind(XM.result, XM.count, XM.sd))

  ###Slice for Riparian Upper Canopy All Trees###

  uppercanopyindex <- which(
    data$AnalyteName == "Riparian Upper Canopy All Trees"
  )
  uppercanopy <- data.frame(cbind(
    data$id[uppercanopyindex],
    as.character(data$AnalyteName[uppercanopyindex]),
    as.character(data$VariableResult[uppercanopyindex])
  ))
  colnames(uppercanopy) <- c("id", "AnalyteName", "result")

  uppercanopy$result <- as.character(uppercanopy$result)

  ###Compute XC###

  uppercanopy$result <- dplyr::case_when(
    uppercanopy$result == '0' ~ 0,
    uppercanopy$result == '1' ~ 5,
    uppercanopy$result == '2' ~ 25,
    uppercanopy$result == '3' ~ 57.5,
    uppercanopy$result == '4' ~ 87.5,
    TRUE ~ NaN
  )

  sumna <- function(data) {
    sum(data, na.rm = T)
  }
  XC_sum <- tapply(uppercanopy$result, uppercanopy$id, sumna)
  lengthna <- function(data) {
    sum(!is.na(data))
  }
  XC.count <- tapply(uppercanopy$result, uppercanopy$id, lengthna)
  XC.result <- round(XC_sum / XC.count)
  sdna <- function(data) {
    sd(data, na.rm = T)
  }
  XC.sd <- round(tapply(uppercanopy$result, uppercanopy$id, sdna), 1)
  XC <- data.frame(cbind(XC.result, XC.count, XC.sd))

  ###Compute XG###
  XG.result <- XGW$XGW.result + XGH$XGH.result
  XG.count <- rowSums(!is.na(cbind(XGW$XGW.result, XGH$XGH.result)))

  ###Compute XCM###
  XCM.result <- XC$XC.result + XM$XM.result
  XCM.count <- rowSums(!is.na(cbind(XC$XC.result, XM$XM.result)))

  ###Compute XCMG###

  XCMG.result <- XG.result + XCM.result
  XCMG.count <- XG.count + XCM.count

  ###Compute XPMID###

  lowercanopyindex <- which(
    data$AnalyteName == "Riparian Lower Canopy All Vegetation"
  )
  lowercanopy <- data.frame(cbind(
    data$id[lowercanopyindex],
    as.character(data$AnalyteName[lowercanopyindex]),
    as.character(data$VariableResult[lowercanopyindex])
  ))
  colnames(lowercanopy) <- c("id", "AnalyteName", "result")
  lowercanopy$result[lowercanopy$result %in% 'Not Recorded'] <- NA
  lowercanopy$result <- as.numeric(as.character(lowercanopy$result))

  XPMID_total <- tapply(lowercanopy$result, lowercanopy$id, lengthna)

  lowercanopy$result[which(is.na(lowercanopy$result))] = 0
  XPMID_subcountf <- function(data) {
    length(which(data != 0))
  }
  XPMID_subcount <- tapply(lowercanopy$result, lowercanopy$id, XPMID_subcountf)
  # LOL If you read the instructions carefully, we will see that we had it backwards here.
  # it should be XPMID_subcount/XPMID_total
  #XPMID.result <- XPMID_total/XPMID_subcount
  XPMID.result <- round(XPMID_subcount / XPMID_total, 2)
  XPMID.count <- XPMID_total

  ###Compute XPCAN###

  uppercanopyindex <- which(
    data$AnalyteName == "Riparian Upper Canopy All Trees"
  )
  uppercanopy <- data.frame(cbind(
    data$id[uppercanopyindex],
    as.character(data$AnalyteName[uppercanopyindex]),
    as.character(data$VariableResult[uppercanopyindex])
  ))
  colnames(uppercanopy) <- c("id", "AnalyteName", "result")
  uppercanopy$result[uppercanopy$result %in% 'Not Recorded'] <- NA
  uppercanopy$result <- as.numeric(as.character(uppercanopy$result))

  XPCAN_total <- tapply(uppercanopy$result, uppercanopy$id, lengthna)

  uppercanopy$result[which(is.na(uppercanopy$result))] = 0
  XPCAN_subcountf <- function(data) {
    length(which(data != 0))
  }
  XPCAN_subcount <- tapply(uppercanopy$result, uppercanopy$id, XPCAN_subcountf)
  XPCAN.result <- round(XPCAN_subcount / XPCAN_total, 2)
  XPCAN.count <- XPCAN_total

  ###Compute XPGVEG###
  # woodyindex <- which(data$AnalyteName == "Riparian GroundCover Woody Shrubs")
  # woody <- data.frame(cbind(data$id[woodyindex], as.character(data$AnalyteName[woodyindex]),
  #                           as.character(data$VariableResult[woodyindex])))
  # colnames(woody) <- c("id", "AnalyteName", "result")
  # woody$result[woody$result %in% 'Not Recorded'] <- NA
  # woody$result <- as.numeric(as.character(woody$result))
  # head(woody)
  # nonwoodyindex <- which(data$AnalyteName == "Riparian GroundCover NonWoody Plants")
  # nonwoody <- data.frame(cbind(data$id[nonwoodyindex], as.character(data$AnalyteName[nonwoodyindex]),
  #                              as.character(data$VariableResult[nonwoodyindex])))
  # colnames(nonwoody) <- c("id", "AnalyteName", "result")
  # nonwoody$result[nonwoody$result %in% 'Not Recorded'] <- NA
  # nonwoody$result <- as.numeric(as.character(nonwoody$result))
  # head(nonwoody)
  # woody$XPGVEG<-apply((cbind(woody$result, nonwoody$result)), 1, sum, na.rm=T)
  # XPGVEG_subcounting<-(data.frame(!(is.na(woody$result)&(is.na(nonwoody$result))), as.character(woody$id)))
  # XPGVEG_total <-tapply(XPGVEG_subcounting[[1]], (XPGVEG_subcounting[[2]]), sum)
  #
  # woody$XPGVEG[which(is.na(woody$XPGVEG))] = 0
  # XPGVEG_subcountf <- function(data){
  #   length(which(data != 0))
  # }
  # XPGVEG_subcount <- tapply(woody$XPGVEG, woody$id, XPGVEG_subcountf)
  # XPGVEG.result <- round(XPGVEG_subcount/XPGVEG_total, 2)
  # XPGVEG.count <- XPGVEG_total

  # XPGVEG ------------------------------------------------------------------
  XPGVEG <- data %>%
    dplyr::filter(
      AnalyteName %in%
        c(
          'Riparian GroundCover NonWoody Plants',
          'Riparian GroundCover Woody Shrubs'
        )
    ) %>%
    dplyr::mutate(
      VariableResult = as.numeric(as.character(VariableResult))
    ) %>%
    dplyr::group_by(id, LocationCode) %>%
    dplyr::summarize(
      groundCoverPresence = sum(VariableResult)
    ) %>%
    dplyr::group_by(id) %>%
    dplyr::summarize(
      XPGVEG.count = sum(!is.na(groundCoverPresence)),
      XPGVEG.result = round(sum(groundCoverPresence > 0) / XPGVEG.count, 2)
    ) %>%
    as.data.frame %>%
    tibble::column_to_rownames('id')

  ###XPCM###
  aframe <- as.data.frame(reshape::cast(
    data,
    id + LocationCode ~ AnalyteName,
    value = "VariableResult",
    fun.aggregate = 'length'
  ))

  for (i in 3:7) {
    aframe[[i]] <- as.numeric(as.character(aframe[[i]]))
  }
  aframe[is.na(aframe)] <- (-1)
  aframe[aframe == "Not Recorded"] <- (-1)
  aframe$XPCM <- rep(NA, length(aframe$id))
  for (i in which(!is.na(aframe[[3]]))) {
    aframe$XPCM[i] <- if (
      (aframe$"Riparian Upper Canopy All Trees"[i] > 0) &
        (aframe$"Riparian Lower Canopy All Vegetation"[i] > 0)
    ) {
      T
    } else if (
      (aframe$"Riparian Upper Canopy All Trees"[i] == 0) |
        (aframe$"Riparian Lower Canopy All Vegetation"[i] == 0)
    ) {
      F
    } else {
      NA
    }
  }
  aframe$"Riparian Upper Canopy All Trees"[which(
    aframe$"Riparian Upper Canopy All Trees" == -1
  )] <- NA
  XPCM.result <- tapply(aframe$XPCM, aframe$id, sumna) /
    tapply(aframe$XPCM, aframe$id, lengthna)

  ### XPCMG and XPMGVEG ###
  XPCM_XPCMG_XPMGVEG <- data %>%
    tidyr::spread(key = AnalyteName, value = VariableResult) %>%
    dplyr::select(
      -c(
        UnitName,
        FractionName,
        ResQualCode,
        QACode,
        StationCode,
        SampleDate,
        Result,
        Replicate,
        'Riparian GroundCover Barren'
      )
    ) %>%
    dplyr::group_by(id) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      XPCM.result = purrr::map(data, function(subdf) {
        subdf$LowerUpperPresence <- ((as.numeric(as.character(subdf[[
          'Riparian Upper Canopy All Trees'
        ]])) >
          0) &
          (as.numeric(as.character(subdf[[
            'Riparian Lower Canopy All Vegetation'
          ]])) >
            0))
        obs_above_zero <- sum(subdf$LowerUpperPresence, na.rm = T)
        non_null_obs <- sum(!is.na(subdf$LowerUpperPresence))
        return(round(obs_above_zero / non_null_obs, 2))
      }),
      XPCMG.result = purrr::map(data, function(subdf) {
        subdf$GroundCoverPresence <- (as.numeric(as.character(subdf[[
          'Riparian GroundCover NonWoody Plants'
        ]])) +
          as.numeric(as.character(subdf[[
            'Riparian GroundCover Woody Shrubs'
          ]]))) >
          0
        subdf$LowerCanopyPresence <- as.numeric(as.character(subdf[[
          'Riparian Lower Canopy All Vegetation'
        ]])) >
          0
        subdf$UpperCanopyPresence <- as.numeric(as.character(subdf[[
          'Riparian Upper Canopy All Trees'
        ]])) >
          0
        subdf$All3Layers <- subdf$GroundCoverPresence +
          subdf$LowerCanopyPresence +
          subdf$UpperCanopyPresence
        non_null_obs <- sum(!is.na(subdf$All3Layers))
        obs_above_zero <- sum(subdf$All3Layers == 3, na.rm = T)
        return(round(obs_above_zero / non_null_obs, 2))
      }),
      XPMGVEG.result = purrr::map(data, function(subdf) {
        #subdf$GroundCoverPresence <- (as.numeric(as.character(subdf[['Riparian GroundCover NonWoody Plants']])) > 0 & as.numeric(as.character(subdf[['Riparian GroundCover Woody Shrubs']]))) > 0
        subdf$GroundCoverPresence <- ((as.numeric(as.character(subdf[[
          'Riparian GroundCover NonWoody Plants'
        ]])) >
          1) |
          (as.numeric(as.character(subdf[[
            'Riparian GroundCover Woody Shrubs'
          ]])) >
            1))
        # print(subdf)
        non_null_obs <- sum(!is.na(subdf$GroundCoverPresence))
        # print(non_null_obs)
        obs_above_one <- sum(subdf$GroundCoverPresence, na.rm = T)
        # print(obs_above_one)
        return(round(obs_above_one / non_null_obs, 2))
      }),
      XPCM.count = purrr::map(data, function(subdf) {
        subdf$LowerUpperPresence <- ((as.numeric(as.character(subdf[[
          'Riparian Upper Canopy All Trees'
        ]])) >
          0) &
          (as.numeric(as.character(subdf[[
            'Riparian Lower Canopy All Vegetation'
          ]])) >
            0))
        non_null_obs <- sum(!is.na(subdf$LowerUpperPresence))
        return(non_null_obs)
      }),
      XPCMG.count = purrr::map(data, function(subdf) {
        subdf$GroundCoverPresence <- (as.numeric(as.character(subdf[[
          'Riparian GroundCover NonWoody Plants'
        ]])) +
          as.numeric(as.character(subdf[[
            'Riparian GroundCover Woody Shrubs'
          ]]))) >
          0
        subdf$LowerCanopyPresence <- as.numeric(as.character(subdf[[
          'Riparian Lower Canopy All Vegetation'
        ]])) >
          0
        subdf$UpperCanopyPresence <- as.numeric(as.character(subdf[[
          'Riparian Upper Canopy All Trees'
        ]])) >
          0
        subdf$All3Layers <- subdf$GroundCoverPresence +
          subdf$LowerCanopyPresence +
          subdf$UpperCanopyPresence
        non_null_obs <- sum(!is.na(subdf$All3Layers))
        return(non_null_obs)
      }),
      XPMGVEG.count = purrr::map(data, function(subdf) {
        subdf$GroundCoverPresence <- ((as.numeric(as.character(subdf[[
          'Riparian GroundCover NonWoody Plants'
        ]])) >
          1) |
          (as.numeric(as.character(subdf[[
            'Riparian GroundCover Woody Shrubs'
          ]])) >
            1))
        non_null_obs <- sum(!is.na(subdf$GroundCoverPresence))
        return(non_null_obs)
      })
    ) %>%
    dplyr::select(-data) %>%
    tidyr::unnest()

  XPCM_XPCMG_XPMGVEG <- as.data.frame(XPCM_XPCMG_XPMGVEG)
  rownames(XPCM_XPCMG_XPMGVEG) <- XPCM_XPCMG_XPMGVEG$id
  XPCM_XPCMG_XPMGVEG <- XPCM_XPCMG_XPMGVEG %>% dplyr::select(-id)

  ###Write to file###
  results <- cbind(
    XGB,
    XGH,
    XGW,
    XM,
    XC,
    XG.result,
    XG.count,
    XCM.result,
    XCM.count,
    XCMG.result,
    XCMG.count,
    XPMID.result,
    XPMID.count,
    XPCAN.result,
    XPCAN.count,
    XPCM_XPCMG_XPMGVEG
  )

  results <- merge(results, XPGVEG, by = 'row.names') %>%
    tibble::column_to_rownames('Row.names')

  return(results)
}
