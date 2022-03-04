library(shiny)

source('getAllDatasets.R')
source('getRedDatasets.R')
source('getRoamDatasets.R')
source('getDescription.R')
source('getStorage.R')
source('getSubscriptionPeriod.R')
source("getUsers.R")


ui <- fluidPage(
  titlePanel("GSB Data Index V0"),
  
  fluidRow(
         column(4,
                uiOutput('allNeoName', )
                ),
         column(4,
                uiOutput('allRedName')
                ),
         column(4,
                uiOutput('allRoamName')
                )
         
  ),
  
  fluidRow(
    
    tabsetPanel(
                type="tabs",
                tabPanel(
                         "Description",
                         br(),
                         fluidRow(
                                  2,
                                  actionButton('descButton', 'Get Data Description')
                                  ),
                         br(),
                         br(),
                         br(), 
                         tableOutput('descriptionTable')
                         ),
                tabPanel(
                        "Storage",
                         br(),
                         fluidRow(
                                  2,
                                  actionButton('storageButton', 'Get Storage Information')
                                  ),
                         br(),
                         br(),
                         br(), 
                         tableOutput('storageTable')
                         ),
                tabPanel("Subscription Period",
                         br(),
                         fluidRow(
                                  2,
                                  actionButton('spButton', 'Get Subscription Period')
                                  ),
                         br(),
                         br(), 
                         br(),
                         dataTableOutput('spTable')
                         ),
                tabPanel("Users",
                         br(),
                         fluidRow(
                                  2,
                                  actionButton('userButton', 'Get Users of Dataset')
                                  ),
                         br(),
                         br(),
                         br(),
                         dataTableOutput('userTable')
                         ),
                tabPanel("License",
                         br(),
                         fluidRow(
                                  2,
                                  actionButton('licenseButton', 'Get License')
                                  )
                         ),
                tabPanel("Publisher",
                         br(),
                         fluidRow(
                                  2,
                                  actionButton('publisherButton', 'Get Publisher')
                                  )
                         ),
                tabPanel("Dataset by User"),
                tabPanel("Analytics")
    )
  )
  
  
  
  
  
  
  )
  



server <- function(input, output){
  
  #Dropdown options from Neo4j
  output$allNeoName <- renderUI({
    selectInput("datasetDB", 
                "Select DB dataset", 
                selected = NULL,
                choices = allDataNames()
                )
  })
  
  #Dropdown options from Redivis
  output$allRedName <- renderUI({
    selectInput("datasetRed", 
                "Select Redivis dataset", 
                choices = allRedNames(),
                selected = NULL)
  })
  
  #Dropdown options from Roam
  output$allRoamName <- renderUI({
    selectInput("datasetRoam", 
                "Select Roam dataset", 
                choices = allRoamNames(),
                selected = NULL)
  })
  
  
  values <-reactiveValues(data=NULL)
  
  #Description
  observeEvent(input$descButton, {
    
    values$tab.df <- getDescription(input$datasetDB)
    
  })
  
  output$descriptionTable <- renderTable({
    if (is.null(values$tab.df)){
      return()}
    else{
      return(values$tab.df)
    }
  })
  
  
  #Storage
  observeEvent(input$storageButton, {
    
    firstDF <- getStorage(input$datasetDB)
    
     if(nrow(firstDF) > 3){
       values$tab.df <- firstDF
     }else{
       values$tab.df <- getStorage(input$datasetRed)
     }
    
  output$storageTable <- renderTable({
      if (is.null(values$tab.df)){
        return()}
      else{
        return(values$tab.df)
      }
    })  
  })
  
  
  #Subscription Period
  observeEvent(input$spButton, {
    
    values$tab.df <- getSubPeriod(input$datasetRoam)
    
  })
  
  output$spTable <- renderDataTable({
    if (is.null(values$tab.df)){
      return()}
    else{
      return(values$tab.df)
    }
  })  
  
  
  #Users
  observeEvent(input$userButton,{
    
    values$tab.df <- getUsers(input$datasetDB)
    
  })
  
  output$userTable <- renderDataTable({
    if (is.null(values$tab.df)){
      return()}
    else{
      return(values$tab.df)
    }
  })  
}


shinyApp(ui, server = server)