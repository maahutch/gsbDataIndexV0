library(httr)
library(jsonlite)


#Neo4j

allDataNames <- function(dataset){
  
  url <- paste0('http://127.0.0.1:5000/allDatasets')  
  
  res <- GET(url)
  
  data <- fromJSON(rawToChar(res$content))
  
  resp <- data.frame(data)
  
  resp <- append(resp[, 1], '')
  
  return(sort(resp))
}