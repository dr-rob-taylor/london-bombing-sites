#remotes::install_github("geotheory/londonShapefiles")
#remotes::install_github("pachadotdev/ukmaps")

library(ukmaps)
library(londonShapefiles)

crs_bng <- 27700

v1_bomb_data <- sf::st_read(dsn = "data/london-bomb-impacts.kml", 
                            layer = "V1", 
                            as_tibble = TRUE) |> 
                sf::st_transform( crs = crs_bng)

v2_bomb_data <- sf::st_read(dsn = "data/london-bomb-impacts.kml", 
                            layer = "V2", 
                            as_tibble = TRUE) |> 
                sf::st_transform( crs = crs_bng)

sf_thames <- sf::read_sf("shapefiles/river_thames.shp") |> 
             sf::st_transform( crs = crs_bng)

x_min <- 525000
x_max <- 543000
y_min <- 172000
y_max <- 180000
pts <- list(rbind(c(x_min,y_min), c(x_min, y_max), 
                  c(x_max, y_max), c(x_max, y_min), 
                  c(x_min, y_min)))
south_london_box <- sf::st_sfc(sf::st_polygon(pts), crs = crs_bng)

south_london_data <- list(
  coords = c(x_min = x_min, x_max = x_max, 
             y_min = y_min, y_max = y_max),
  polygon = south_london_box
)

save(v1_bomb_data, 
     v2_bomb_data,
     sf_thames,
     south_london_data,
     file = "data/london_bomb_data.RData"
     )


sf::st_crs(sf_thames)
sf::st_crs(bomb_data)

base_plot <- ggplot(sf_thames) +
  geom_sf(fill = "#69b3a2", color = "white") +
  geom_sf(data=bomb_data, col="blue", lwd=0.4, pch=16) +
  theme_void()


xmin = 525000
xmax = 543000
ymin = 172000
ymax = 180000
base_plot+geom_rect(xmin=xmin, xmax=xmax, 
                    ymin=ymin, ymax=ymax,
                    alpha=0.1, fill=NA, colour="red", linewidth=0.5)

pts <- list(rbind(c(xmin,ymin), c(xmin, ymax), c(xmax, ymax), c(xmax, ymin), c(xmin, ymin)))
box <- sf::st_sfc(sf::st_polygon(pts), crs = 27700)
  
base_plot + 
  geom_sf(data = box, color = "red", fill = NA, linewidth = 1L)

in_box <- bomb_data |> sf::st_intersects(box) |> lengths()
bomb_subset <- bomb_data |> filter(as.logical(in_box))

base_plot + 
  geom_sf(data = box, color = "red", fill = NA, linewidth = 1L) +
  geom_sf(data = bomb_subset, color = "black", pch = 16)

step = 500
nrow_x = (xmax-xmin)/step
ncol_y = (ymax-ymin)/step
total_squares <- (nrow_x * ncol_y)
hits_matrix <- matrix(nrow = nrow_x, ncol=ncol_y)

get_hits <- function(xmin, xmax, ymin, ymax){
  pts <- list(rbind(c(xmin,ymin), c(xmin, ymax), c(xmax, ymax), c(xmax, ymin), c(xmin, ymin)))
  box <- sf::st_sfc(sf::st_polygon(pts), crs = 27700)
  in_box <- bomb_data |> sf::st_intersects(box) |> lengths()
  
  return(sum(in_box > 0))
}

for( i in 1:nrow_x ) {
  for( j in 1:ncol_y ){
    hits_matrix[i,j] <- get_hits(xmin = xmin + step * (i-1), 
                                 xmax = xmin + step * i,
                                 ymin = ymin + step * (j-1),
                                 ymax = ymin + step * j
                                 )
  }
}

lambda <- nrow(bomb_subset) / total_squares

comparison_df <- data.frame(num_bombs_per_square = 0:4,
                            poisson = sapply(seq(0, 4), 
                                             function(x) dpois(x, lambda)*total_squares),
                            actual = as.numeric(table(hits_matrix)[1:5]))

comparison_df <- rbind(comparison_df,
                       data.frame(num_bombs_per_square = "5 and over", 
                                  poisson = 576-sum(comparison_df$poisson),
                                  actual = as.numeric(table(hits_matrix))[6]))

chisq.test(comparison_df[c('poisson','actual')])

i <- 2
j <- 3
x_min <- xmin + step * (i-1)
x_max <- xmin + step * i
y_min <- ymin + step * (j-1)
y_max <- ymin + step * j

pts <- list(rbind(c(x_min,y_min), c(x_min, y_max), c(x_max, y_max), c(x_max, y_min), c(x_min, y_min)))
box <- sf::st_sfc(sf::st_polygon(pts), crs = 27700)
base_plot + 
  geom_sf(data = box, color = "red", fill = NA, linewidth = 1L) 
  


d <- boundaries %>%
  filter(region_name == "London") 

ggplot(d) + 
  geom_sf(aes( geometry = geometry), color = "white", fill = "#165976", alpha = 0.7) +
  geom_sf(data = bomb_data, col = "#d04e66", lwd = 0.4, pch = 16) +
  theme_void() +
  labs(title = "V1 Impact Sites Over London") +
  ggspatial::annotation_north_arrow(width = unit(.3,"in"), 
                         pad_y = unit(.1, "in"),location = "br", 
                         which_north = "true") +
  ggspatial::annotation_scale(location = "bl",style = "ticks")



