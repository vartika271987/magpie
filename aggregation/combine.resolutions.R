# (C) 2008-2016 Potsdam Institute for Climate Impact Research (PIK),
# authors, and contributors see AUTHORS file
# This file is part of MAgPIE and licensed under GNU AGPL Version 3 
# or later. See LICENSE file or go to http://www.gnu.org/licenses/
# Contact: magpie@pik-potsdam.de

# *********************************************************************
# ***     This script combines magpie inputs from a high            ***
# ***        resolution and a low resolution dataset                ***
# *********************************************************************

# Version 1.00
library(landuse)
library(magpie)

############################# BASIC CONFIGURATION #######################################
if(!exists("source_include")) {
  input_spam_file<- NULL
  output_spam_file <-NULL
  folder <- NULL
  hcells <- as.vector(as.matrix(read.csv("MAGPIE_Zellnummern_RSF+Rand.csv",head=TRUE,sep=",")))    # All the cells, that shall be represented in high resolution  
  readArgs('input_spam_file','output_spam_file','folder','hcells')
}
#########################################################################################

# read in the spam file:
spam<-as.matrix(read.spam(path(folder,input_spam_file)))

# Affected clusters and relation to cells
cluster_high_res_cells<-c()
for(i in 1:length(hcells)){
  cluster_high_res_cells<-c(cluster_high_res_cells,which(spam[,hcells[i]]>0))
}
cell_info<-cbind(cell=hcells,cluster=cluster_high_res_cells)

cluster.numbers<-sort(unique(cluster_high_res_cells))

# Detection of clusters that are completely disaggregated
fully_disaggregated<-c(rep(NA,length(cluster.numbers)))
for(i in 1:length(cluster.numbers)){
  fully_disaggregated[i]<-identical(length(which(spam[cluster.numbers[i],]>0)),length(which(cluster_high_res_cells==cluster.numbers[i])))
}
cluster_info<-cbind(number=cluster.numbers,fully_disaggregated=fully_disaggregated)
# order from first to last affected cluster
cluster_info[order(cluster_info[,1]),]

############################## Create new spam-file #####################################
# Cells of the considered region and the remaining cells 
# from disaggregated clusters, located also in the particular region, 
# are listed.

# Get the cluster cell relationship
tmp<-new.magpie(paste("GLO",1:dim(spam)[1],sep="."),"y1995","cluster")
tmp[,1,1]<-1:dim(spam)[1]
cluster_cells<-as.vector(speed_aggregate(tmp, t(spam))[,1,1])

suppressWarnings(try(rm(final.spam)))

# Fill all cluster up to the first affected
if(cluster_info[1,1]>1){
  final.spam<-spam[1:(cluster_info[1,1]-1),]
  delete_first<-FALSE
} else{
  final.spam<-spam[1,]
  delete_first=TRUE
}

for(cluster in 1:dim(cluster_info)[1]){
  # Fill the remainder of the cluster if it exists
  if(cluster_info[cluster,2]==FALSE){
    tmp<-spam[cluster_info[cluster,1],]
    tmp[cell_info[which(cell_info[,2]==cluster_info[cluster,1]),1]]<-0
    final.spam<-rbind(final.spam,tmp)
  }
  # Now add the cells that are extracted from cluster
  cells<-cell_info[which(cell_info[,2]==cluster_info[cluster,1]),1]
  tmp<-array(0,dim=c(length(cells),dim(spam)[2]))
  for(i in 1:length(cells)){
    tmp[i,cells[i]]<-1
  }
  final.spam<-rbind(final.spam,tmp)
  
  # Now add the clusters, that lie between cluster and the next cluster
  if(cluster==dim(cluster_info)[1]){
    next_cluster<-dim(spam)[1]+1
  } else {
    next_cluster<-cluster_info[cluster+1,1]
  }
  if(next_cluster>cluster_info[cluster,1]+1){
    tmp<-spam[(cluster_info[cluster,1]+1):(next_cluster-1),]
    final.spam<-rbind(final.spam,tmp)
  }
}
if(delete_first){
  final.spam<-final.spam[2:dim(final.spam)[1],]
}

final.spam<-as.spam(final.spam)
write.spam(final.spam,file_name=path(folder,output_spam_file))

#########################################################################################