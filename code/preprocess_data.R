library(dplyr)
rosmap_exp <- 'syn26967454'
rosmap_meta <- 'syn26967450'

parentid_rosmap <- 'syn27332835'

rosmap <- data.table::fread(synapser::synGet(rosmap_exp)$path, header = T, sep='\t') %>%
  column_to_rownames('feature') %>%
  as.matrix() %>%
  data.frame()
colnames(rosmap) <- gsub('^X','',colnames(rosmap))
colnames(rosmap) <- gsub('.AC','-AC',colnames(rosmap))
colnames(rosmap) <- gsub('.PCC','-PCC',colnames(rosmap))
colnames(rosmap) <- gsub('.DLPFC','-DLPFC',colnames(rosmap))
colnames(rosmap) <- gsub('_SM.','_SM-',colnames(rosmap))
colnames(rosmap) <- gsub('Sample_324.120501','Sample_324-120501',colnames(rosmap))
colnames(rosmap) <- gsub('Sample_161.120423','Sample_161-120423',colnames(rosmap))

rm_cov <- data.table::fread(synapser::synGet(rosmap_meta)$path, header = T, sep='\t') %>%
  column_to_rownames('specimenID') %>%
  data.frame()

# DLPFC
dlpfc <- colnames(rosmap)[ 
  colnames(rosmap) %in% row.names(rm_cov[rm_cov$tissue == 'DLPFC',])
]

dlpfc <- rosmap[ ,dlpfc ] %>%
  as.matrix() %>%
  metanetwork::winsorizeData()

# ACC
acc <- colnames(rosmap)[ 
  colnames(rosmap) %in% row.names(rm_cov[rm_cov$tissue == 'ACC',])
]

acc <- rosmap[ ,acc ] %>%
  as.matrix() %>%
  metanetwork::winsorizeData()

# PCC
pcc <- colnames(rosmap)[ 
  colnames(rosmap) %in% row.names(rm_cov[rm_cov$tissue == 'PCC',])
]

pcc <- rosmap[ ,pcc ] %>%
  as.matrix() %>%
  metanetwork::winsorizeData()

#Push to Synapse:
syns_used <- c(rosmap_exp, rosmap_meta)
thisFileName <- 'preprocess_data.R'
thisRepo <- githubr::getRepo(repository = "jgockley62/metanetworkprocessing", ref="branch", refName='main')
thisFile <- githubr::getPermlink(repository = thisRepo, repositoryPath=paste0('code/',thisFileName))

#DLPFC
activityName <- 'DLPFC Expression'
activityDescription <- 'Winzorized DLPFC Expression for metanetwork analysis'

dlpfc <- tibble::rownames_to_column(as.data.frame(dlpfc), var='feature')
write.table(dlpfc, file = 'dlpfc.tsv', row.names = F, col.names = T, quote = F)

ENRICH_OBJ <- synapser::synStore( synapser::File( 
    path='DLPFC Expression', 
    name = 'DLPFC Expression',
    parentId=parentid_rosmap ),
  used = syns_used, 
  activityName = activityName, 
  executed = thisFile, 
  activityDescription = activityDescription
)

synapser::synSetAnnotations(
  ENRICH_OBJ, 
  annotations = synapser::synGetAnnotations(rosmap_exp)
)
file.remove('dlpfc.tsv')

#ACC
activityName <- 'ACC Expression'
activityDescription <- 'Winzorized ACC Expression for metanetwork analysis'

acc <- tibble::rownames_to_column(as.data.frame(acc), var='feature')
write.table(acc, file = 'acc.tsv', row.names = F, col.names = T, quote = F)

ENRICH_OBJ <- synapser::synStore( synapser::File( 
  path='ACC Expression', 
  name = 'ACC Expression',
  parentId=parentid_rosmap ),
  used = syns_used, 
  activityName = activityName, 
  executed = thisFile, 
  activityDescription = activityDescription
)

synapser::synSetAnnotations(
  ENRICH_OBJ, 
  annotations = synapser::synGetAnnotations(rosmap_exp)
)
file.remove('acc.tsv')

#PCC
activityName <- 'PCC Expression'
activityDescription <- 'Winzorized PCC Expression for metanetwork analysis'

pcc <- tibble::rownames_to_column(as.data.frame(pcc), var='feature')
write.table(pcc, file = 'pcc.tsv', row.names = F, col.names = T, quote = F)

ENRICH_OBJ <- synapser::synStore( synapser::File( 
  path='PCC Expression', 
  name = 'PCC Expression',
  parentId=parentid_rosmap ),
  used = syns_used, 
  activityName = activityName, 
  executed = thisFile, 
  activityDescription = activityDescription
)

synapser::synSetAnnotations(
  ENRICH_OBJ, 
  annotations = synapser::synGetAnnotations(rosmap_exp)
)
file.remove('pcc.tsv')


