#####################################################################################################
##                                         Benchmark data
####################################################################################################
rawData <- ImportRawMSData("~/Desktop/MetaboAnalystR_workflow/MetaboAnalystR_workflow_iHMP/benchmark_data",
                           format = "png", dpi = 72, width = 9)

# Set parameters for peak picking
peakParams <- SetPeakParam(ppm = 5, min_pkw = 10, max_pkw = 60, mzdiff = 0.005)

extPeaks <- PerformPeakPicking(rawData, peakParams, rtPlot = TRUE, pcaPlot = TRUE,
                               format = "png", dpi = 300, width = 9)

# Set parameters for peak annotation
annParams <- SetAnnotationParam(polarity = "positive")
annotPeaks <- PerformPeakAnnotation(extPeaks, annParams)
#
# Format peak list
maPeaks <- FormatPeakList(annotPeaks, annParams, filtIso = FALSE, filtAdducts = FALSE,
                          missPercent = 0.1)

###################################################################################################
##                                           Clinical data
##################################################################################################
rawData <- ImportRawMSData("~/Desktop/MetaboAnalystR_workflow/MetaboAnalystR_workflow_iHMP/iHMP",
                           format = "png", dpi = 72, width = 9)

PlotEIC(rawData, 750, 880, 431.314, 431.318, format = "tiff", dpi = 300)

peakParams <- SetPeakParam(ppm = 5, min_sample_num = 5)
# Perform peak picking
extPeaks <- PerformPeakPicking(rawData, peakParams, rtPlot = TRUE, pcaPlot = TRUE,
                               format = "png", dpi = 300, width = 9)

# Set parameters for peak annotation
annParams <- SetAnnotationParam(polarity = "negative", mz_abs_add = 0.005)
# Perform peak annotation
annotPeaks <- PerformPeakAnnotation(extPeaks, annParams)
#
# Format peak list
maPeaks <- FormatPeakList(annotPeaks, annParams, filtIso = TRUE, filtAdducts = FALSE,
                          missPercent = 0.5)

## starting MetaboAnalyst
mSet<-InitDataObjects("pktable", "stat", FALSE)
mSet<-Read.TextData(mSet, "metaboanalyst_input.csv", "colu", "disc")
mSet<-SanityCheckData(mSet)
mSet<-ReplaceMin(mSet);
mSet<-FilterVariable(mSet, "iqr", "F", 25)
mSet<-PreparePrenormData(mSet)
mSet<-Normalization(mSet, "MedianNorm", "LogNorm", "AutoNorm", ratio=FALSE, ratioNum=20)

# View the OPLS-DA plot
mSet<-OPLSR.Anal(mSet, reg=TRUE)
mSet<-PlotOPLS2DScore(mSet, "opls_score2d_0_", "png", 72, width=NA, 1,2,0.95,0,0)

# Re-perform normalization, without auto-scaling 
mSet<-Normalization(mSet, "MedianNorm", "LogNorm", "NULL", ratio=FALSE, ratioNum=20)

# Perform t-test
mSet<-Ttests.Anal(mSet, F, 0.05, FALSE, TRUE)

# Convert results to mummichog analysis
mSet<-Convert2Mummichog(mSet)
mSet<-Read.PeakListData(mSet, "mummichog_input_2019-03-11.txt");
mSet<-UpdateMummichogParameters(mSet, "5", "negative", 0.25);
mSet<-SanityCheckMummichogData(mSet)

# First perform original mummichog algorithm
mSet<- PerformMummichog(mSet, "hsa_mfn", permNum = 1000)
# Second perform GSEA 
mSet<- PerformGSEA(mSet, "hsa_mfn", permNum = 1000)

# Plot integrating mummichog x fGSEA results
mSet <- PlotIntegPaths(mSet, dpi = 300, width = 10, format = "jpg", labels = "default")
