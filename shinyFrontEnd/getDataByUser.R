library(httr)
library(jsonlite)


getDataByUser <- function(sunet){
  
  
  ds2 <- gsub(" ", "%20", sunet)
  
  url <- paste0('http://127.0.0.1:5000/userInfo/', ds2)  
  
  res <- GET(url)
  
  if(res$status_code == 200){
    
    data <- list(fromJSON(rawToChar(res$content)) )
  
    dataDF <- as.data.frame(data[[1]])
    
    df2 <- dataDF[, seq_len(ncol(dataDF)) %% 3 == 0]
    
    df3 <- data.frame(cbind(dataDF[,2], df2))
    
    names(df3) <- as.character(df3[1,])
    
    resp <- df3[-1,]
    
  }else{
    
    resp <- data.frame(Label = "", Value = "No Result Found")
  }
  return(resp)
}
  
  
sunet <- 'laported'
