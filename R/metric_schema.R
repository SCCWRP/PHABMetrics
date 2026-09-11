# Canonical column set each metric subfunction produces on complete data.
# Used to backfill missing metrics so every sample still gets a row:
# NA for .result and .sd, 0 for .count.
#
# Generated from `sampdat`. tests/testthat/test_metric_schema.R asserts this
# stays in sync with what the functions actually return, so if you add a
# metric that test will fail until you regenerate this list.
metric_schema <- list(
  bankmorph = c(
    'XBKF_H.result', 'XBKF_H.count', 'XBKF_H.sd', 'XBKF_W.result',
    'XBKF_W.count', 'XBKF_W.sd', 'XWDEPTH.result', 'XWDEPTH.count',
    'XWDEPTH.sd', 'XWIDTH.result', 'XWIDTH.count', 'XWIDTH.sd',
    'XWDR.result', 'XWDR.count', 'XWDA.result', 'XWDA.count',
    'XWDM.count', 'XWDM.result', 'XWDM.sd', 'XBKF_TH.result',
    'XBKF_TH.count', 'XBKF_DA.result', 'XBKF_DA.count'
  ),
  channelmorph = c(
    'PCT_CF.result', 'PCT_CF.count', 'PCT_CF.sd', 'PCT_DR.result',
    'PCT_DR.count', 'PCT_DR.sd', 'PCT_GL.result', 'PCT_GL.count',
    'PCT_GL.sd', 'PCT_POOL.result', 'PCT_POOL.count', 'PCT_POOL.sd',
    'PCT_RA.result', 'PCT_RA.count', 'PCT_RA.sd', 'PCT_RI.result',
    'PCT_RI.count', 'PCT_RI.sd', 'PCT_RN.result', 'PCT_RN.count',
    'PCT_RN.sd', 'PCT_FAST.result', 'PCT_SLOW.result',
    'PCT_CF_WT.result', 'PCT_CF_WT.count', 'PCT_GL_WT.result',
    'PCT_GL_WT.count', 'PCT_POOL_WT.result', 'PCT_POOL_WT.count',
    'PCT_RA_WT.result', 'PCT_RA_WT.count', 'PCT_RI_WT.result',
    'PCT_RI_WT.count', 'PCT_RN_WT.result', 'PCT_RN_WT.count',
    'PCT_FAST_WT.result', 'PCT_SLOW_WT.result', 'PCT_FAST.count',
    'PCT_SLOW.count', 'PCT_FAST_WT.count', 'PCT_SLOW_WT.count',
    'Rich_FlowHab.result', 'Rich_FlowHab.count', 'Rich_FlowHab4.result',
    'Rich_FlowHab4.count', 'H_FlowHab.result', 'H_FlowHab.count',
    'Ev_FlowHab.result', 'Ev_FlowHab.count', 'H_FlowHab_mod1.result'
  ),
  channelsinuosity = c(
    'XSLOPE.count', 'XSLOPE.result', 'XSLOPE.sd', 'SLOPE_0.count',
    'SLOPE_0_5.count', 'SLOPE_1.count', 'SLOPE_2.count',
    'SLOPE_0.result', 'SLOPE_0_5.result', 'SLOPE_1.result',
    'SLOPE_2.result', 'XBEARING.count', 'XBEARING.result', 'XBEARING.sd',
    'SINU.result', 'SINU.count'
  ),
  densiometer = c(
    'XCDENMID.result', 'XCDENMID.count', 'XCDENMID.sd', 'XCDENBK.result',
    'XCDENBK.count', 'XCDENBK.sd'
  ),
  habitat = c(
    'XFC_AQM.result', 'XFC_AQM.count', 'XFC_AQM.sd', 'XFC_HUM.result',
    'XFC_HUM.count', 'XFC_HUM.sd', 'XFC_RCK.result', 'XFC_RCK.count',
    'XFC_RCK.sd', 'XFC_ALG.result', 'XFC_ALG.count', 'XFC_ALG.sd',
    'XFC_LWD.result', 'XFC_LWD.count', 'XFC_LWD.sd', 'XFC_LTR.result',
    'XFC_LTR.count', 'XFC_LTR.sd', 'XFC_OHV.result', 'XFC_OHV.count',
    'XFC_OHV.sd', 'XFC_BRS.result', 'XFC_BRS.count', 'XFC_BRS.sd',
    'XFC_UCB.result', 'XFC_UCB.count', 'XFC_UCB.sd', 'XFC_BIG.result',
    'XFC_NAT_EMAP.result', 'XFC_NAT_SWAMP.result', 'CFC_AQM.result',
    'CFC_HUM.result', 'CFC_RCK.result', 'CFC_ALG.result',
    'CFC_LWD.result', 'CFC_LTR.result', 'CFC_OHV.result',
    'CFC_BRS.result', 'CFC_UCB.result', 'CFC_ALL_EMAP.result',
    'CFC_ALL_SWAMP.result', 'XFC_BIG.count', 'XFC_BIG3.result',
    'XFC_BIG3.count', 'XFC_NAT_EMAP.count', 'XFC_NAT_SWAMP.count',
    'CFC_ALL_EMAP.count', 'CFC_ALL_SWAMP.count', 'H_AqHab.result',
    'H_AqHab_mod1.result', 'H_AqHab.count', 'Ev_AqHab.result',
    'Ev_AqHab.count', 'CFC_ALG.count', 'CFC_AQM.count', 'CFC_BRS.count',
    'CFC_HUM.count', 'CFC_LTR.count', 'CFC_LWD.count', 'CFC_OHV.count',
    'CFC_RCK.count', 'CFC_UCB.count', 'Rich_AqHab.result',
    'Rich_AqHab.count'
  ),
  disturbance = c(
    'W1H_BRDG.result', 'W1H_BRDG.count', 'W1H_BRDG.sd',
    'W1H_BLDG.result', 'W1H_BLDG.count', 'W1H_BLDG.sd',
    'W1H_LDFL.result', 'W1H_LDFL.count', 'W1H_LDFL.sd', 'W1H_LOG.result',
    'W1H_LOG.count', 'W1H_LOG.sd', 'W1H_MINE.result', 'W1H_MINE.count',
    'W1H_MINE.sd', 'W1H_ORVY.result', 'W1H_ORVY.count', 'W1H_ORVY.sd',
    'W1H_PARK.result', 'W1H_PARK.count', 'W1H_PARK.sd',
    'W1H_PSTR.result', 'W1H_PSTR.count', 'W1H_PSTR.sd',
    'W1H_PVMT.result', 'W1H_PVMT.count', 'W1H_PVMT.sd',
    'W1H_PIPE.result', 'W1H_PIPE.count', 'W1H_PIPE.sd',
    'W1H_ROAD.result', 'W1H_ROAD.count', 'W1H_ROAD.sd',
    'W1H_CROP.result', 'W1H_CROP.count', 'W1H_CROP.sd',
    'W1H_VEGM.result', 'W1H_VEGM.count', 'W1H_VEGM.sd',
    'W1H_WALL.result', 'W1H_WALL.count', 'W1H_WALL.sd',
    'W1_HALL_EMAP.result', 'W1_HALL_EMAP.count', 'W1_HALL_SWAMP.result',
    'W1_HALL_SWAMP.count'
  ),
  flow = c(
    'FL_Q_F.result', 'FL_Q_F.count', 'FL_Q_M.result', 'FL_Q_M.count',
    'FL_N_M.result', 'FL_N_F.result', 'XWV_F.result', 'XWV_F.count',
    'XWV_F.sd', 'XWV_M.result', 'XWV_M.count', 'XWV_M.sd',
    'MWVM_F.result', 'MWVM_F.count', 'MWVM_M.result', 'MWVM_M.count',
    'PWVZ.result', 'PWVZ.count'
  ),
  misc = c(
    'NFC_DLU.result', 'NFC_EFR.result', 'NFC_ERN.result',
    'RBP_CHN.result', 'RBP_EPI.result', 'RBP_SED.result'
  ),
  bankstability = c(
    'PBM_S.result', 'PBM_S.count', 'PBM_V.result', 'PBM_V.count',
    'PBM_E.result', 'PBM_E.count'
  ),
  quality = c(
    'XWAT.result', 'XWDO.result', 'XWPH.result', 'XWSL.result',
    'XWSC.result', 'XWTC.result', 'XWTF.result', 'XWTB.result',
    'XWAT.count', 'XWDO.count', 'XWPH.count', 'XWSL.count', 'XWSC.count',
    'XWTC.count', 'XWTF.count', 'XWTB.count', 'XWAT.sd', 'XWDO.sd',
    'XWPH.sd', 'XWSL.sd', 'XWSC.sd', 'XWTC.sd', 'XWTF.sd', 'XWTB.sd'
  ),
  ripveg = c(
    'XGB.result', 'XGB.count', 'XGB.sd', 'XGH.result', 'XGH.count',
    'XGH.sd', 'XGW.result', 'XGW.count', 'XGW.sd', 'XM.result',
    'XM.count', 'XM.sd', 'XC.result', 'XC.count', 'XC.sd', 'XG.result',
    'XG.count', 'XCM.result', 'XCM.count', 'XCMG.result', 'XCMG.count',
    'XPMID.result', 'XPMID.count', 'XPCAN.result', 'XPCAN.count',
    'XPCM.result', 'XPCMG.result', 'XPMGVEG.result', 'XPCM.count',
    'XPCMG.count', 'XPMGVEG.count', 'XPGVEG.count', 'XPGVEG.result'
  ),
  substrate = c(
    'PCT_RS.result', 'PCT_RR.result', 'PCT_RC.result', 'PCT_XB.result',
    'PCT_SB.result', 'PCT_CB.result', 'PCT_GC.result', 'PCT_GF.result',
    'PCT_SA.result', 'PCT_FN.result', 'PCT_HP.result', 'PCT_WD.result',
    'PCT_OT.result', 'PCT_RS.count', 'PCT_RR.count', 'PCT_RC.count',
    'PCT_XB.count', 'PCT_SB.count', 'PCT_CB.count', 'PCT_GC.count',
    'PCT_GF.count', 'PCT_SA.count', 'PCT_FN.count', 'PCT_HP.count',
    'PCT_WD.count', 'PCT_OT.count', 'PCT_BDRK.result', 'PCT_BIGR.result',
    'PCT_SFGF.result', 'PCT_SAFN.result', 'PCT_SAFNRC.result',
    'PCT_BDRK.count', 'PCT_BIGR.count', 'PCT_SFGF.count',
    'PCT_SAFN.count', 'PCT_SAFNRC.count', 'XSDGM.result', 'XSDGM.count',
    'XSPGM.result', 'XEMBED.result', 'XEMBED.count', 'XEMBED.sd',
    'PCT_CPOM.result', 'PCT_CPOM.count', 'H_SubNat.result',
    'H_SubNat.count', 'Ev_SubNat.result', 'Ev_SubNat.count',
    'SB_PT_D50.result', 'SB_PT_D10.result', 'SB_PT_D25.result',
    'SB_PT_D75.result', 'SB_PT_D90.result', 'SB_PP_D50.result',
    'SB_PP_D10.result', 'SB_PP_D25.result', 'SB_PP_D75.result',
    'SB_PP_D90.result', 'SB_PT_D50.count', 'SB_PT_D10.count',
    'SB_PT_D25.count', 'SB_PT_D75.count', 'SB_PT_D90.count',
    'SB_PP_D50.count', 'SB_PP_D10.count', 'SB_PP_D25.count',
    'SB_PP_D75.count', 'SB_PP_D90.count'
  ),
  algae = c(
    'XMIAT.result', 'XMIAT.count', 'XMIAT.sd', 'XMIATP.result',
    'XMIATP.count', 'XMIATP.sd', 'PCT_MIATP.result', 'PCT_MIAT1.result',
    'PCT_MIAT1P.result', 'PCT_MAA.result', 'PCT_MCP.result',
    'PCT_MAU.result', 'PCT_MAA.count', 'PCT_MAU.count', 'PCT_MCP.count',
    'PCT_MIAT1.count', 'PCT_MIAT1P.count', 'PCT_MIATP.count',
    'PCT_MAP.count', 'PCT_MAP.result', 'PCT_NSA.count', 'PCT_NSA.result'
  )
)

#' Pad a subfunction's result out to its canonical schema
#'
#' Missing metrics become a row rather than disappearing: `.result` and `.sd`
#' are filled with NA, `.count` with 0. Handles a NULL result (the subfunction
#' errored) and a result that is merely short some columns or samples. Columns
#' the schema does not know about are kept, so adding a metric never silently
#' drops it -- test_metric_schema.R flags the stale schema instead.
#'
#' @param res The subfunction's return value, or NULL if it errored
#' @param f_name Name of the subfunction, used to look up the schema
#' @param ids Sample ids that should be present, from `unique(data$id)`
#'
#' @keywords internal
fill_metric_schema <- function(res, f_name, ids) {

  expected <- metric_schema[[f_name]]

  # unknown subfunction: nothing to pad against, hand back whatever we got
  if (is.null(expected)) {
    return(res)
  }

  blank <- function(cols, rows) {
    out <- as.data.frame(
      lapply(cols, function(cn) if (grepl("\\.count$", cn)) rep(0, length(rows)) else rep(NA_real_, length(rows))),
      stringsAsFactors = FALSE
    )
    names(out) <- cols
    rownames(out) <- rows
    out
  }

  if (is.null(res)) {
    return(blank(expected, ids))
  }

  res <- as.data.frame(res, stringsAsFactors = FALSE)

  # columns the subfunction did not produce
  absent <- setdiff(expected, colnames(res))
  if (length(absent)) {
    res <- cbind(res, blank(absent, rownames(res)))
  }

  # samples the subfunction did not produce
  missing_ids <- setdiff(ids, rownames(res))
  if (length(missing_ids)) {
    res <- rbind(res, blank(colnames(res), missing_ids))
  }

  # keep schema order, then anything new the schema has not been told about yet
  res[, c(expected, setdiff(colnames(res), expected)), drop = FALSE]
}
