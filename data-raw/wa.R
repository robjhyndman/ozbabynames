library(tidyverse)

wa <- read_csv("data-raw/wa/wa.csv") |>
  select(name, sex, year, count) |>
  mutate(year = as.integer(year)) |>
  filter(!is.na(name))
