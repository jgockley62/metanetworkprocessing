library(dplyr)
synapser::synLogin()

micro_exp <- 'syn27322686'
parentid_micro <- 'syn27408061'
syns_used <- c(micro_exp)
thisFileName <- 'preprocess_allen_data.R'

micro <- data.table::fread(synapser::synGet(micro_exp)$path, header = T, sep='\t') %>%
  tibble::column_to_rownames('feature') %>%
  as.matrix() %>%
  data.frame() %>%
  t()

# Winzorize
microfo <- micro %>%
  as.matrix() %>%
  metanetwork::winsorizeData()

# Round Float Size
micro <- round(micro, 6)

#Push to Synapse:
thisRepo <- githubr::getRepo(repository = "jgockley62/metanetworkprocessing", ref="branch", refName='main')
thisFile <- githubr::getPermlink(repository = thisRepo, repositoryPath=paste0('code/',thisFileName))

#DLPFC
activityName <- 'Mircorglial Expression'
activityDescription <- 'Winzorized Mircorglial SMART-Seq2 Expression for metanetwork analysis'


micro <- tibble::rownames_to_column(as.data.frame(micro), var='feature')
write.table(micro, file = 'micro.tsv', sep ='\t', row.names = F, col.names = T, quote = F)

ENRICH_OBJ <- synapser::synStore( synapser::File( 
  path='micro.tsv', 
  name = 'Microglial Expression',
  parentId=parentid_micro ),
  used = syns_used, 
  activityName = activityName, 
  executed = thisFile, 
  activityDescription = activityDescription
)

micro <-data.table::transpose(micro)
write.table(micro, file = 'micro_transpose.tsv', sep ='\t', row.names = F, col.names = T, quote = F)

ENRICH_OBJ <- synapser::synStore( synapser::File( 
  path='micro_transpose.tsv', 
  name = 'Microglial Expression Transposed',
  parentId=parentid_micro ),
  used = syns_used, 
  activityName = 'Mircorglial Expression Transposed', 
  executed = thisFile, 
  activityDescription = 'Winzorized Mircorglial SMART-Seq2 Expression for metanetwork analysis in Aracne input'
)



