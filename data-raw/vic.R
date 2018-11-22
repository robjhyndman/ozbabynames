library(purrr)
library(tidyverse)
library(readxl)


# Fix files
vic <- map_dfr(fs::dir_ls("data-raw/vic"), function(x){
  fname <- tools::file_path_sans_ext(x)

  out <- read_excel(x, skip = 2)
  male <- out[1:3]
  male$sex <- "Male"
  female <- set_names(out[5:7], names(out)[1:3])
  female$sex <- "Female"

  rbind(male, female) %>%
    mutate(year = substr(fname, nchar(fname)-3, nchar(fname)))
})

usethis::use_data(vic)
