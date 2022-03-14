library(httr)
library(jsonlite)


#Neo4j

allUserNames <- function(){
  
  url <- paste0('http://127.0.0.1:5000/allUsers')  
  
  res <- GET(url)
  
  data <- fromJSON(rawToChar(res$content))
  
  resp <- data.frame(data)
  
  resp <- append(resp[, 1], 'No Data')
  
  return(sort(resp))
}