# Combine states into single object

source("data-raw/nt.R")
source("data-raw/qld.R")
source("data-raw/nsw.R")
source("data-raw/sa.R")
source("data-raw/tas.R")
source("data-raw/vic.R")
source("data-raw/wa.R")

ozbabynames <- bind_rows(
  mutate(tas, state = "Tasmania"),
  mutate(nsw, state = "New South Wales"),
  mutate(nt, state = "Northern Territory"),
  mutate(qld, state = "Queensland"),
  mutate(sa, state = "South Australia"),
  mutate(vic, state = "Victoria"),
  mutate(wa, state = "Western Australia")
) |>
  arrange(-year, sex, state, -count) |>
  mutate(
    year = as.integer(year),
    count = as.integer(count)
  ) |>
  select(year, state, sex, name, count)

usethis::use_data(ozbabynames, overwrite = TRUE)
