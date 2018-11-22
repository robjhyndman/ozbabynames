# Combine states into single object

source("data-raw/nt.R")
source("data-raw/qld.R")
source("data-raw/sa.R")
source("data-raw/tas.R")
source("data-raw/vic.R")
source("data-raw/wa.R")

ozbabynames <-
  mutate(tas, state="Tasmania") %>%
  bind_rows(mutate(nt, state="Northern Territory")) %>%
  bind_rows(mutate(vic, state="Victoria")) %>%
  bind_rows(mutate(qld, state="Queensland")) %>%
  bind_rows(mutate(sa, state="South Australia")) %>%
  bind_rows(mutate(wa, state="Western Australia")) %>%
  arrange(-year, sex, state, -count)
ozbabynames

usethis::use_data(ozbabynames, overwrite=TRUE)
