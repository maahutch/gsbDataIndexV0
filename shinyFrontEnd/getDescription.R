library(httr)
library(jsonlite)
library(anytime)


#Description 

getDescription <- function(dataset){
  
  ds2 <- gsub(" ", "%20", dataset)
  
  url <- paste0('http://127.0.0.1:5000/description/', ds2)  
  
  res <- GET(url)
  
  if(res$status_code == 200){
    
    data <- fromJSON(rawToChar(res$content))
    
    response <- data.frame(data$`Dataset Description`[[1]][[2]])
    
    response <- subset(response, response$key != 'airTableID')
    
  }else{
    response <- data.frame(Label = "", Value = "No Result Found")
  }
  return(response)
  
}