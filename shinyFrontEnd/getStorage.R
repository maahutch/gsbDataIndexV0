library(httr)
library(jsonlite)
library(anytime)
library(rlang)

source("getStorageSub.R")

#Storage 

getStorage <- function(dataset){
  
  ds2 <- gsub(" ", "%20", dataset)
  
  url <- paste0('http://127.0.0.1:5000/storage/', ds2)  
  
  res <- GET(url)
  
  if(res$status_code == 200){
    
    data <- fromJSON(rawToChar(res$content)) 
    
    if(length(data) == 2){
      
      neo <- procNeoResp(data)
      
      red <- procRedResp(data)
      
      response <- rbind(neo, red)
      
    } else if(length(data)==1 && data != "No match"){ 
      
      data2 <- list("Database")
      
      data2$Database <- data
      
      response <- procNeoResp(data2)
      
    } else if (length(data)==26){
      
      data2 <- list("Redivis")
      
      data2$Redivis <- data
      
      response <- procRedResp(data2)
      
    } else {
      
      response <- data.frame(Label = "", Value = "No Result Found")
      
    }
    
    

    
    }else{
    response <- data.frame(Label = "", Value = "No Result Found")
     }
  
  return(response)
}
  
  
