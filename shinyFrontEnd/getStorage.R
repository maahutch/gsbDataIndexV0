library(httr)
library(jsonlite)
library(anytime)


#Storage 

getStorage <- function(dataset){
  
  ds2 <- gsub(" ", "%20", dataset)
  
  url <- paste0('http://127.0.0.1:5000/storage/', ds2)  
  
  res <- GET(url)
  
  if(res$status_code == 200){
    
    data <- fromJSON(rawToChar(res$content)) 
    
    if()                       
    
    neo <- data.frame(data$Database[[1]][[2]])
    
    
    neo$key <- c("DatabaseId", "StorageSystem", "StorageSystemAddress", "StorageSystemSecurityStandard" )
    
    redivis <- data.frame(t(data.frame("CreatedAt"              = anydate((data$Redivis$createdAt/1000)),
                                       "UpdatedAt"              = anydate((data$Redivis$updatedAt/1000)),
                                       "CurrentVersion"         = data$Redivis$currentVersion$tag,
                                       "CurrentVersionReleased" = data$Redivis$currentVersion$isReleased,
                                       "CurrentVersionUrl"      = data$Redivis$currentVersion$url,
                                       "Description"            = ifelse(is.null(data$Redivis$description), 
                                                                         "No Description", 
                                                                         data$Redivis$description),
                                       "Kind"                   = data$Redivis$kind,
                                       "Name"                   = data$Redivis$name,
                                       "SizeOnDisk (gb)"        = sprintf((data$Redivis$totalNumBytes/1000000000),fmt='%#.2f'),
                                       "Owner"                  = data$Redivis$owner$name,
                                       "OwnerType"              = data$Redivis$owner$kind,
                                       "TableCount"             = data$Redivis$tableCount
    )))
    
    redivis <- data.frame(names = row.names(redivis), redivis)
    row.names(redivis)<- NULL
    
    
    colnames(redivis) <- c("key", "value")
    colnames(neo)     <- c("key", "value")
    
    response <- rbind(neo, redivis)
    
    
  }else{
    response <- data.frame(Label = "", Value = "No Result Found")
  }
  return(response)
}
  
  
