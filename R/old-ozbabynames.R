# old code

p1_boys_p1 <- extract_tables("data-raw/nsw/stats-names-1950s.pdf",
                             pages = 1,
                             guess = FALSE,
                             # area = list(c(50, 10, 800, 170)), # top, left, bottom, right
                             area = list(c(50, 10, 800, 180)), # top, left, bottom, right
                             output = "data.frame",
                             method = "stream") %>%
  as.data.frame() %>%
  janitor::clean_names() %>%
  mutate(sex = names(.)[2],
         year = readr::parse_number(names(.)[1])) %>%
  select(2:5) %>%
  rename_at(.vars = 1:2,
            .funs = ~c("name", "count"))

p1_girls_p1 <-
  extract_tables("data-raw/nsw/stats-names-1950s.pdf",
                 pages = 1,
                 guess = FALSE,
                 area = list(c(50, 181, 800, 370)), # top, left, bottom, right
                 output = "data.frame",
                 method = "stream") %>%
  as.data.frame() %>%
  janitor::clean_names() %>%
  mutate(sex = names(.)[1],
         year = readr::parse_number(names(.)[3])) %>%
  select(c(1,2,4,5)) %>%
  rename_at(.vars = 1:2,
            .funs = ~c("name", "count"))

###
p1_boys_p2 <-
  extract_tables("data-raw/nsw/stats-names-1950s.pdf",
                 pages = 1,
                 guess = FALSE,
                 area = list(c(50, 300, 800, 460)), # top, left, bottom, right
                 output = "data.frame",
                 method = "stream") %>%
  as.data.frame() %>%
  janitor::clean_names() %>%
  mutate(sex = names(.)[2],
         year = readr::parse_number(names(.)[1])) %>%
  select(2:5) %>%
  rename_at(.vars = 1:2,
            .funs = ~c("name", "count"))

###

p1_girls_p2 <-
  extract_tables("data-raw/nsw/stats-names-1950s.pdf",
                 pages = 1,
                 guess = FALSE,
                 area = list(c(50, 460, 800, 900)), # top, left, bottom, right
                 output = "data.frame",
                 method = "stream") %>%
  as.data.frame() %>%
  janitor::clean_names() %>%
  mutate(sex = names(.)[1],
         year = 1959) %>%
  rename_at(.vars = 1:2,
            .funs = ~c("name", "count"))

###

bind_rows(p1_boys_p1,
          p1_boys_p2,
          p1_girls_p1,
          p1_girls_p2)

# reading in the NSW data with tabulizer
# install.packages("tabulizer")
library(tabulizer)

# clean
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

extracted_left_table_p1 <-
  clean_table(path = "data-raw/nsw/stats-names-1950s.pdf",
              pages = 1,
              area_list = list(c(50, 10, 800, 180)), # T, L, B, R
              col_gender = 2,
              year_number = 1959,
              col_cut = 2:5)

extracted_left_table_p2 <-
  clean_table(path = "data-raw/nsw/stats-names-1950s.pdf",
              pages = 1,
              area_list = list(c(50, 181, 800, 370)), # T, L, B, R,
              col_gender = 1,
              year_number = 1959,
              col_cut = c(1:2, 4:5))

extracted_right_table_p1 <-
  clean_table(path = "data-raw/nsw/stats-names-1950s.pdf",
              pages = 1,
              area_list = list(c(50, 300, 800, 460)), # T, L, B, R,
              col_gender = 2,
              year_number = 1959,
              col_cut = 2:5)

extracted_right_table_p2 <-
  clean_table(path = "data-raw/nsw/stats-names-1950s.pdf",
              pages = 1,
              area_list = list(c(50, 460, 800, 900)), # T, L, B, R
              col_gender = 1,
              year_number = 1959,
              col_cut = everything())
