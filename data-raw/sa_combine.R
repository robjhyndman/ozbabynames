library(purrr)
library(tidyverse)
library(fs)

read_sa <- function(x){

  read_csv(x, col_names = c("name", "number", "position"), skip = 1) %>%
    # remove names with "?" after them
    filter(!str_detect(name, "\\?")) %>%
    mutate(
      # Extract sex from file name
      sex = ifelse(grepl("female", x), "Female", "Male"),
      # Extract year from file name
      # this does not work
      year = str_extract(x, "\\d{4}"),
      year = as.integer(year),
      # Make name in title case
      name = str_to_title(name)
    ) %>%
    select(name, sex, year, number) %>%
    # Combine duplicates
    group_by(name,sex,year) %>%
    summarise(number = sum(number)) %>%
    ungroup()
}

file_names <- list.files("data-raw/sa", "\\.csv", full.names = TRUE)

sa <- map_df(file_names, read_sa) %>%
  mutate(year = as.integer(year)) %>%
  filter(!is.na(name))

write_csv(sa, here::here("data-raw/sa/merged/sa_babynames.csv"))
