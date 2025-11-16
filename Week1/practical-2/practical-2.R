

### read data
library(sf)
shape <- st_read("C:\\Users\\17902\\OneDrive - University College London\\CASA\\CASA0005\\Week1\\practical-1\\statistical-gis-boundaries-london\\ESRI\\London_Borough_Excluding_MHW.shp")

### summary the data
summary(shape)
###      NAME             GSS_CODE            HECTARES         NONLD_AREA      ONS_INNER        
### Length:33          Length:33          Min.   :  314.9   Min.   :  0.00   Length:33         
### ode  :character   Mode  :character   Median : 3857.8   Median :  2.30   Mode  :character  
### Mean   : 4832.4   Mean   : 64.22                     
### 3rd Qu.: 5658.5   3rd Qu.: 95.60                     
### Max.   :15013.5   Max.   :370.62                     
### SUB_2009           SUB_2006                  geometry 
### Length:33          Length:33          MULTIPOLYGON :33  
### Class :character   Class :character   epsg:NA      : 0  
### Mode  :character   Mode  :character   +proj=tmer...: 0 
###### 33 lines and 8 columns

### plot 7 maps(8-1)
plot(shape)

### only plot the geometry
shape%>%
  st_geometry()%>%
  plot()

### load csv file
library(tidyverse)
mycsv <- read_csv("C:\\Users\\17902\\OneDrive - University College London\\CASA\\CASA0005\\Week1\\practical-1\\flytippingincidents_PivotTable.csv")

shape2 <- shape%>%
  merge(.,
        mycsv,
        by.x = "GSS_CODE",
        by.y = "Row Labels")

shape2%>%head(.,10)

library(tmap)
tmap_mode("plot") ### fill "plot" <- "still", fill "view" <- "dynamic"
shape2%>%
  qtm(.,fill = "Grand Total")

### export the data
shape2%>%
  st_write(.,"C:\\Users\\17902\\OneDrive - University College London\\CASA\\CASA0005\\Week1\\practical-2\\london_fly_tipping.gpkg",
           "london_borough_tipping_2011-2018",
           delete_layer = TRUE)

### connect csv to the gpkg

library(RSQLite)
con <- dbConnect(RSQLite::SQLite(),dbname = "C:\\Users\\17902\\OneDrive - University College London\\CASA\\CASA0005\\Week1\\practical-2\\london_fly_tipping.gpkg")
con %>%
  dbListTables()

con %>%
  dbWriteTable(.,
               "orginal_csv",
               mycsv,
               overwrite = TRUE)

con %>%
  dbDisconnect()

