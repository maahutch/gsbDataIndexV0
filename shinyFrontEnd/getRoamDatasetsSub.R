outerLoop <- function(step, outerData){
  
  dn <- outerData[[step]][['data']]
  
  size2 <- 1:length(dn)
  
  names <- innerLoop(size2, data = dn)
  return(names)
  
}

innerLoop <- function(step2, data){
  
  data[[step2]][['attributes']][['name']]  
}

