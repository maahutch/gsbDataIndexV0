library(httr)
library(jsonlite)
library(igraph)

createStaticNetwork <- function(cluster){
  
  
  url <- paste0('http://127.0.0.1:5000/network')  
  
  res <- GET(url)
  
  data <- fromJSON(rawToChar(res$content))
  
  resp <- data.frame(data)
  
  
  colnames(resp) <- c('Name', 
                      'sunet', 
                      'Dataset', 
                      'PageRank',
                      'ArticleRank',
                      'Eigenvector')
  
  edges <- unique(data.frame(from = c(resp[,2]), to = c(resp[,3])))

  
  node <- data.frame(labels = unique(c(edges[,1], edges[,2])))
  
    
  node2 <- data.frame(merge(node, resp, by.x='labels', by.y='sunet', all.x=TRUE)[,1:2])
  
  node2$color <- ifelse(is.na(node2$Name), '#279989', '#67AFD2' )
  
  node2$names <- ifelse(is.na(node2$Name), node2$labels, NA )
  
  node3 <- unique(node2)
  
  net <- graph_from_data_frame(d=edges, vertices=node3, directed = F)
  
  
  
  
  return(net)
}