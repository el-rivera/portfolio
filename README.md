# portfolio

## Description

The aim of this project is to use southern stingray (Hypanus americanus) recapture data from the Bimini Biological Field Station in The Bahamas to ultimately calculate von Bertalanffy growth parameters. Captures occurred between 2015-2020 and include 301 unique individuals, 90 of which were captured at least 2 times. 


## Columns
pit_tag: character, a unique code associated with each individual which comes from the ray’s Passive Integrated Transponder (PIT) tag

date_first: date, the date the first capture occurred for an individual in Y-M-D format

date_last: date, the date the last capture occurred for an individual in Y-M-D format

dw_first: numeric, the disc width (cm) measurement taken on the date of first capture

dw_last: numeric, the disc width (cm) measurement taken on the date of last capture

date_change_days: numeric, time between first and last capture per individual in days

date_change_years: numeric, time between first and last capture per individual in years

dw_change_cm: numeric, change in disc width (cm) between first and last capture, with negative values removed

growth_rate_cmyear: numeric, individual growth rate in cm per year

## Project Structure

- `data/`: Raw and processed data used in the project 
- `scripts/`: R scripts for analysis
- `results/`: Output figures and tables

## Author

created by Elise S. Rivera, MS student in the Shark Research and Conservation Program at the University of Miami's
Rosenstiel School of Marine, Atmospheric, and Earth Science
