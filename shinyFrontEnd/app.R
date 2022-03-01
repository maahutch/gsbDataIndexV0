library(shiny)

source('getAllDatasets.R')
source('getRedDatasets.R')


ui <- fluidPage(
  titlePanel("GSB Data Index V0"),
  
  fluidRow(
         column(4,
                uiOutput('allNeoName')
                ),
         column(8,
                uiOutput('allRedName')
                ),
         column(12,
                uiOutput('allRoamName')
                )
         
  )
  
  
  
  
  
  
  )



server <- function(input, output){
  
  #Dropdown options from Neo4j
  output$allNeoName <- renderUI({
    selectInput("dataset", "Select DB dataset", choices = allDataNames())
  })
  
  #Dropdown options from Redivis
  output$allRedName <- renderUI({
    selectInput("dataset", "Select Redivis dataset", choices = allRedNames())
  })
  
  #Dropdown options from Roam
  output$allRoamName <- renderUI({
    selectInput("dataset", "Select Roam dataset", choices = allRoamNames())
  })
  
  
  
  
}


shinyApp(ui, server = server)