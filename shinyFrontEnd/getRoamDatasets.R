library(httr)
library(jsonlite)



#Roam

allRoamNames <- function(){
  
  url <- paste0('http://127.0.0.1:5000/allRoamDatasets')  
  
  res <- GET(url)
  
  data <- as.list((content(res, "parsed")))
  
  name <- ''
  
  for(i in (1:length(data))){
    
    dn2 <- data[[i]][['data']]
    
          
    for(j in (1:length(dn2))){
      
      name <- append(name, dn2[[j]][['attributes']][['name']])
      
    }
                 
  }
  
  return(sort(name))
}


