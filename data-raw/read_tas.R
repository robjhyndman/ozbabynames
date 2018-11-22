library(tidyverse)

# Tasmania

tas1f <- readxl::read_xlsx("data-raw/tas/tasmaniantopbabynames20102015.xlsx",
    sheet = "Female") %>%
  rename_all(tolower) %>%
  mutate(sex = "female")

tas1m <- readxl::read_xlsx("data-raw/tas/tasmaniantopbabynames20102015.xlsx",
    sheet = "Male") %>%
  rename_all(tolower) %>%
  mutate(sex = "male")

tas2f <- readxl::read_xlsx("data-raw/tas/dataset-topbabynamesfor2015.xlsx",
    sheet = 1) %>%
  rename(
    name = `MOST POPULAR female BABY NAMES FOR 2015 IN DESCENDING ORDER:`,
    number = X__1) %>%
  filter(!is.na(name)) %>%
  mutate(year = 2015, sex = "female")

tas2m <- readxl::read_xlsx("data-raw/tas/dataset-topbabynamesfor2015.xlsx",
    sheet = 2) %>%
  rename(
    name = `MOST POPULAR male BABY NAMES FOR 2015 IN DESCENDING ORDER:`,
    number = X__1) %>%
  filter(!is.na(name)) %>%
  mutate(year = 2015, sex = "male")

tas3 <- readxl::read_xlsx("data-raw/tas/top-baby-names-for-2016.xlsx") %>%
  rename(
    name = `MOST POPULAR female BABY NAMES FOR 2016 IN DESCENDING ORDER:`,
    number = X__1) %>%
  filter(!is.na(name)) %>%
  mutate(year = 2016) %>%
  mutate(sex = c(rep("female", 134), NA, rep("male", 144))) %>%
  filter(!is.na(sex))

tas <- bind_rows(tas1f, tas1m, tas2f, tas2m, tas3)

usethis::use_data(tas)
