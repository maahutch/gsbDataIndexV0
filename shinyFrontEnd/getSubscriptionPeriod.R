library(httr)
library(jsonlite)


#Roam - Subscription Periods


getSubPeriod <- function(dataset){
  
  ds2 <- gsub(" ", "%20", dataset)
  
  url <- paste0('http://127.0.0.1:5000/subscriptionPeriod/', ds2)  
  
  res <- GET(url)
  
  if(res$status_code == 200){
  
    data <- fromJSON(rawToChar(res$content))
    
    response <- data.frame(data$Roam)
    
    names <- colnames(response)
    
    resp2 <- cbind(response$id, 
                   response$type, 
                   response$attributes,
                   response$relationships)
  }else{
    resp2 <- data.frame(Label = "", Value = "No Result Found")
  }
  return(resp2)
}