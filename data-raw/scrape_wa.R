library(purrr)
library(tidyverse)
library(rvest)
library(RSelenium)


# Need to update to new website for data after 2022
# https://www.wa.gov.au/organisation/department-of-justice/the-registry-of-births-deaths-and-marriages/popular-baby-names

remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "firefox"
)

# Need to run selenium docker container
# docker run -d -p 4445:4444 selenium/standalone-firefox:2.53.1

remDr$open()
remDr$navigate("https://bdm.justice.wa.gov.au/_apps/BabyNames/Default.aspx")
remDr$getCurrentUrl()

remDr$executeScript(
  "__doPostBack('ctl00$ctl00$MasterContent$pageContent$lbtHistoricalSearch','')"
)

years <- html_nodes(
  read_html(remDr$getPageSource()[[1]]),
  "#MasterContent_pageContent_ddlHistoricalYears"
) |>
  html_children() |>
  html_text()

wa <- map_dfr(years[-1], function(year) {
  option <- remDr$findElement(
    using = "xpath",
    sprintf("//*/option[@value = '%s']", year)
  )
  option$clickElement()

  btn <- remDr$findElement(
    using = "id",
    "MasterContent_pageContent_btnHistoryGo"
  )
  btn$clickElement()

  html <- read_html(remDr$getPageSource()[[1]])
  tbl <- html_table(html)
  bind_rows(
    tbl[[2]] |> mutate(sex = "Female"),
    tbl[[3]] |> mutate(sex = "Male")
  ) |>
    mutate(year = year)
})

wa <- wa |>
  as_tibble() |>
  select(Name, sex, year, Occurence) |>
  rename(count = "Occurence") |>
  rename_all(tolower) |>
  mutate(year = as.integer(year))

# Add in 2022

html <- read_html("https://bdm.justice.wa.gov.au/_apps/BabyNames/Default.aspx")
tbl <- html_table(html)
wa2022 <- bind_rows(
  tbl[[2]] |> mutate(sex = "Female"),
  tbl[[3]] |> mutate(sex = "Male")
) |>
  mutate(year = 2022) |>
  select(Name, Occurence, sex, year) |>
  rename(count = "Occurence") |>
  rename_all(tolower) |>
  mutate(year = as.integer(year))

wa <- bind_rows(wa, wa2022)

write.csv(wa, file = "data-raw/wa/wa.csv", row.names = FALSE)
