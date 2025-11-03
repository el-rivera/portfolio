################################################################################
# title: EVR628 Assignment 2: Data Wrangling
################################################################################
#
# Your Name Here: Elise Rivera Carvan
# Your email here: e.rivera.carvan@earth.miami.edu
# date: due October 19th, 2025
#
# Description: Raw southern stingray capture data from the Bimini Biological
# Field Station Foundation is cleaned and structured in preparation for
# growth calculations. In the raw data, each row represents one capture event.
# In the cleaned data, each row represents one individual. Added columns
# include first and last date, first and last disc width (cm), change in
# date in days and years, change in disc width, and growth rate in cm/year
#
################################################################################

####### Load packages ######
#install.packages("tidyverse")
library(tidyverse)
#install.packages("janitor")
library(janitor)
#library(EVR628tools)

######## Load in raw data using relative path ######
options(scipen=9999)
ray_data2 <- read.csv("data/raw/RawData06142024.csv", sep=",", header=TRUE,
                  na.strings = c("n.a.",""," ",".", "#WERT!", "#DIV/0!", "n.a", "na", "NA"))
View(ray_data2) #starts with 483 obs, 17 cols

#change data class for date
ray_data2$Date = as.Date(ray_data2$Date)

########### clean and prep data ##########
# create a pipe that will:
ray_data_cleaned <- ray_data2 |>
  clean_names() |> # tidy names
  filter(is.na(disney)) |> #"Y"s removed due to non-standardized measurement protocols
  filter(!is.na(dw_cm)) |>  #remove disc width NAs
  select(c(pit_tag, sex, date, dw_cm)) |> #specify desired columns
  arrange(pit_tag, date) |>
  group_by(pit_tag) |>
  filter(n()>1)  #removed single captures, now has 231 obs, 4 cols
View(ray_data_cleaned)


############## Add new columns #############
# Final goal create a df with one line per individual
# columns needed:
  #pit tag, first dw, last dw, change in dw,
  #first date, last date, change in time (days and years), growth rate (cm per year)

# before doing mutate, need to get rid of unwanted rows (where there are more than 2 caps/individual)
# df of first caps only
first_caps <- ray_data_cleaned[!duplicated(ray_data_cleaned$pit_tag), ]
View(first_caps)
# df of last caps only
last_caps <- ray_data_cleaned[!duplicated(ray_data_cleaned$pit_tag, fromLast = T), ]
View(last_caps)

# merge first and last caps by pit_tag and add/calculate new columns:
  #change in date (days and years), change in dw, growth in cm/year
# and remove growth less than 0, and individuals caught less than 90 days apart
growth_columns <- merge(first_caps, last_caps, by = c("pit_tag" = "pit_tag", "sex" = "sex")) |>
  rename(date_first = date.x, # rename columns using snake case
         date_last = date.y,
         dw_first = dw_cm.x,
         dw_last = dw_cm.y) |>
  relocate(pit_tag, sex, date_first, date_last) |> #put cols in a more appealing order
  mutate(date_change_days = as.numeric(date_last - date_first)) |> #days between captures
  mutate(date_change_years = as.numeric(date_last - date_first)/365) |> #years between captures
  mutate(dw_change_cm = dw_last - dw_first) |> #change in dw
  filter(dw_change_cm >= 0, #remove negative dw_change
         date_change_days > 90) |>  # and caps <90 days apart
  mutate(growth_rate_cmyear = dw_change_cm / date_change_years) #calculate growth rate

View(growth_columns)

write_rds(x = growth_columns, file = "data/processed/ray_growth_clean2.rds")
