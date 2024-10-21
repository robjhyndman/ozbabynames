library(tidyverse)

sa <- read_csv("data-raw/sa/merged/sa_babynames.csv") %>%
  select(name, sex, year, number) %>%
  rename(count = number) %>%
  mutate(year = as.integer(year)) %>%
  filter(!is.na(name))
