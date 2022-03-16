library(httr)
library(jsonlite)

#Neo4j & Roam

getLicense <- function(dataset){
  
 # ds <- tolower(dataset)
  
  ds2 <- gsub(" ", "%20", dataset)
  
  url <- paste0('http://127.0.0.1:5000/license/', ds2)  
  
  res <- GET(url)
  
  if(res$status_code == 200){
    
    data <- fromJSON(rawToChar(res$content)) 
    

    if(data[[1]][[1]][[1]] == 'TermsAndConditions' && length(data) ==1){
      
      resp <- data.frame(data$Database[[1]][[2]])
      
    }else if(data[[1]][[1]][[1]] != 'TermsAndConditions' && length(data) == 1 ){
      
      all <- data.frame(data$Roam)
      
      license <- subset(all, all$type =='licenses')
      
      resp <- data.frame(t(license))
      
      resp <- data.frame(key = c('createdAt',
                                  'name',
                                  'updatedAt',
                                  'endDate', 
                                  'startDate',
                                  'summary',
                                  'id'),
                          value = resp[1:7,])
      
    }else if (length(data) == 2){
    
      top <- data.frame(data$Database[[1]][[2]])
      
      all <- data.frame(data$Roam)
      
      license <- subset(all, all$type =='licenses')
      
      resp <- data.frame(t(license))
      
      bottom <- data.frame(key = c('createdAt',
                                 'name',
                                 'updatedAt',
                                 'endDate', 
                                 'startDate',
                                 'summary',
                                 'id'),
                         value = resp[1:7,])
      
      resp <- rbind(top, bottom)
      
    }
    
  }else{
      resp <- data.frame(Label = "", Value = "No Result Found")
  }
  return(resp)
   
}

#dataset <- 'Visa'

#dataset <- 'Airtable'

#dataset <- 'Orbis'
