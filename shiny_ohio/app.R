# Load packages ----
library(shiny)
library(rgdal)
library(magrittr)
library(leaflet)
library(jsonlite)

#Referrenced:
#ShinyLeaflet-tutorial/Shiny-leaflet-tutorial.Rmd at master · SimonGoring/ShinyLeaflet-tutorial
#https://stackoverflow.com/questions/34985889/how-to-get-the-zoom-level-from-the-leaflet-map-in-r-shiny
#https://stackoverflow.com/questions/42798377/shiny-leaflet-ploygon-click-event

# User interface ----
ui <- fluidPage(
  tags$head(
    tags$style(HTML(".leaflet-container { background: #fff; }"))
  ),
  #tags$style(type = "text/css", "#myMap {height: calc(75vh - 80px) !important;}"),
  tags$style(type = "text/css", "#myMap{ height: 500px !important;; }"),
  #mapid { height: 180px; }
  
  titlePanel("Hello Shiny!"),
  
  sidebarLayout(
    
    sidebarPanel(
      sliderInput("obs", "Number of observations:",  
                  min = 1, max = 1000, value = 500)
    ),
    
    mainPanel(
      leafletOutput("myMap"),
      tags$div("Source: Data was obtained from public facing website Ohio Department of Health Ohio Public Warehouse: http://publicapps.odh.ohio.gov/EDW/DataBrowser/Browse/OhioLiveBirths")
    ),
  
  
    
  
  )
  
  
  
 
)

# Server logic
server <- function(input, output) {
  
  
  
  
  
 
  
  output$myMap <- renderLeaflet({
   readRDS("map.rds")
  })
  
  
  observeEvent(input$myMap_shape_click, { # update the location selectInput on map clicks
    p <- input$myMap_shape_click
    p2<-input$myMap_center
    p3<-input$myMap_zoom
    print(p)
    print(str(p2))
    print(str(p3))
  }) 
  
  
}

# Run the app
shinyApp(ui, server)
