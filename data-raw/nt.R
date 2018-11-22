library(tidyverse)

nt <- read_csv("data-raw/nt/nt_babynames.csv") %>%
  select(name, sex, year, number) %>%
  rename(count = "number") %>%
  mutate(sex = recode(sex,
                 M = "Male",
                 F = "Female"))
