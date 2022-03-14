library(shiny)

source('getAllDatasets.R')
source('getRedDatasets.R')
source('getRoamDatasets.R')
source('getAllUserNames.R')
source('getDescription.R')
source('getStorage.R')
source('getSubscriptionPeriod.R')
source("getUsers.R")
source("getLicense.R")
source("getNetwork.R")
source("getStaticNetwork.R")

ui <- fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "di_custom.css")
  ),
  
  titlePanel("GSB Data Index V0"),
  
  fluidRow(
         column(4,
                uiOutput('allNeoName' )
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
                                  ),
                         br(),
                         br(),
                         br(),
                         fluidRow(
                            column(
                              dataTableOutput('licenseTable'), width=6
                                   )
                                  )
                                ),
                tabPanel("Publisher",
                         br(),
                         fluidRow(
                                  2,
                                  actionButton('publisherButton', 'Get Publisher')
                                  ),
                         br(),
                         br(),
                         br(),
                         fluidRow(
                            column(
                              dataTableOutput('publisherTable'), width=6
                             )
                           )
                         ),
                tabPanel("Dataset by User",
                         br(),
                         fluidRow(
                                  column(4, 
                                          uiOutput('allUsers')
                                         ),
                                  column(4, 
                                         actionButton('userByDataButton', "Get Datasets")
                                   )
                              ),
                         br(), 
                         br(),
                         br(),
                         fluidRow(
                           column(
                             tableOutput("UserByDataset"), width=6
                           )
                         )
                         
                    ),
                      
                tabPanel("Visualization/Analytics", 
                    br(),
                    tabsetPanel(
                         tabPanel('Dynamic',
                           br(), 
                           fluidRow(
                             column(4, 
                                    selectInput('size',
                                                'Size Dataset nodes by:',
                                                c('', 'Page Rank', 'Article Rank', 'Eigen Vector'))
                             )
                           ),
                           fluidRow(
                             visNetworkOutput('network', height = "750px")
                           )
                         ),
                         tabPanel('Static',
                                  br(),
                                  fluidRow(
                                    column(4, 
                                           selectInput('cluster',
                                                       'Clustering Algorithm:',
                                                       c('', 
                                                         'Louvain', 
                                                         'Fast Greedy',
                                                         'Leiden',
                                                         'Label Propagation'))
                                    )
                                  ),
                                  fluidRow(
                                    plotOutput('staticNetwork', height = "1000px")
                                  )
                                  
                           )
                     )
                         
                )
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
  
  #Dropdown SUNetID's from Neo4j
  output$allUsers <- renderUI({
    selectInput("user",
                "Select a User Name", 
                choices = allUserNames(),
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
  
  
  #Licenses
  observeEvent(input$licenseButton,{
    
    firstDF <- getLicense(input$datasetDB)
    
    if(nrow(firstDF) == 3){
       values$tab.df <- firstDF
     }else{
       values$tab.df <- getLicense(input$datasetRoam)
     }
    
    })
  
  output$licenseTable <- renderDataTable({
    
      return(values$tab.df)
    
  })  
  
  
  #Publisher
  observeEvent(input$publisherButton,{
    
    firstDF <- getPublisher(input$datasetDB)
    
    if(nrow(firstDF) == 3){
      values$tab.df <- firstDF
    }else{
      values$tab.df <- getPublisher(input$datasetRoam)
    }
    
  })
  
  output$publisherTable <- renderDataTable({
    
    return(values$tab.df)
    
  })  
  
  
  #Datasets by User
  observeEvent(input$userByDataButton,{
    values$tab.df <- getDataByUser(input$user)
    
  })
  
  output$UserByDataset <- renderTable({
    return(values$tab.df)
  })
  
  #Dynamic Network Vis
  observeEvent(input$size,{
    values$net <- createNetwork(size=input$size)
  })
  
  output$network <- renderVisNetwork({
    return(values$net)
  })
  
  #Static Network Vis
  observeEvent(input$cluster,{
   
    cluster <- input$cluster
    
  })
  
  output$staticNetwork <- renderPlot({
    par(bg='#EAEAEA')
    net <- createStaticNetwork()
    
    if(input$cluster == ''){
      
      comm <- NULL
      
    }else if(input$cluster == 'Louvain'){
      
      comm <- cluster_louvain(net)
      
    }else if(input$cluster == 'Fast Greedy'){
      
      comm <- cluster_fast_greedy(net)
      
    }else if(input$cluster == 'Leiden'){
      
      comm <- cluster_leiden(net)
      
    }else if(input$cluster == 'Label Propagation'){
      comm <- cluster_label_prop(net)
    }
    
    l <- layout_with_fr(net)
    
    plot(net, 
         vertex.frame.color="#EAEAEA",
         vertex.size=5,
         vertex.label = node3$names,
         vertex.label.cex = 0.75,
         vertex.label.family	='Source Sans Pro',
         layout=l,
         mark.groups = comm)  
  })
  
}


shinyApp(ui, server = server)