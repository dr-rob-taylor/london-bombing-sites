
library(ukmaps)
library(sf)
library(ggspatial)

#
# Replication of the analysis conducted by Liam P. Shaw and Luke F. Shaw
# in their article "The Flying Bomb and the Actuary"
# https://doi.org/10.1111/j.1740-9713.2019.01315.x
#
# Data from map:
# https://www.google.com/maps/d/u/0/viewer?mid=1VwyxV_e_LAwzbyJPCAF-C7aCRVNA5W7N&ll=51.48638501192002%2C-0.06991432811798037&z=12
#
# Supplementary material and code:
# file:///Users/robtaylor/Downloads/flying-bomb-supplementary-analysis.html#bomb-density
#
#



source("R/get_counts.R")
load("data/london_bomb_data.RData")

save_counts <- !file.exists("data/count_data.RData")
if(!save_counts) load("data/count_data.RData")

# London map from ukmaps
d_london <- boundaries %>%
  filter(region_name == "London") 

# Subset V1 data, selecting only those impacts that fall within the 
# South London rectangle
south_rect  <- south_london_data$polygon
in_box      <- v1_bomb_data |> st_intersects(south_rect) |> lengths()
v1_subset   <- v1_bomb_data |> filter(as.logical(in_box))

n_impacts <- nrow(v1_subset)

if(save_counts){
  coords <- south_london_data$coords
  counts <- get_counts( data = v1_subset, 
                        coords = coords )
  save(counts, file = "data/count_data.RData")
}


base_plot <- ggplot(d_london) + 
             geom_sf(aes( geometry = geometry), 
                     color = "white", 
                     fill = "#165976", 
                     alpha = 0.7) +
             theme_void()

p_south_area <- base_plot + 
                geom_sf(data = south_rect, 
                        color = "firebrick3", 
                        fill = NA, 
                        linewidth = 1L) +
                geom_sf(data = v1_subset, 
                        color = "firebrick4", 
                        pch = 16,
                        alpha = 0.7 )


