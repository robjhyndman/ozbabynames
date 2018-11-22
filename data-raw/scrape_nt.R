library(rvest)
library(tidyverse)
library(utils)

url <- 'https://nt.gov.au/law/bdm/popular-baby-names'
webpage <- read_html(url)
#extract year
years_html <- html_nodes(webpage, '.btn') %>% html_text()
years <- years_html[-(1:4)] %>% parse_number()

#scrape names & occurences
table_html <- html_nodes(webpage,'td , th , #h-476142 .btn')
table_data <- html_text(table_html)
ntmat <- matrix(table_data[-1], ncol=4, byrow=TRUE)


ntf <- tibble(name=ntmat[,1],number=ntmat[,2]) %>% mutate(sex="F") %>%
  mutate(
    name = str_replace_all(name, "\r\n", ""),
    number = str_replace_all(number, "\r\n", ""),
    name = str_replace_all(name, " ", ""),
    number = str_replace_all(number, " ", ""),
    year = cumsum(number=="Occurrences"))

ntm <- tibble(name=ntmat[,3],number=ntmat[,4]) %>% mutate(sex="M")%>%
  mutate(
    name = str_replace_all(name, "\r\n", ""),
    number = str_replace_all(number, "\r\n", ""),
    name = str_replace_all(name, " ", ""),
    number = str_replace_all(number, " ", ""),
    year = cumsum(number=="Occurrences"))


nt <- bind_rows(ntf, ntm) %>%
  mutate(
    year = c(years[ntf$year],years[ntm$year])
  ) %>%
  filter(number != "Occurrences")


write.csv(nt, "nt_babynames.csv")



