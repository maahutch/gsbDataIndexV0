library(httr)
library(jsonlite)


#Roam

allRoamNames <- function(){
  
  url <- paste0('http://127.0.0.1:5000/allRoamDatasets')  
  
  res <- GET(url)
  
  data <- as.list((content(res, "parsed")))
  
  name <- 'Names'
  
  for(i in (1:length(data))){
    
    dn2 <- data[[i]][['data']]
    
          
    for(j in (1:length(dn2))){
      
      name <- append(name, dn2[[j]][['attributes']][['name']])
      
    }
                 
  }

  return(name)
}



resp <- allRoamNames() 

View(resp)
#############################################################
#############################################################

size <- 1:length(data)

outerLoop <- function(step, outerData){
  
  dn <- outerData[[step]][['data']]
  
  size2 <- 1:length(dn)
  
  sapply(size2, innerLoop, data = dn)
  
}

innerLoop <- function(step2, data){
  
  data[[step2]][['attributes']][['name']]  
}





  
#url <- paste0('http://127.0.0.1:5000/allRoamDatasets')  
  
#res <- GET(url)
  
#data <- as.list((content(res, "parsed")))

resp2 <- sapply(size, outerLoop, outerData=data) 




