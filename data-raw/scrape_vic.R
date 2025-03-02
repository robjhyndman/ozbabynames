library(rvest)
library(tidyverse)
library(utils)

url <- "https://www.bdm.vic.gov.au/popular-baby-names-victoria"
webpage <- read_html(url)

year_info <- webpage |>
  html_elements(".rpl-content") |>
  html_elements("a") |>
  html_attr("href")

bn_data <- map_df(1:length(year_info), function(i) {
  year_url <- paste0("https://www.bdm.vic.gov.au", year_info[i])
  html <- year_url |>
    read_html()

  year <- html |>
    html_element("h1") |>
    html_text2() |>
    str_squish() |>
    str_sub(start = -4) |>
    as.integer()

  table_data <- html |>
    html_element("table") |>
    html_table(header = TRUE) |>
    janitor::clean_names() |>
    select(-starts_with("position")) |>
    select(-starts_with("rank"))

  table_male <- table_data |>
    select(1:2) |>
    mutate(sex = "Male") |>
    rename(
      name = 1,
      number = 2
    )

  table_female <- table_data |>
    select(3:4) |>
    mutate(sex = "Female") |>
    rename(
      name = 1,
      number = 2
    )

  bind_rows(table_male, table_female) |>
    mutate(year) |>
    filter(name != "")
})

write_csv(bn_data, here::here("data-raw/vic/vic_babynames.csv"))
