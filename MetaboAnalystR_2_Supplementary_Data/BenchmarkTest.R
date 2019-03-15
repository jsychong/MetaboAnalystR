##
## Peakpicking accuracy check against peak_list and list of mass and RT provided by Li et al. 2018 (Supplementally information S8)

library(spatstat.utils)
# peaklist is the output from MetaboAnalystR 
peaklist <- read.csv("annotated_peaklist.csv")
# remove any features that contain NA 
peaklist <- peaklist[complete.cases(peaklist[, 8:15]),]

# Order based on mz
peaklist <- peaklist[order(peaklist$mz), ]
# calculate fold change for comparison later 
peaklist$foldchange <- rowMeans(cbind(peaklist$SB1,peaklist$SB2,peaklist$SB3,peaklist$SB4), 
                                na.rm = TRUE)/rowMeans(cbind(peaklist$SA1,peaklist$SA2,peaklist$SA3,peaklist$SA4), na.rm = TRUE)

# calculate p-values 
pvals <- rep(NA, nrow(peaklist))
for (i in 1:nrow(peaklist)){
  pvals[i] <- t.test(peaklist[i, 8:11], peaklist[i, 12:15])$p.value
}
peaklist$pvals <- pvals

# reference spreadsheet taken from https://doi.org/10.1016/j.aca.2018.05.001 (first 6 rows manually removed and saved as .csv)
gt <- read.csv("Li2018_SI_TableS8.csv")
gt <- gt[order(gt$m.z),]

# Threshold settings for comparison 
ppm_check <- 10
rt.error <- 0.3

# loop over to store row number of mz & RT match 
i = 1
l <- vector("list", 840)
for (i in 1:length(gt$m.z)){
  correct <- gt$m.z[i]
  correct.rt <- gt$RT..min.[i]
  window <- ppm_check/1000000*correct
  rr <- c(correct - window, correct + window)
  rt.rr <- c((correct.rt - rt.error)*60, (correct.rt + rt.error)*60)
  result <- peaklist[which(inside.range(peaklist$mz, rr) & inside.range(peaklist$rtmin, rt.rr)),]
  l[[i]] <- result
  i <- i + 1
}
## df contains matched features based on mz and RT within the specified threshold. 
df <- do.call(rbind, l)



## ***********************************************************
# Quantification accuracy check 
# ************************************************************

## Thereshold settings for quantification performance check
rt.err <- 0.3*60

## loop over and calculate standard error for fold change 
i = 1
l <- list()
for (i in 1:length(df$mz)){
  match <- df$mz[i]
  match.rt <- df$rtmin[i]
  window <- ppm_check/1000000*match
  rr <- c(match - window, match + window)
  rt.rr <- c((match.rt - rt.err)/60, (match.rt + rt.err)/60)
  result <- inside.range(gt$m.z, rr) & inside.range(gt$RT..min., rt.rr)
  row.num <- match('TRUE',result)
  rel.err <- (abs(gt$Fold.change[row.num] - df$foldchange[i])/gt$Fold.change[row.num])*100
  l[[i]] <- rel.err
  i <- i + 1
}


df$fcmatch <- l
df$fcmatch <- as.numeric(df$fcmatch)



# ********************************************
## Quantification performance calculation
# ********************************************

# subset discriminating features 
df.disc <- subset(df, foldchange < 0.5 | foldchange > 2.0 & pvals < 0.05) ## 96 features considered as discriminating features
# standard error of <20% considered as "accurate" 
length(which(df.disc$fcmatch < 20)) 

# subset background features 
df.bg <- df[!(df$foldchange < 0.5 | df$foldchange > 2.0 & df$pvals < 0.05), ] ## 636 features considered as background matrix 
# standard error of <20% considered as "accurate" 
length(which(df.bg$fcmatch < 20)) 

# output as csv file 
write.csv(df, "matched_peaklist.csv", row.names = FALSE)
