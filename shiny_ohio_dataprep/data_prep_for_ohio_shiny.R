data_prep<-function(){
  
  #data prep for shiny app

  
  library(shiny)
  library(rgdal)
  library(magrittr)
  library(leaflet)
  library(jsonlite)
  
  
  setwd("../shiny_ohio_dataprep")
  
  birthdata<-read.csv("ReportOutput-BirthWeight.csv", stringsAsFactors = FALSE)
  

   
  states <- readOGR("county/cb_2015_us_county_20m.shp",
                    layer = "cb_2015_us_county_20m", GDAL1_integer64_policy = TRUE)
  
  Statekey<-read.csv('STATEFPtoSTATENAME_Key.csv', colClasses=c('character'))
  states<-merge(x=states, y=Statekey, by="STATEFP", all=TRUE)
    
    
    neStates <- subset(states, states$STATENAME %in% c(
      "Ohio"
    ))
    
    neStates<-sp::merge(x=neStates, y=birthdata, by.x="NAME", by.y="County", by=x)
    
    map<-leaflet(neStates) %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.5,
                  layerId = ~NAME,
                  fillColor = ~colorQuantile("Reds",Low.Birth.Count )(Low.Birth.Count),
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE),
                  popup = ~as.factor(paste0("<b><font size=\"4\"><center>County: </b>",neStates$NAME,"</font></center>","<b># Low Birth Weight Births: </b>", prettyNum(neStates$Low.Birth.Count,big.mark=","),"<br/>","<b># Normal Birth Weight Births: </b>",prettyNum(neStates$Norm.Birth.Count,big.mark=","))))
    
    map<-map %>% setView(-82.1, 39.9,  zoom = 7)
  
    setwd("../shiny_ohio")
    saveRDS(map, file="map.rds")
  
  
  
  
}