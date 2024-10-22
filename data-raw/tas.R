library(tidyverse)

# Tasmania

tas1f <- readxl::read_xlsx("data-raw/tas/tasmaniantopbabynames20102015.xlsx",
  sheet = "Female"
) |>
  rename_all(tolower) |>
  mutate(sex = "Female")

tas1m <- readxl::read_xlsx("data-raw/tas/tasmaniantopbabynames20102015.xlsx",
  sheet = "Male"
) |>
  rename_all(tolower) |>
  mutate(sex = "Male")

tas2f <- readxl::read_xlsx("data-raw/tas/dataset-topbabynamesfor2015.xlsx",
  sheet = 1
) |>
  rename(
    name = 1,
    number = 2
  ) |>
  filter(!is.na(name)) |>
  mutate(year = 2015, sex = "Female")

tas2m <- readxl::read_xlsx("data-raw/tas/dataset-topbabynamesfor2015.xlsx",
  sheet = 2
) |>
  rename(
    name = 1,
    number = 2
  ) |>
  filter(!is.na(name)) |>
  mutate(year = 2015, sex = "Male")

tas3 <- readxl::read_xlsx("data-raw/tas/top-baby-names-for-2016.xlsx") |>
  rename(
    name = 1,
    number = 2
  ) |>
  filter(!is.na(name)) |>
  mutate(year = 2016) |>
  mutate(sex = c(rep("Female", 134), NA, rep("Male", 144))) |>
  filter(!is.na(sex))

tas <- bind_rows(tas1f, tas1m, tas2f, tas2m, tas3) |>
  rename(count = number) |>
  select(name, sex, year, count) |>
  mutate(
    name = str_to_title(name),
    year = as.integer(year),
    count = as.integer(count)
  )
