library(purrr)
library(tidyverse)
library(fs)

# Fix files
sa <- map_dfr(fs::dir_ls("data-raw/sa"), function(x){
  writeLines(gsub('""', '"', readLines("data-raw/sa/female_cy1953_top.csv")), tmpfile <- tempfile())
  out <- read_csv(tmpfile, col_names = c("Name", "Amount", "Position"), skip = 1)
  out$sex <- factor(grepl("female", x), levels = c(TRUE, FALSE), labels = c("Female", "Male"))
  out$year <- gsub("[^0-9.]", "", x)
  out$year <- substr(out$year, nchar(out$year) - 4, nchar(out$year))
  out
})

usethis::use_data(sa)
