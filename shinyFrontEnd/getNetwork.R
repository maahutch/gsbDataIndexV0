library(httr)
library(jsonlite)
library(visNetwork)


#Neo4j

createNetwork <- function(size){
  
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

  nodesID <- data.frame(id = (c(unique(resp[,1]), unique(resp[,3]))))
                      
  nodesVal <- data.frame(resp[,3:6], color = "#175E54")
  
  nodes <- merge(nodesID, nodesVal, by.x = 'id', by.y = 'Dataset', all.x = T)
  
  nodes <- unique(nodes)       
  
  nodes$label <- nodes$id
  
    
  nodes$PageRank    <- ifelse(is.na(nodes$PageRank),     10, as.numeric(nodes$PageRank)*10 )
  nodes$ArticleRank <- ifelse(is.na(nodes$ArticleRank),  10, as.numeric(nodes$ArticleRank)*10 )
  nodes$Eigenvector <- ifelse(is.na(nodes$Eigenvector ), 10, as.numeric(nodes$Eigenvector )*100 )
  
                      
  if(size=='Page Rank'){
    
    nodes$size <- nodes$PageRank
    
  }else if(size == 'Article Rank'){
    
    nodes$size <- nodes$ArticleRank
    
  }else if(size =='Eigen Vector'){
    
    nodes$size <- nodes$Eigenvector
  
  }else{
    nodes$size <- 10
  }
  
  
  
  edges <- unique(data.frame(from = c(resp[,1]), to = c(resp[,3])))
  
  visNetwork(nodes, edges, width = "100%", height = "1000px")
  
}

#createNetwork()
