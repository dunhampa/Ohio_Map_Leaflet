main<-function(){
  
  #https://rstudio.github.io/leaflet/shapes.html
  
  library(rgdal)
  library(magrittr)
  library(leaflet)
  library(jsonlite)
  
  # From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
  states <- readOGR("shp/cb_2015_us_state_20m.shp",
                    layer = "cb_2015_us_state_20m", GDAL1_integer64_policy = TRUE)
  
  
  neStates <- subset(states, states$STUSPS %in% c(
    "CT","ME","MA","NH","RI","VT","NY","NJ","PA", "OH"
  ))
  
  leaflet(neStates) %>%
    addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.5,
                fillColor = ~colorQuantile("YlOrRd", ALAND)(ALAND),
                highlightOptions = highlightOptions(color = "white", weight = 2,
                                                    bringToFront = TRUE))
  
  
}


countysub<-function(){
  
  #https://rstudio.github.io/leaflet/shapes.html
  
  library(rgdal)
  library(magrittr)
  library(leaflet)
  library(jsonlite)
  
  # From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
  states <- readOGR("oh/tl_2012_39_cousub.shp",
                    layer = "tl_2012_39_cousub", GDAL1_integer64_policy = TRUE)
  
  
  neStates <-states
  leaflet(neStates) %>%
    addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.5,
                fillColor = ~colorQuantile("YlOrRd", ALAND)(ALAND),
                highlightOptions = highlightOptions(color = "white", weight = 2,
                                                    bringToFront = TRUE))
  
  
}

county<-function(){
  
  #https://rstudio.github.io/leaflet/shapes.html
  
  library(rgdal)
  library(magrittr)
  library(leaflet)
  library(jsonlite)
  
  # From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
  states <- readOGR("county/cb_2015_us_county_20m.shp",
                    layer = "cb_2015_us_county_20m", GDAL1_integer64_policy = TRUE)
  
  Statekey<-read.csv('STATEFPtoSTATENAME_Key.csv', colClasses=c('character'))
  states<-merge(x=states, y=Statekey, by="STATEFP", all=TRUE)
  
  neStates <- subset(states, states$STATENAME %in% c(
    "Ohio"
  ))
  
  states<-merge(x=states, y=Statekey, by="STATEFP", all=TRUE)
  leaflet(neStates) %>%
    addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.5,
                fillColor = ~colorQuantile("Reds", AWATER)(AWATER),
                highlightOptions = highlightOptions(color = "white", weight = 2,
                                                    bringToFront = TRUE),
                popup="Holler")

  
}

ohcounty<-function(){
  
  #https://rstudio.github.io/leaflet/shapes.html
  
  library(rgdal)
  library(magrittr)
  library(leaflet)
  library(jsonlite)
  
  # From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
  counties <- readOGR("ohcounty/REFER_COUNTY.shp",
                    layer = "REFER_COUNTY", GDAL1_integer64_policy = TRUE)
  
  
  leaflet(counties@polygons) %>%
    addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.5,
               
                highlightOptions = highlightOptions(color = "white", weight = 2,
                                                    bringToFront = TRUE))
  
}


