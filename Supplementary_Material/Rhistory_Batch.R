# Script to be executed for batch processing

# Load XCMS & MetaboAnalystR
library(xcms)
library(MetaboAnalystR)

mSet<-InitDataObjects("msspec", "stat", FALSE)

# Set path to zipped folder containing all samples - this function
# will unzip the folder into a new folder named "upload" in your current working directory
UnzipUploadedFile("lcms_netcdf.zip", "upload", T);

# Set path to "upload" file containing the unzipped folders
# Reads the unzipped LC/GC-MS spectra (.netCDF, .mzXML, mzData) 
# Detect, align, and group peaks
# Fill in the object (mSet)
mSet<-Read.MSspec(mSet, "upload", 'bin', 30.0, 30.0);
mSet<-MSspec.rtCorrection(mSet, 30.0);

# Fill in missing peaks
mSet<-MSspec.fillPeaks(mSet);

# Create the MS spectra data matrix of peak values for each group for further processing and analysis
mSet<-SetupMSdataMatrix(mSet, "into")
mSet<-PlotMS.RT(mSet, "msrt_1_", "png", 72, width=NA)

# Sanity check of data, returns a 1 if everything is ok
mSet<-SanityCheckData(mSet)

# Filter and perform missing value imputation
mSet<-RemoveMissingPercent(mSet, percent=0.5)
mSet<-ImputeVar(mSet, method="min")
mSet<-FilterVariable(mSet, "iqr", "F", 25)

# Perform auto-scaling of the data
mSet<-Normalization(mSet, "NULL", "NULL", "AutoNorm", "ko15", ratio=FALSE, ratioNum=20)
mSet<-PlotNormSummary(mSet, "norm_0_", "png", 72, width=NA)
mSet<-PlotSampleNormSummary(mSet, "snorm_0_", "png", 72, width=NA)

# Perform fold-change analysis
mSet<-FC.Anal.unpaired(mSet, 2.0, 0)
mSet<-PlotFC(mSet, "fc_0_", "png", 72, width=NA)

# Perform Empirical Bayesian Analysis of Microarray (and Metabolites) - EBAM
mSet<-EBAM.A0.Init(mSet, FALSE, TRUE)
mSet<-PlotEBAM.A0(mSet, "ebam_view_0_", "png", 72, width=NA)
mSet<-EBAM.Cmpd.Init(mSet, "z.ebam", 0.0, FALSE, TRUE)
mSet<-SetEBAMSigMat(mSet, 0.9);
mSet<-PlotEBAM.Cmpd(mSet, "ebam_imp_0_", "png", 72, width=NA)

