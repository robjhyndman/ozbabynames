library(tidyverse)

nt <- read_csv("data-raw/nt/nt_babynames.csv") %>%
  select(name, sex, year, number) %>%
  rename(count = number) %>%
  mutate(year = as.integer(year)) %>%
  filter(!is.na(name))
