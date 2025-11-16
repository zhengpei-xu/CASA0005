install.packages("tmap")
library(sf)
shp <- st_read("C:\\Users\\17902\\OneDrive - University College London\\CASA\\CASA0005\\Week1\\homework-1\\statsnz-territorial-authority-2018-generalised-SHP")
summary(shp)
shp %>%
  st_geometry()%>%
  plot()

library(tidyverse)
paid_employee_data <- read_csv("C:/Users/17902/OneDrive - University College London/CASA/CASA0005/Week1/homework-1/nz_PaidEmployee_data.csv",
                               skip = 9,
                               col_names = TRUE)

### join the data
data_joint <- shp%>%
  merge(.,paid_employee_data,
        by.x = "TA2018_V1_",
        by.y = "Area_Code")
  

data_joint%>%head()

library(tmap)
tmap_mode("plot")
data_joint%>%
  qtm(.,fill ="Paid employee")

library(RSQLite)
library(readr)

### export the data
data_joint %>%st_write(.,"C:\\Users\\17902\\OneDrive - University College London\\CASA\\CASA0005\\Week1\\homework-1\\nzland_shp.gpkg",
                       "paid_employee",
                       delete_layer = TRUE)

con <- dbConnect(RSQLite::SQLite(),dbname = "C:\\Users\\17902\\OneDrive - University College London\\CASA\\CASA0005\\Week1\\homework-1\\nzland_shp.gpkg")

con %>% dbDisconnect()


con %>% dbListTables()
con %>% dbWriteTable(.,
                       "nzland_csv",
                       paid_employee_data,
                       overwrite = TRUE)

  



