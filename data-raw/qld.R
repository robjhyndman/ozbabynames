library(purrr)
library(tidyverse)
library(fs)

# Fix files
qld <- map_dfr(fs::dir_ls("data-raw/qld"), function(x){
  fname <- tools::file_path_sans_ext(x)
  out <- read_csv(x)
  if(!("Sex" %in% colnames(out))){
    out <- list(out[1:2], out[3:4]) %>%
      map_dfr(function(x){
        if(grepl("Girl", colnames(x)[1])){
          x$Sex <- "Female"
        }
        else{
          x$Sex <- "Male"
        }
        x$year <- as.numeric(substr(fname, nchar(fname) - 3, nchar(fname)))
        colnames(x) <- c("Name", "Count", "Sex", "Year")
        x
      })
  }
}) %>%
  rename(sex = Sex, name = Name, year = Year, count = Count) %>%
  select(name, sex, year, count) %>%
  mutate(year = as.integer(year)) %>%
  filter(!is.na(name))

