library(purrr)
library(tidyverse)
library(httr2)

# https://www.wa.gov.au/organisation/department-of-justice/the-registry-of-births-deaths-and-marriages/popular-baby-names

topten <- map_dfr(1930:2023, function(i) {
  json <- paste0("https://justice.wa.gov.au/_apps/DoJWebsite/babynames/2/", i, "/X") |>
    request() |>
    req_perform() |>
    resp_body_json()
  tibble(json = json) |>
    unnest_wider(json) |>
    select(year = currentYear, name = name, sex = gender, count = currentYrTotal)
})

latest <- paste0("https://justice.wa.gov.au/_apps/DoJWebsite/babynames/1/~/", c("M", "F")) |>
  map_dfr(function(i) {
    json <- request(i) |>
      req_perform() |>
      resp_body_json()
    tibble(json = json) |>
      unnest_wider(json) |>
      select(year = currentYear, name = name, sex = gender, count = currentYrTotal)
  })

wa <- bind_rows(topten, latest) |>
  mutate(sex = recode(sex, "M" = "Male", "F"  = "Female")) |>
  select(name, sex, year, count) |>
  arrange(desc(year), sex, desc(count), name)

write.csv(wa, file = "data-raw/wa/wa.csv", row.names = FALSE)
