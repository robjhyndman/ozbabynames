library(rvest)
library(tidyverse)
library(utils)

url <- 'https://nt.gov.au/law/bdm/popular-baby-names'
webpage <- read_html(url)

year_info <- webpage %>%
  html_elements(".card")

bn_data <- map_df(1:length(year_info), function(i){
  html <- year_info[i]

  year <- html %>%
    html_element('h2') %>%
    html_text2() %>%
    str_squish() %>%
    str_remove_all("Popular names in ") %>%
    as.numeric()

  table_data <- html %>%
    html_element('table') %>%
    html_table() %>%
    .[[1]]

  table_female <- table_data %>%
    select(1:2) %>%
    mutate(sex = "Female") %>%
    rename(name = 1,
           number = 2)

  table_male <- table_data %>%
    select(3:4) %>%
    mutate(sex = "Male") %>%
    rename(name = 1,
           number = 2)

  bind_rows(table_male, table_female) %>%
    mutate(year)
})

write.csv(bn_data, here::here("data-raw/nt/nt_babynames.csv"))

