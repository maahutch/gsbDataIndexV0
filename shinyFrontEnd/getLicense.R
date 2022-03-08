library(httr)
library(jsonlite)

#Neo4j & Roam

getLicense <- function(dataset){
  
  ds2 <- gsub(" ", "%20", dataset)
  
  url <- paste0('http://127.0.0.1:5000/license/', ds2)  
  
  res <- GET(url)
  
  if(res$status_code == 200){
    
    data <- fromJSON(rawToChar(res$content)) 
  
    if(is.data.frame(data) == F && data != "No Data"){
      
      resp <- data.frame(data[[1]][[2]])
      
    }else if(is.data.frame(data) == T && length(data) > 1 ){
      
      resp <- data.frame(data)
    }else{
      resp <- data.frame(Label = "", Value = "No Result Found")
    }
    
  }else{
      resp <- data.frame(Label = "", Value = "No Result Found")
  }
  return(resp)
   
}