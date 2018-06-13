###

# Load XCMS
library(xcms)

# Create the mSet object for storing processed data
mSet <- InitDataObjects("msspec", "stat", FALSE)

# ****Set path to zipped files*****
# This function unzips the uploaded zip file/s, removes it and save it as "upload"
UnzipUploadedFile("~/Desktop/lcms_netcdf.zip", "upload", T)

# Read the unzipped LC/GC-MS spectra (.netCDF, .mzXML, mzData) 
# Detect, align, and group peaks
# Fill in the object (mSet)
mSet <- Read.MSspec(mSet, "upload", "bin", 30.0, 30.0)
mSet <- MSspec.rtCorrection(mSet, 30.0)

# Fill in missing peaks
mSet <- MSspec.fillPeaks(mSet)

# Create the MS spectra data matrix of peak values for each group for further processing and analysis
mSet <- SetupMSdataMatrix(mSet, "into")

# Check if spectra processing is ok, returns a 1 if everything is ok
mSet <- IsSpectraProcessingOK(mSet)

# Sanity check of data, returns a 1 if everything is ok
mSet <- SanityCheckData(mSet)
mSet <- ReplaceMin(mSet)

# Perform Log transformation of data
mSet <- Normalization(mSet, "NULL", "LogNorm", "NULL", "CKD_063", ratio=FALSE, ratioNum=20)
mSet <- PlotNormSummary(mSet, "norm_0_", "png", 72, width=NA)
mSet <- PlotSampleNormSummary(mSet, "snorm_0_", "png", 72, width=NA)

# Perform t-test analysis
mSet <- Ttests.Anal(mSet, F, 0.05, FALSE, TRUE)
mSet <- PlotTT(mSet, "tt_0_", "png", 72, width=NA)

# Perform Empirical Bayesian Analysis of Microarray (and Metabolites) - EBAM
mSet<-EBAM.A0.Init(mSet, FALSE, TRUE)
mSet<-PlotEBAM.A0(mSet, "ebam_view_0_", "png", 72, width=NA)
mSet<-EBAM.Cmpd.Init(mSet, "z.ebam", 0.255, FALSE, TRUE)
mSet<-SetEBAMSigMat(mSet, 0.9);
mSet<-PlotEBAM.Cmpd(mSet, "ebam_imp_0_", "png", 72, width=NA)

