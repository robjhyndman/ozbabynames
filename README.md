
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ozbabynames <img src="man/figures/logo.png" align="right" />

The ozbabynames package provides the dataset `ozbabynames`. This
contains popular Australian baby names by sex, state and year.

``` r
library(ozbabynames)
head(ozbabynames)
#>   year           state    sex      name count
#> 1 2024 New South Wales Female Charlotte   383
#> 2 2024 New South Wales Female    Amelia   367
#> 3 2024 New South Wales Female    Olivia   316
#> 4 2024 New South Wales Female       Mia   308
#> 5 2024 New South Wales Female      Isla   298
#> 6 2024 New South Wales Female     Chloe   275
```

## Installation

You can install the development version of ozbabynames from github:

``` r
install_github("robjhyndman/ozbabynames")
```

The CRAN version can be installed using:

``` r
install.packages("ozbabynames")
```

## Related packages

- [babynames](https://hadley.github.io/babynames/) - US baby names from
  1880 to 2017.
- [nzbabynames](https://ekothe.github.io/nzbabynames/) - New Zealand
  baby names from 1900 to 2017.
- [norwaynames](https://github.com/ekothe/norwaynames) - Norway baby
  names from 1880 to 2017.

## Related data

- [Anglosphere baby
  names](https://github.com/kkoopmans/anglosphere-baby-names)

## Example usage

``` r
library(ggplot2)
library(dplyr)

ozbabynames_1952_top_10 <- ozbabynames |>
  filter(year == 1952) |>
  group_by(sex, name) |>
  summarise(count = sum(count)) |>
  arrange(-count) |>
  top_n(10) |>
  ungroup()

ggplot(
  ozbabynames_1952_top_10,
  aes(
    x = reorder(name, count),
    y = count,
    group = sex
  )
) +
  geom_col() +
  facet_grid(sex ~ .,
    scales = "free_y"
  ) +
  coord_flip() +
  ylab("Count") +
  xlab("Name") +
  ggtitle("Top ten male and female names in 1952")
```

<img src="man/figures/README-example-plot-1.png" width="100%" />

And let’s look at the popularity of the package author names, “Rob”,
“Mitchell”, “Nicholas”, and “Jessie”, as well as some similar names.

``` r
author_names <- c("Robin", "Robert", "Mitchell", "Nicholas", "Jessie", "Jessica")

ozbabynames |>
  filter(name %in% author_names) |>
  group_by(name, year) |>
  summarise(count = sum(count)) |>
  ggplot(aes(
    x = year,
    y = count,
    colour = name
  )) +
  geom_line() +
  theme_bw() +
  facet_wrap(~name,
    scales = "free_y"
  ) +
  theme(legend.position = "none")
```

<img src="man/figures/README-explore-author-names-1.png" width="100%" />

And let’s see that animated

``` r
library(gganimate)

ozbabynames |>
  filter(name %in% author_names) |>
  count(name, year, wt = count) |>
  ggplot(aes(
    x = year,
    y = n,
    colour = name,
    group = name,
    label = name,
    fill = name
  )) +
  geom_line(linewidth = 1, linetype = "dotted") +
  geom_label(colour = "white", alpha = 0.75, size = 5) +
  theme_bw() +
  theme(
    panel.grid = element_blank(),
    legend.position = "none",
    title = element_text(
      colour = "purple",
      size = 20,
      face = "bold"
    )
  ) +
  labs(
    title = "number of bubs dubbed in {frame_along} ",
    y = "n babies"
  ) +
  scale_y_log10(labels = scales::comma) +
  transition_reveal(along = year)
```

<img src="man/figures/README-animate-explore-author-names-1.gif" width="100%" />

## Known Issues

The coverage is very uneven, with some states only providing very recent
data, and some states only providing the top 50 or 100 names. The ACT
does not provide counts, and so no ACT data are included. South
Australia has by far the best data, with full coverage of all names back
to 1944.

## Sources

- [South
  Australia](https://data.sa.gov.au/data/dataset/popular-baby-names)

- [New South
  Wales](https://data.nsw.gov.au/data/dataset/popular-baby-names-from-1952)

- Tasmania

  - <https://data.gov.au/dataset/0ec6f374-8b54-4500-ae40-97f39bba9036>
  - <https://data.gov.au/dataset/a37db87d-6bbb-4fb1-96a4-224266b757b8>
  - <https://data.gov.au/dataset/893891b6-2689-4089-84cd-1a7d8647b19e>
  - Only top 10 by rank available after 2016

- [Victoria](https://www.bdm.vic.gov.au/births/naming-your-child/popular-baby-names-in-victoria)

- [Western
  Australia](https://www.wa.gov.au/organisation/department-of-justice/the-registry-of-births-deaths-and-marriages/popular-baby-names)

- [Queensland](https://www.data.qld.gov.au/dataset/top-100-baby-names)

- [Northern Territory](https://nt.gov.au/law/bdm/popular-baby-names)

- [Other data](https://search.data.gov.au/search?q=baby%20names)
