# MetaboAnalystR: An R package for comprehensive analysis of metabolomics data

## Description 

This package contains the R functions and libraries underlying the popular MetaboAnalyst web server, including 500 functions for data processing, normalization, statistical analysis, metabolite set enrichment analysis, metabolic pathway analysis, and biomarker analysis. The package is synchronized with the web server. After installing and loading the package, users will be able to reproduce the same results from their local computers using the corresponding R command history downloaded from MetaboAnalyst, to achieve maximum flexibility and reproducibility.

## Installation 

To install MetaboAnalystR...

```{r, eval=FALSE}

install.packages("devtools")
library(devtools)

```

Imports: Rserve,
    ellipse,
    scatterplot3d,
    pls,
    caret,
    lattice,
    Cairo,
    randomForest,
    igraph,
    caTools,
    e1071,
    gplots,
    som,
    xtable,
    RColorBrewer,
    xcms,
    impute,
    pcaMethods,
    RJSONIO,
    ROCR,
    siggenes,
    globaltest,
    GlobalAncova,
    Rgraphviz,
    KEGGgraph,
    preprocessCore,
    genefilter,
    pheatmap,
    SSPA,
    sva,
    Rcpp,
    pROC,
    data.table
Suggests: knitr,
    rmarkdown