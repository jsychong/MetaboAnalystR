### Downloaded R command history from the MetaboAnalyst web-server

# Below is an example of the downloaded R command history: 
mSet<-InitDataObjects("conc", "stat", FALSE)
mSet<-Read.TextData(mSet, "Replacing_with_your_file_path", "rowu", "disc");
mSet<-SanityCheckData(mSet)
mSet<-RemoveMissingPercent(mSet, percent=0.5)
mSet<-ImputeVar(mSet, method="min")
mSet<-Normalization(mSet, "NULL", "LogNorm", "NULL", "PIF_178", ratio=FALSE, ratioNum=20)
mSet<-PlotNormSummary(mSet, "norm_0_", "png", 72, width=NA)
mSet<-PlotSampleNormSummary(mSet, "snorm_0_", "png", 72, width=NA)
mSet<-FC.Anal.unpaired(mSet, 2.0, 0)
mSet<-PlotFC(mSet, "fc_0_", "png", 72, width=NA)
mSet<-PCA.Anal(mSet)
mSet<-PlotPCAPairSummary(mSet, "pca_pair_0_", "png", 72, width=NA, 5)
mSet<-PlotPCAScree(mSet, "pca_scree_0_", "png", 72, width=NA, 5)
mSet<-PlotPCA2DScore(mSet, "pca_score2d_0_", "png", 72, width=NA, 1,2,0.95,1,0)
mSet<-PlotPCALoading(mSet, "pca_loading_0_", "png", 72, width=NA, 1,2,"scatter", 1);
mSet<-PlotPCABiplot(mSet, "pca_biplot_0_", "png", 72, width=NA, 1,2)
mSet<-PlotPCA3DScore(mSet, "pca_score3d_0_", "json", 1,2,3)
mSet<-SAM.Anal(mSet, "d.stat", FALSE, TRUE)
mSet<-PlotSAM.FDR(mSet, 2.2, "sam_view_0_", "png", 72, width=NA)
mSet<-SetSAMSigMat(mSet, 2.2)
mSet<-PlotSAM.Cmpd(mSet, "sam_imp_0_", "png", 72, width=NA)
mSet<-PlotHeatMap(mSet, "heatmap_0_", "png", 72, width=NA, "norm", "row", "euclidean", "ward.D","bwm", "overview", T, T, NA, T, F)
mSet<-RF.Anal(mSet, 500,7,1)
mSet<-PlotRF.Classify(mSet, "rf_cls_0_", "png", 72, width=NA)
mSet<-PlotRF.VIP(mSet, "rf_imp_0_", "png", 72, width=NA)
mSet<-PlotRF.Outlier(mSet, "rf_outlier_0_", "png", 72, width=NA)
mSet<-SaveTransformedData(mSet)

### Near-identical code to re-run analysis locally, **changing only the path file for Read.TextData**

mSet<-InitDataObjects("conc", "stat", FALSE)

# Altered path in this function
mSet<-Read.TextData(mSet, "http://www.metaboanalyst.ca/MetaboAnalyst/resources/data/human_cachexia.csv", "rowu", "disc");

# Continue as before
mSet<-SanityCheckData(mSet)
mSet<-RemoveMissingPercent(mSet, percent=0.5)
mSet<-ImputeVar(mSet, method="min")

# Perform data normalization
mSet<-Normalization(mSet, "NULL", "LogNorm", "NULL", "PIF_178", ratio=FALSE, ratioNum=20)
mSet<-PlotNormSummary(mSet, "norm_0_", "png", 72, width=NA)
mSet<-PlotSampleNormSummary(mSet, "snorm_0_", "png", 72, width=NA)

# Perform FC analysis
mSet<-FC.Anal.unpaired(mSet, 2.0, 0)
mSet<-PlotFC(mSet, "fc_0_", "png", 72, width=NA)

# Perform PCA analysis
mSet<-PCA.Anal(mSet)
mSet<-PlotPCAPairSummary(mSet, "pca_pair_0_", "png", 72, width=NA, 5)
mSet<-PlotPCAScree(mSet, "pca_scree_0_", "png", 72, width=NA, 5)
mSet<-PlotPCA2DScore(mSet, "pca_score2d_0_", "png", 72, width=NA, 1,2,0.95,1,0)
mSet<-PlotPCALoading(mSet, "pca_loading_0_", "png", 72, width=NA, 1,2,"scatter", 1);
mSet<-PlotPCABiplot(mSet, "pca_biplot_0_", "png", 72, width=NA, 1,2)
mSet<-PlotPCA3DScore(mSet, "pca_score3d_0_", "json", 1,2,3)

# Perform SAM analysis
mSet<-SAM.Anal(mSet, "d.stat", FALSE, TRUE)
mSet<-PlotSAM.FDR(mSet, 2.2, "sam_view_0_", "png", 72, width=NA)
mSet<-SetSAMSigMat(mSet, 2.2)
mSet<-PlotSAM.Cmpd(mSet, "sam_imp_0_", "png", 72, width=NA)

# Perform Heatmap
mSet<-PlotHeatMap(mSet, "heatmap_0_", "png", 72, width=NA, "norm", "row", "euclidean", "ward.D","bwm", "overview", T, T, NA, T, F)

# Perform Random Forest Classification
mSet<-RF.Anal(mSet, 500,7,1)
mSet<-PlotRF.Classify(mSet, "rf_cls_0_", "png", 72, width=NA)
mSet<-PlotRF.VIP(mSet, "rf_imp_0_", "png", 72, width=NA)
mSet<-PlotRF.Outlier(mSet, "rf_outlier_0_", "png", 72, width=NA)

mSet<-SaveTransformedData(mSet)



