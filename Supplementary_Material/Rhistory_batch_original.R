mSet<-InitDataObjects("msspec", "stat", FALSE)
UnzipUploadedFile("Replacing_with_your_file_path", "upload", T);
mSet<-Read.MSspec(mSet, 'Replacing_with_your_file_path', 'bin', 30.0, 30.0);
mSet<-MSspec.rtCorrection(mSet, 30.0);
MSspec.fillPeaks(mSet);
SetupMSdataMatrix(mSet, "into")
mSet<-PlotMS.RT(mSet, "msrt_1_", "png", 72, width=NA)
mSet<-Read.MSspec(mSet, 'Replacing_with_your_file_path', 'bin', 30.0, 30.0);
mSet<-MSspec.rtCorrection(mSet, 30.0);
MSspec.fillPeaks(mSet);
SetupMSdataMatrix(mSet, "into")
mSet<-PlotMS.RT(mSet, "msrt_2_", "png", 72, width=NA)
mSet<-SanityCheckData(mSet)
mSet<-RemoveMissingPercent(mSet, percent=0.5)
mSet<-ImputeVar(mSet, method="min")
mSet<-FilterVariable(mSet, "iqr", "F", 25)
mSet<-Normalization(mSet, "NULL", "LogNorm", "NULL", ratio=FALSE, ratioNum=20)
mSet<-PlotNormSummary(mSet, "norm_0_", "png", 72, width=NA)
mSet<-PlotSampleNormSummary(mSet, "snorm_0_", "png", 72, width=NA)
mSet<-FC.Anal.unpaired(mSet, 2.0, 0)
mSet<-PlotFC(mSet, "fc_0_", "png", 72, width=NA)
mSet<-EBAM.A0.Init(mSet, FALSE, TRUE)
mSet<-PlotEBAM.A0(mSet, "ebam_view_0_", "png", 72, width=NA)
mSet<-EBAM.Cmpd.Init(mSet, "z.ebam", 0.0, FALSE, TRUE)
mSet<-SetEBAMSigMat(mSet, 0.9);
mSet<-PlotEBAM.Cmpd(mSet, "ebam_imp_0_", "png", 72, width=NA)
