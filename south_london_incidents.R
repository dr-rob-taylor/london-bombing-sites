library(dplyr)
library(readr)

# Duplicate reference
# Rows 2 and 3 are in the South London data
# Expect 532 rows but get 534 following join of whole V1 set
# Remove additional rows post join
#
# Name   Description                               geometry
# <chr>  <chr>                                  <POINT [m]>
# 1 V1.295 p128, Hammersmith            Z (523334 178182.4 0)
# 2 V1.295 p143, Anchor and Hope Lane Z (541003.4 179033.9 0)
# 3 V1.534 p165, Stadium Road         Z (542301.6 177000.1 0)
# 4 V1.534 p168, Landstead Road       Z (544667.5 177365.9 0)


v1_bomb_data <- sf::st_read(dsn = "data/london-bomb-impacts.kml", 
                            layer = "V1", 
                            as_tibble = TRUE)

sl_data   <- read_csv("south_london_incident_data.csv", col_type = cols())
data_join <- v1_bomb_data |> 
             left_join(sl_data, by = join_by(Name == id))


# data_join <- merge(v1_bomb_data[,1], sl_data,
#                    by.x = "Name", by.y = "id", 
#                    all = TRUE) |> 
#              subset( !duplicated(id) )
# dim(data_join)[1] != dim(sl_data)[1]

# Export to RData format
south_london_incidents <- data_join
save(south_london_incidents, file = "data/south_london_incidents.RData")

# Drop geometry to export csv for adding incidents
tmp <- as.data.frame(data_join)[,-3]
write.csv(tmp, file = "south_london_incident_data.csv", row.names = F, fileEncoding = "UTF-8")



