# reading in the NSW data with tabulizer
# install.packages("tabulizer")
library(tabulizer)
library(tidyverse)

clean_table <- function(path,
                        pages,
                        area_list,
                        col_gender,
                        year_number,
                        col_cut){
  tabulizer::extract_tables(file = path,
                            pages = pages,
                            guess = FALSE,
                            area = area_list, # T, L, B, R
                            output = "data.frame",
                            method = "stream") %>%
    as.data.frame() %>%
    janitor::clean_names() %>%
    dplyr::mutate(sex = names(.)[col_gender],
                  year = year_number) %>%
    dplyr::select(col_cut) %>%
    dplyr::rename_at(.vars = 1:2,
                     .funs = ~c("name", "count")) %>%
    tibble::as_tibble()
}

extract_nsw_babynames <- function(path,
                                  pages,
                                  year_number){

  all_left_table_p1 <- pmap_dfr(.l = list(pages = pages,
                                          year_number = year_number),
                                .f = clean_table,
                                path = path,
                                area_list = list(c(50, 10, 800, 180)), # TLBR
                                col_gender = 2,
                                col_cut = 2:5)

  all_left_table_p2 <- pmap_dfr(.l = list(pages = pages,
                                          year_number = year_number),
                                          .f = clean_table,
                                          path = path,
                                area_list = list(c(50, 181, 800, 370)), # TLBR,
                                col_gender = 1,
                                col_cut = c(1:2, 4:5))

  all_right_table_p1 <- pmap_dfr(.l = list(pages = pages,
                                           year_number = year_number),
                                 .f = clean_table,
                                 path = path,
                                 area_list = list(c(50, 300, 800, 460)), # TLBR
                                 col_gender = 2,
                                 col_cut = 2:5)

  all_right_table_p2 <- pmap_dfr(.l = list(pages = pages,
                                           year_number = year_number),
                                 .f = clean_table,
                                 path = path,
                                 area_list = list(c(50, 460, 800, 900)), # TLBR
                                 col_gender = 1,
                                 col_cut = everything())

  dplyr::bind_rows(all_left_table_p1,
                   all_left_table_p2,
                   all_right_table_p1,
                   all_right_table_p2)
}

nsw_names_1950s <- extract_nsw_babynames(
  path = "data-raw/nsw/stats-names-1950s.pdf",
  pages = 1:8,
  year_number = 1959:1952)

nsw_names_1960s <- extract_nsw_babynames(
  path = "data-raw/nsw/stats-names-1960s.pdf",
  pages = 1:10,
  year_number = 1969:1960)

nsw_names_1970s <- extract_nsw_babynames(
  path = "data-raw/nsw/stats-names-1970s.pdf",
  pages = 1:10,
  year_number = 1979:1970)

nsw_names_1980s <- extract_nsw_babynames(
  path = "data-raw/nsw/stats-names-1970s.pdf",
  pages = 1:10,
  year_number = 1989:1980)

nsw_names_1990s <- extract_nsw_babynames(
  path = "data-raw/nsw/stats-names-1990s.pdf",
  pages = 1:10,
  year_number = 1999:1990)

nsw_names_2000s <- extract_nsw_babynames(
  path = "data-raw/nsw/stats-names-2000s.pdf",
  pages = 1:10,
  year_number = 2009:2000)

nsw_names_2010s <- extract_nsw_babynames(
  path = "data-raw/nsw/stats-names-2010s.pdf",
  pages = 1:8,
  year_number = 2017:2010)

head(nsw_names_1950s)
tail(nsw_names_1950s)

head(nsw_names_1960s)
tail(nsw_names_1960s)

head(nsw_names_1970s)
tail(nsw_names_1970s)

head(nsw_names_1980s)
tail(nsw_names_1980s)

nsw_names_1990s
nsw_names_2000s
nsw_names_2010s
