
procNeoResp <- function(respList){
  
  neo <- data.frame(respList$Database[[1]][[2]])
  
  neo$key <- c("DatabaseId", "StorageSystem", "StorageSystemAddress", "StorageSystemSecurityStandard" )
 
  return(neo) 
}


procRedResp <- function(respList){
  
  redivis <- data.frame(t(data.frame("CreatedAt"              = anydate((respList$Redivis$createdAt/1000)),
                                     "UpdatedAt"              = anydate((respList$Redivis$updatedAt/1000)),
                                     "CurrentVersion"         = respList$Redivis$currentVersion$tag,
                                     "CurrentVersionReleased" = respList$Redivis$currentVersion$isReleased,
                                     "CurrentVersionUrl"      = respList$Redivis$currentVersion$url,
                                     "Description"            = ifelse(is.null(respList$Redivis$description), 
                                                                       "No Description", 
                                                                       respList$Redivis$description),
                                     "Kind"                   = respList$Redivis$kind,
                                     "Name"                   = respList$Redivis$name,
                                     "SizeOnDisk (gb)"        = sprintf((respList$Redivis$totalNumBytes/1000000000),fmt='%#.2f'),
                                     "Owner"                  = respList$Redivis$owner$name,
                                     "OwnerType"              = respList$Redivis$owner$kind,
                                     "TableCount"             = respList$Redivis$tableCount
  )))
  
  redivis <- data.frame(names = row.names(redivis), redivis)
  row.names(redivis)<- NULL
  
  
  colnames(redivis) <- c("key", "value")
  
  return(redivis)
}