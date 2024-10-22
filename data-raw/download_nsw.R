library(tidyverse)

# https://data.nsw.gov.au/data/dataset?q=baby%20names

csv_url <- "https://data.nsw.gov.au/data/dataset/a677cbe2-91e1-4e45-b771-08830d3d9e41/resource/2adcb228-9101-4c95-a786-b3216539b4a2/download/popular_baby_names_1952_to_2023.csv"

bn_data <- read_csv(csv_url) |>
  select(-Rank) |>
  mutate(Name = str_to_sentence(Name)) |>
  rename(
    name = 1,
    number = 2,
    sex = 3,
    year = 4
  )

write_csv(bn_data, here::here("data-raw/nsw/nsw_babynames.csv"))
