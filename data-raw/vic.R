library(tidyverse)

vic <- read_csv("data-raw/vic/vic_babynames.csv") %>%
  select(name, sex, year, number) %>%
  rename(count = number) %>%
  mutate(year = as.integer(year)) %>%
  filter(!is.na(name))
