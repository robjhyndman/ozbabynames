library(tidyverse)

nsw <- read_csv("data-raw/nsw/nsw_babynames.csv") %>%
  select(name, sex, year, number) %>%
  rename(count = number) %>%
  mutate(year = as.integer(year)) %>%
  filter(!is.na(name))
