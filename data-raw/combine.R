# Combine states into single object

source("qld.R")
source("sa.R")
source("tas.R")
source("vic.R")

ozbabynames <-
  mutate(tas, state="Tasmania") %>%
  bind_rows(mutate(vic, state="Victoria")) %>%
  bind_rows(mutate(qld, state="Queensland")) %>%
  bind_rows(mutate(sa, state="South Australia")) %>%
  arrange(-year, sex, state, -count)
ozbabynames

usethis::use_data(ozbabynames, overwrite=TRUE)
