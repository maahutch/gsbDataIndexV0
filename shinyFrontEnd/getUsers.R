library(httr)
library(jsonlite)


#Neo4j
getUsers <- function(dataset){

  ds2 <- gsub(" ", "%20", dataset)
  
  url <- paste0('http://127.0.0.1:5000/users/', ds2)  
  
  res <- GET(url)
  
  data <- fromJSON(rawToChar(res$content))
  
  if(length(data$Users) > 0){
   
    response <- data.frame(key = data$Users[[1]][[2]]$key)
    
    for(i in 1:length(data$Users)){
      
      oneUser <- data.frame(data$Users[[i]][[2]])
      
      response <- merge(response, oneUser, by="key", all.x=T)

    }
    
    labs <- c("key", make.unique(c(rep("User", ncol(response))), sep = ""))
   
    colnames(response) <- labs[-length(labs)]
    
    response <- data.frame(t(response))
    
    names(response) <- as.character(response[1,])
    
    response <- response[-1,]
    
    response <- response[,-1:-3]
    
    response$pagerank <- NULL
    response$degree <- NULL
    response $eigenvector <- NULL
    
    return(response)
     
  }else{
    
    response <- data.frame(Label = "", Value = "No Current Users Listed")
    
    return(response)
    
  }
  

}