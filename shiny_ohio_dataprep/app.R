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
  tags$style(type = "text/css", "#myMap {height: calc(100vh - 80px) !important;}"),
  
  titlePanel("Hello Shiny!"),
  
  sidebarLayout(
    
    sidebarPanel(
      sliderInput("obs", "Number of observations:",  
                  min = 1, max = 1000, value = 500)
    ),
    
    mainPanel(
      leafletOutput("myMap")
    )
  
  
  
  
  )
  
  
  
 
)

# Server logic
server <- function(input, output) {
  
  birthdata<-read.csv("ReportOutput-BirthWeight.csv", stringsAsFactors = FALSE)
  
  
  
  myMap <-function(){
    print("here")
    states <- readOGR("county/cb_2015_us_county_20m.shp",
                      layer = "cb_2015_us_county_20m", GDAL1_integer64_policy = TRUE)
    
    Statekey<-read.csv('STATEFPtoSTATENAME_Key.csv', colClasses=c('character'))
    states<-merge(x=states, y=Statekey, by="STATEFP", all=TRUE)
    
    
    neStates <- subset(states, states$STATENAME %in% c(
      "Ohio"
    ))
    
    neStates<-sp::merge(x=neStates, y=birthdata, by.x="NAME", by.y="County", by=x)
    
   #Low.Birth<-as.numeric(birthdata$Low.Birth.Count)[1:88]
   #neStates<-cbind(neStates,Low.Birth)
    #states<-merge(x=states, y=Statekey, by="STATEFP", all=TRUE)
    map<-leaflet(neStates) %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.5,
                  layerId = ~NAME,
                  fillColor = ~colorQuantile("Reds",Low.Birth.Count )(Low.Birth.Count),
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE),
                  popup = ~as.factor(paste0(neStates$NAME,",",neStates$Low.Birth.Count,",",neStates$Norm.Birth.Count)))

    print("here")
    #setView(11, 49,  zoom = 9)
    #map$center<-list(lng=-82.7, lat=35.7)
    map<-map %>% setView(-82, 38.9,  zoom = 7)
  }
  
  output$myMap <- renderLeaflet({
    #print(str(myMap()))
    myMap()
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
