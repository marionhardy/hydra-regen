# Transcription factors in *Hydra Vulgaris* regeneration over 96 hours

Rotation in Celina Juliano's lab studying the timeline of hydra regeneration after bisection using scRNAseq obtained from Panagiotis Papasaikas from the Tsiairis lab.

## Introduction

Data from our collaborator Panagiotis rds file for a SingleCellExperiment object containing the single cell data for **the interstitial cells** of *Hydra Vulgaris* during multiples stages of regeneration after bisection

This data was mapped to *Hydra Magnipapillata (105)* "Drop-seq reads from 15 libraries generated for Hydra vulgaris strain AEP were mapped to the 2.0 genome assembly of closely related Hydra vulgaris strain 105
(available at <https://research.nhgri.nih.gov/hydra/>) and processed using the Hydra 2.0 gene models. Strain Hydra vulgaris 105 was formerly referred to as Hydra magnipapillata 105."

The sce object contains only the interstitial cells that were selected by Panagiotis using the ..... markers

The coldata of the object contain cell annotation including

-   quality metrics: nFeature nCount (not MT percentage interestingly)

-   batch info: either 2869 (3162 barcodes), 3113 (10352 barcodes), 3271
    (13279 barcodes), 3357 (3875 barcodes)

-   originating experiments (head or foot regeneration)

-   experimental time points

-   pseudo-axis assignment (vals.axis ranging from 0-1, increasing in
    the foot-tentacle direction)

-   mitotic and apoptotic signatures indices from 0 to 1

The rowdata contains gene annotation, using Entrez-gene identifiers. I
have also noticed that in the sce objects there's

-   PCA, tSNE and UMAP coordinates for reduced dimensions + corrected
    for batch values

-   assay metafeatures hold gene_id, product, gene, is.rib.prot.gene
    (T/F), HypoMarkers (T/F), ccyle (T/F), apopt (T/F) etc

I converted the sce objects into a seurat object and did data processing + analysis.

## Reports summary

-    interstitial_report1
-    interstitial_report2_cluster_attribution
-    interstitial_report2
-    interstitial_report3_cluster_attribution

### Interstitial_report1

Contains the exploration of the data (batches, features, metadata etc)
Quality check based on nFeatures and nCounts (no mitochondrial genes in the 105 genome)
Scaling using SCTransform() and regression (or not) of the batch variable
Selection of the first 28 dimensions for UMAP projection
PCA
UMAP
Clustering at different resolutions (0.025, 0.1, 0.3)

### Interstitial_report2_cluster_attribution



### Interstitial_report2

Contains the same thing as the first report but explores the n_neighbors parameter
Does not contain the regressed data as the batch and timepoints variables overlapped weirdly in the experimental design

### Interstitial_report3_cluster_attribution












