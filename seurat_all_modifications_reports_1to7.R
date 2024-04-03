
# This script recapitulates all the changes made to the original seurat object 
# throughout the 7 reports on the interstitial cells of the hydra

library(Seurat)

int = readRDS("./data/sce_interstitial_Juliano.rds")
seurat = as.Seurat(int, counts = "counts", data=NULL)

seurat = readRDS("data/seurat.Rds")

# Update the gene names in the count matrix
# I updated the gene names when they were determined to be gene of interest 
# in downstream analyses + cell type markers

annot = read.xlsx("./data/mcbi_dataset_MH_annotated.xlsx")
annot$Symbol[] <- lapply(annot$Symbol, function(x) sub("LOC", "", x, fixed = TRUE)) # removing the LOC prefix
annot$Symbol_updated[] <- lapply(annot$Symbol_updated, function(x) sub("LOC", "", x, fixed = TRUE)) # removing the LOC prefix
annot$Symbol = unlist(annot$Symbol) # unlisting it to look like a normal column
annot$Symbol_updated = unlist(annot$Symbol_updated)

temp = data.frame(orig_gene = rownames(seurat))
temp2 = data.frame(updated = annot$Symbol_updated,
                   orig_gene = annot$Symbol) %>% 
  filter(!duplicated(updated))

# if temp2$updated is NA, fill with temp

temp3 = left_join(temp, temp2) # now temp3 is ordered like the genes in seurat

temp3 = 
  temp3 %>%
  mutate(updated = coalesce(updated,orig_gene)) #works

# Added these annotations to the object 

seurat@assays$originalexp@counts@Dimnames[[1]] <- temp3$updated
seurat@assays$originalexp@data@Dimnames[[1]] <- temp3$updated
seurat@assays$originalexp@meta.features = annot

# Filtering and scaling

seurat_f = subset(seurat, subset = nFeature_originalexp > 200 & nFeature_originalexp < 6000)
seurat_f = SCTransform(seurat_f, assay = "originalexp") # not regressing batches of weird experimental design

# Get PCA coord
Idents(seurat_f) = seurat_f@meta.data$batch
seurat_f <- RunPCA(seurat_f, features = VariableFeatures(object = seurat_f))

# Get UMAP + clusters at different resolutions

seurat_f <- RunUMAP(seurat_f, dims = 1:28, seed.use = 054057)
seurat_f <- FindNeighbors(seurat_f, dims = 1:28)
seurat_f <- FindClusters(seurat_f, resolution = 0.025)
seurat_f <- FindClusters(seurat_f, resolution = 0.1)
seurat_f <- FindClusters(seurat_f, resolution = 0.3)

# Attribute cluster identities

seurat_f@meta.data <-
  seurat_f@meta.data %>%
  mutate(attr_clusters=
           ifelse(seurat_clusters == "0", "ISC",
           ifelse(seurat_clusters == "1", "Nb", 
           ifelse(seurat_clusters == "2", "GranG/ZymoG",
           ifelse(seurat_clusters == "3", "earlyGc", 
           ifelse(seurat_clusters == "4", "Nb",
           ifelse(seurat_clusters == "5", "earlyNem",
           ifelse(seurat_clusters == "6", "Nb", 
           ifelse(seurat_clusters == "7", "Nb",
           ifelse(seurat_clusters == "8", "earlyNeur", 
           ifelse(seurat_clusters == "9", "Gc",
           ifelse(seurat_clusters == "10", "Nb", 
           ifelse(seurat_clusters == "11", "ec1A",
           ifelse(seurat_clusters == "12", "ec3", 
           ifelse(seurat_clusters == "13", "Nb",
           ifelse(seurat_clusters == "14", "ec2",
           ifelse(seurat_clusters == "15", "Nb", 
           ifelse(seurat_clusters == "16", "ec1A/ec1B",
           ifelse(seurat_clusters == "17", "ec3", 
           ifelse(seurat_clusters == "18", "en",
           ifelse(seurat_clusters == "19", "ec4", 
           ifelse(seurat_clusters == "20", "Nb",
            NA))))))))))))))))))))))

# Change the metadata to get better order on the graphs

seurat_f@meta.data =
  seurat_f@meta.data %>%
  mutate(Timepoint =
           ifelse(EXP_TIME == "REG_FOOT_t6", "REG_FOOT_t06",
                  ifelse(EXP_TIME == "REG_HEAD_t6", "REG_HEAD_t06", EXP_TIME)))



seurat_f$Timepoint <- factor(seurat_f$Timepoint, 
                             levels=c("REG_HEAD_t0", 
                                      "REG_HEAD_t06", 
                                      "REG_HEAD_t12", 
                                      "REG_HEAD_t24", 
                                      "REG_HEAD_t48", 
                                      "REG_HEAD_t96",
                                      "REG_FOOT_t0", 
                                      "REG_FOOT_t06", 
                                      "REG_FOOT_t12", 
                                      "REG_FOOT_t24", 
                                      "REG_FOOT_t48", 
                                      "REG_FOOT_t96"))

seurat_f$vals.axis_k25 <- as.numeric(seurat_f$vals.axis_k25)
seurat_f$vals.ccycle <- as.numeric(seurat_f$vals.ccycle)
seurat_f$vals.apopt <- as.numeric(seurat_f$vals.apopt)



