library(httr)
library(jsonlite)

#Neo4j & Roam

getPublisher <- function(dataset){
  
  ds2 <- gsub(" ", "%20", dataset)
  
  url <- paste0('http://127.0.0.1:5000/publisher/', ds2)  
  
  res <- GET(url)
  
  if(res$status_code == 200){
    
    data <- list(fromJSON(rawToChar(res$content)) )
    
    if(is.null(data[[1]]$Neo4j) == F && 
       is.null(data[[1]]$Roam)  == T &&
       length(data[[1]]$Neo4j)  != 0){
      
      resNeo <- data.frame(data[[1]]$Neo4j)
      
      resp <- data.frame("key" = resNeo$key, "value" = resNeo$value)
      
    }else if(is.null(data[[1]]$Neo4j)==T | length(data[[1]]$Neo4j) == 0
             && is.null(data[[1]]$Roam) == F){
      
      resRoam <- data.frame(data[[1]]$Roam)
      
      resRoam2 <- subset(resRoam, resRoam$type =='publishers')
      
      resp1 <-  resRoam2$attributes
      
      resp <- data.frame('key'   = c("name", "createdAt", "updatedAt"),
                         'value' = c(resp1$name,
                                     resp1$createdAt,
                                     resp1$updatedAt) )
      
    }else if (is.null(data[[1]]$Roam)  == F && 
              is.null(data[[1]]$Neo4j) == F &&
              length(data[[1]]$Neo4j)  != 0){
      
      resNeo <- data.frame(data[[1]]$Neo4j)
      
      colnames(resNeo) <- c('name2', 'WikidataId')
      
      resRoam <- data.frame(data[[1]]$Roam)
      
      resRoam2 <- subset(resRoam, resRoam$type =='publishers')
      
      resRoam3 <-  resRoam2$attributes
      
      resp <- data.frame('key' = c("name", 
                                    "createdAt", 
                                    "updatedAt",
                                    "WikidataId"),
                          'value' =  c(resRoam3$name,
                                       resRoam3$createdAt,
                                       resRoam3$updatedAt,
                                       resNeo$WikidataId[1]))
    }else{
      resp <- data.frame(Label = "", Value = "No Result Found")
    }
  }else{
    resp <- data.frame(Label = "", Value = "No Result Found")
  }
  return(resp)
}


dataset <- "Orbis Historical - Bureau van Dyck"