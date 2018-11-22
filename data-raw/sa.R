library(purrr)
library(tidyverse)
library(fs)

# Fix files
read_sa <- function(x) {
  writeLines(gsub('""', '"', readLines(x)), tmpfile <- tempfile())
  out <- read_csv(tmpfile, col_names = c("Name", "Amount", "Position"), skip = 1) %>%
    rename_all(tolower) %>%
    mutate(
      sex = ifelse(grepl("female", x), "Female", "Male"),
      year = gsub("[^0-9.]", "", x),
      year = substr(year, nchar(year) - 4, nchar(year)),
      year = as.integer(year),
      name = str_to_title(name)
      ) %>%
    rename(count = "amount") %>%
    select(name, sex, year, count)
  out
}
sa <- map_dfr(fs::dir_ls("data-raw/sa"), read_sa)

