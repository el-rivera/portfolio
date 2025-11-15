################################################################################
# title: Homework 4 - Visualizing spatial data
################################################################################
#
# Your Name Here: Elise Rivera
# Your email here: e.rivera.carvan@earth.miami.edu
# date: due November 16, 2025
#
# Description: The purpose of the following R script is to visualize and map
# capture locations of southern stingrays in the Bimini Islands (The Bahamas),
# which took place between 2015-2020. This data was collected by various
# researchers affiliated with the Bimini Biological Field Station Foundation -
# including Elise Rivera.
#
################################################################################

#### Load packages ####
library(tidyverse)
library(mapview)
library(terra)
library(tidyterra)
library(janitor)
library(ggspatial)
library(rnaturalearth)
library(sf)

#### Load data - relative paths only ####
ray_data <- read.csv("data/raw/RawData06142024.csv") |>
  clean_names() |>
  select(c(pit_tag, date, sex, latitude, longitude)) |>
  filter(!is.na(longitude)) |>
  filter(!is.na(latitude)) |>
  filter(!latitude <= 25.6)
View(ray_data)

# ne_coastlines Bahamas does not include Bimini at all so...
# load in homemade detailed Bimini coastline shapefile for base layer
bimini <- read_sf("data/raw/BiminiDetailed.shp")
bimini #CRS: WGS 84

# make capture points into sf
cap_points <- ray_data |>
  select(longitude, latitude, pit_tag, sex, date) |>
  distinct() |>
  st_as_sf(coords = c("longitude", "latitude")) |>
  st_set_crs(4326) #set crs
plot(cap_points)
cap_points #CRS: WGS 84

#bring in depth data
depth <- rast("data/raw/depth_raster.tif")
depth #CRS: WGS 84 (EPSG:4326)

#test points with coastline
mapview(list(bimini, cap_points))

#crop using Bahamas EEZ
bahamas_eez <- read_sf("data/raw/bahamas_eez/eez.shp")
bahamas_eez #CRS: WGS 84

bahamas_depth <- crop(depth, bahamas_eez, extend = F)

#crop more using cap points
ext(bahamas_depth) <- c(-79.35, -79.2, 25.62, 25.8)

#test map boundaries
mapview(bahamas_depth)

#### Visualize data ####
map <- ggplot() +
  geom_spatraster_contour(data = bahamas_depth,
                          mapping = aes(color = after_stat(level))) + #add depth
  geom_sf(data = bimini |> st_cast("LINESTRING"), color = "red") +
  geom_sf(data = cap_points, color = "grey3") +
  theme_bw() +
  annotation_north_arrow(location = "tl") +
  annotation_scale(location = "bl") +
  labs(x = "Longitude",
       y = "Latitude",
       title = "Southern stingray captures around the Bimini Islands, The Bahamas",
       subtitle = "between 2015-2020",
       caption = "Capture points from Bimini Biological Field Station Foundation
       Bimini shapefile (red) created by Elise Rivera
       Depth data from Global Marine Environment Datasets (GMED)",
       color = "Depth (m)")

plot(map)

#### Save plot as .png - relative paths only ####

ggsave("mapping_capture_points.png", plot = map, path = "results/img", height = 8, width = 8)
