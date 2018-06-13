
R version 3.4.4 (2018-03-15) -- "Someone to Lean On"
Copyright (C) 2018 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> # Script to be executed for batch processing
> 
> # Load XCMS & MetaboAnalystR
> library(xcms)
Loading required package: Biobase
Loading required package: BiocGenerics
Loading required package: parallel

Attaching package: ‘BiocGenerics’

The following objects are masked from ‘package:parallel’:

    clusterApply, clusterApplyLB, clusterCall, clusterEvalQ,
    clusterExport, clusterMap, parApply, parCapply, parLapply,
    parLapplyLB, parRapply, parSapply, parSapplyLB

The following objects are masked from ‘package:stats’:

    IQR, mad, sd, var, xtabs

The following objects are masked from ‘package:base’:

    anyDuplicated, append, as.data.frame, cbind, colMeans, colnames,
    colSums, do.call, duplicated, eval, evalq, Filter, Find, get, grep,
    grepl, intersect, is.unsorted, lapply, lengths, Map, mapply, match,
    mget, order, paste, pmax, pmax.int, pmin, pmin.int, Position, rank,
    rbind, Reduce, rowMeans, rownames, rowSums, sapply, setdiff, sort,
    table, tapply, union, unique, unsplit, which, which.max, which.min

Welcome to Bioconductor

    Vignettes contain introductory material; view with
    'browseVignettes()'. To cite Bioconductor, see
    'citation("Biobase")', and for packages 'citation("pkgname")'.

Loading required package: BiocParallel
Loading required package: MSnbase
Loading required package: mzR
Loading required package: Rcpp
Loading required package: ProtGenerics

This is MSnbase version 2.4.2 
  Visit https://lgatto.github.io/MSnbase/ to get started.


Attaching package: ‘MSnbase’

The following object is masked from ‘package:stats’:

    smooth

The following object is masked from ‘package:base’:

    trimws


This is xcms version 3.0.2 


Attaching package: ‘xcms’

The following object is masked from ‘package:stats’:

    sigma

> library(MetaboAnalystR)
Loading required package: lattice

Attaching package: ‘lattice’

The following object is masked from ‘package:xcms’:

    levelplot

Loading required package: pls

Attaching package: ‘pls’

The following object is masked from ‘package:stats’:

    loadings

> 
> mSet<-InitDataObjects("msspec", "stat", FALSE)
[1] "R objects intialized ..."
> 
> # Set path to zipped folder containing all samples - this function
> # will unzip the folder into a new folder named "upload" in your current working directory
> UnzipUploadedFile("lcms_netcdf.zip", "upload", T);
[1] 1
> 
> # Set path to "upload" file containing the unzipped folders
> # Reads the unzipped LC/GC-MS spectra (.netCDF, .mzXML, mzData) 
> # Detect, align, and group peaks
> # Fill in the object (mSet)
> mSet<-Read.MSspec(mSet, "upload", 'bin', 30.0, 30.0);
Processing 3195 mz slices ... OK
> mSet<-MSspec.rtCorrection(mSet, 30.0);
Performing retention time correction using 133 peak groups.
Processing 3195 mz slices ... OK
> 
> # Fill in missing peaks
> mSet<-MSspec.fillPeaks(mSet);
/home/jasmine/Desktop/upload/ms_netcdf/KO/ko15.CDF 
method:  bin 
step:  0.1 
/home/jasmine/Desktop/upload/ms_netcdf/KO/ko16.CDF 
method:  bin 
step:  0.1 
/home/jasmine/Desktop/upload/ms_netcdf/WT/wt18.CDF 
method:  bin 
step:  0.1 
/home/jasmine/Desktop/upload/ms_netcdf/WT/wt19.CDF 
method:  bin 
step:  0.1 
/home/jasmine/Desktop/upload/ms_netcdf/KO/ko18.CDF 
method:  bin 
step:  0.1 
/home/jasmine/Desktop/upload/ms_netcdf/KO/ko19.CDF 
method:  bin 
step:  0.1 
/home/jasmine/Desktop/upload/ms_netcdf/WT/wt21.CDF 
method:  bin 
step:  0.1 
/home/jasmine/Desktop/upload/ms_netcdf/WT/wt22.CDF 
method:  bin 
step:  0.1 
/home/jasmine/Desktop/upload/ms_netcdf/WT/wt15.CDF 
method:  bin 
step:  0.1 
/home/jasmine/Desktop/upload/ms_netcdf/WT/wt16.CDF 
method:  bin 
step:  0.1 
/home/jasmine/Desktop/upload/ms_netcdf/KO/ko21.CDF 
method:  bin 
step:  0.1 
/home/jasmine/Desktop/upload/ms_netcdf/KO/ko22.CDF 
method:  bin 
step:  0.1 
> 
> # Create the MS spectra data matrix of peak values for each group for further processing and analysis
> mSet<-SetupMSdataMatrix(mSet, "into")
> mSet<-PlotMS.RT(mSet, "msrt_1_", "png", 72, width=NA)
> 
> # Sanity check of data, returns a 1 if everything is ok
> mSet<-SanityCheckData(mSet)
> 
> # Filter and perform missing value imputation
> mSet<-RemoveMissingPercent(mSet, percent=0.5)
> mSet<-ImputeVar(mSet, method="min")
> mSet<-FilterVariable(mSet, "iqr", "F", 25)
[1] " Further feature filtering based on Interquantile Range"
> 
> # Perform auto-scaling of the data
> mSet<-Normalization(mSet, "NULL", "NULL", "AutoNorm", "ko15", ratio=FALSE, ratioNum=20)
> mSet<-PlotNormSummary(mSet, "norm_0_", "png", 72, width=NA)
> mSet<-PlotSampleNormSummary(mSet, "snorm_0_", "png", 72, width=NA)
> 
> # Perform fold-change analysis
> mSet<-FC.Anal.unpaired(mSet, 2.0, 0)
> mSet<-PlotFC(mSet, "fc_0_", "png", 72, width=NA)
> 
> # Perform Empirical Bayesian Analysis of Microarray (and Metabolites) - EBAM
> mSet<-EBAM.A0.Init(mSet, FALSE, TRUE)

We're doing 924 complete permutations
and randomly select 100 of them.

Loading required package: splines
> mSet<-PlotEBAM.A0(mSet, "ebam_view_0_", "png", 72, width=NA)
Warning message:
Some of the logit posterior probabilites are Inf. These probabilities are not plotted. 
> mSet<-EBAM.Cmpd.Init(mSet, "z.ebam", 0.0, FALSE, TRUE)

We're doing 924 complete permutations
and randomly select 100 of them.

> mSet<-SetEBAMSigMat(mSet, 0.9);
> mSet<-PlotEBAM.Cmpd(mSet, "ebam_imp_0_", "png", 72, width=NA)
> 
> 
> proc.time()
   user  system elapsed 
  9.548   0.412  29.642 
