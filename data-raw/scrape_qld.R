library(rvest)
library(tidyverse)

url <- 'https://www.data.qld.gov.au/dataset/top-100-baby-names'
webpage <- read_html(url)

year_urls <- webpage |>
  html_elements(".resource-item") |>
  html_elements("a") |>
  html_attr("href")

bn_data <- map_df(1:length(year_urls), function(i){
  url <- year_urls[i]

  html <- read_html(paste0("https://www.data.qld.gov.au/",url))

  # there's probably a better way
  csv_url <- html |>
    html_elements(".resource-url-analytics") |>
    html_attr("href") |>
    .[str_detect(., "\\.csv$")] |>
    unique()

  year <- html |>
    html_element('h1') |>
    html_text2() |>
    str_squish() |>
    str_sub(1,4) |>
    as.numeric()

  if(year > 1960){
    table_data <- read_csv(csv_url)

    table_female <- table_data |>
      select(1:2) |>
      mutate(sex = "Female") |>
      rename(name = 1,
             number = 2)

    table_male <- table_data |>
      select(3:4) |>
      mutate(sex = "Male") |>
      rename(name = 1,
             number = 2)

    return(bind_rows(table_male, table_female) |>
      mutate(year))
  } else {
    # handle the last set of years
    table_data <- read_csv(csv_url) |>
      mutate(Name = str_to_sentence(Name)) |>
      rename(name = 1,
             sex = 2,
             year = 3,
             number = 4)
  }
})

write.csv(bn_data, here::here("data-raw/qld/qld_babynames.csv"))

