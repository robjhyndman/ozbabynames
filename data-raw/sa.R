library(purrr)
library(tidyverse)
library(fs)

# Fix files
read_sa <- function(x) {
  writeLines(gsub('""', '"', readLines(x)), tmpfile <- tempfile())
  out <- read_csv(tmpfile, col_names = c("Name", "Amount", "Position"), skip = 1) %>%
    rename_all(tolower) %>%
    mutate(
      # Extract sex from file name
      sex = ifelse(grepl("female", x), "Female", "Male"),
      # Extract year from file name
      year = gsub("[^0-9.]", "", x),
      year = substr(year, nchar(year) - 4, nchar(year)),
      year = as.integer(year),
      # Make name in title case
      name = str_to_title(name)
      ) %>%
    rename(count = "amount") %>%
    select(name, sex, year, count) %>%
    # Combine duplicates
    group_by(name,sex,year) %>%
    summarise(count = sum(count)) %>%
    ungroup()
  out
}
sa <- map_dfr(fs::dir_ls("data-raw/sa"), read_sa)
