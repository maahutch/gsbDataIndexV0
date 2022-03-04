library(httr)
library(jsonlite)


allRedNames <- function(){
  
  url <- paste0('http://127.0.0.1:5000/allRedDatasets')  
  
  res <- GET(url)
  
  data <- rawToChar(res$content)
  
  resp <- strsplit(data, split=',')
  
  resp <- append(resp[[1]], 'No Data')
  
  return(sort(resp))     
}

