#####################################################################################################
##                                         Benchmark data
####################################################################################################
rawData <- ImportRawMSData(grpA = "A", numA = 4, grpB = "B", numB = 4,
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
rawData <- ImportRawMSData(grpA = "nonIBD", numA = 24, grpB = "CD", numB = 24,
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

#
## starting MetaboAnalyst
mSet<-InitDataObjects("pktable", "stat", FALSE)
mSet<-Read.TextData(mSet, "MetaboAnalyst_input.csv", "colu", "disc")
