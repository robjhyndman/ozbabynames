library(tidyverse)

qld <- read_csv("data-raw/qld/qld_babynames.csv") %>%
  select(name, sex, year, number) %>%
  rename(count = number) %>%
  mutate(year = as.integer(year)) %>%
  filter(!is.na(name))

