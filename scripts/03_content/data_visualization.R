################################################################################
# title: Assignment 3: Data Visualization
################################################################################
#
# Your Name Here: Elise Rivera
# Your email here: e.rivera.carvan@earth.miami.edu
# date: Nov. 2nd, 2025
#
# Description: Visualization of processed data from Assignment 2, southern
# stingray growth data.
#
################################################################################

###### load packages ######
library(tidyverse)
library(janitor)
library(cowplot)

###### load data ######
ray_data <- readRDS("data/processed/ray_growth_clean2.rds")
View(ray_data)

###### create 2 plots ######

### plot 1 - Disc width vs growth per year scatterplot
p1 <- ggplot(data = ray_data,
       mapping = aes(x = dw_first,
                     y = growth_rate_cmyear)) +
  geom_smooth(color = "seashell4") +
  geom_point(size = 1.5, shape = 21, color = "black", fill = "seagreen") +
  theme_minimal() +
  labs(x = "First disc width (cm)",
       y = "Growth rate (cm per year)",
       title = "Disc width to growth rate relationship",
       subtitle = "by disc width (cm) at first capture",
       caption = "Southern stingray capture data via Bimini Biological Field Station Foundation,
       collected 2015-2020 in Bimini Islands, The Bahamas")
p1

### plot 2 (with 2 panels) - Disc width vs growth per year scatterplot by sex
#females only (n = 57)
f = ray_data[which(ray_data$sex == "f"),]
fplot <- ggplot(data = f,
       mapping = aes(x = dw_first,
                     y = growth_rate_cmyear)) +
  geom_smooth(color = "seashell4") +
  geom_point(size = 1.4, shape = 21, color = "black", fill = "salmon") +
  theme_minimal() +
  labs(x = "First disc width (cm)",
       y = "Growth rate (cm per year)",
       title = "Females")
fplot
#males only (n = 6) - no geom_smooth, not enough points!
m = ray_data[which(ray_data$sex == "m"),]
mplot <- ggplot(data = m,
          mapping = aes(x = dw_first,
                        y = growth_rate_cmyear)) +
  geom_point(size = 1.4, shape = 21, color = "black", fill = "steelblue") +
  theme_minimal() +
  labs(x = "First disc width (cm)",
       y = "Growth rate (cm per year)",
       title = "Males")
mplot
#one panel for females, one for males
p2 <- plot_grid(fplot, mplot,
                rel_heights = c(1,1),
                rel_widths = c(1,1),
                labels = "auto",
                hjust = -0.75)
p2

### bonus plot to show a different geom (not sure if smooth counts)
p3 <- ggplot(ray_data,
       mapping = aes(x = sex)) +
  geom_bar(aes(fill = sex), width = 0.5) +
  theme_minimal() +
  labs(x = "Sex",
       y = "Count",
       title = "Number of individuals captured by sex",
       caption = "Southern stingray capture data via Bimini Biological Field Station Foundation,
       collected 2015-2020 in Bimini Islands, The Bahamas")
p3

###### export plots to results/img (.png) ######
#plot 1
ggsave("dw_vs_growth.png", plot = p1, path = "results/img", height = 7, width = 5)

#plot 2
ggsave("dw_vs_growth_by_sex.png", plot = p2, path = "results/img", height = 5, width = 7)

#plot 3
ggsave("individuals_by_sex.png", plot = p3, path = "results/img", height = 7, width = 5)
