library(tidyverse)

qld <- read_csv("data-raw/qld/qld_babynames.csv") |>
  select(name, sex, year, number) |>
  rename(count = number) |>
  mutate(year = as.integer(year)) |>
  filter(!is.na(name))

qld2024 <- read_csv("data-raw/qld/top-100-baby-names-2024.csv")
qld2024 <- bind_rows(
  qld2024[,1:2] |> rename(name = `Girl Names`, count = `Count of Girl Names`) |> mutate(sex = "Female", year = 2024),
  qld2024[,3:4] |> rename(name = `Boy Names`, count = `Count of Boy Names`) |> mutate(sex = "Male", year = 2024)
)

qld <- bind_rows(qld, qld2024) |>
  arrange(desc(year), sex, desc(count))
