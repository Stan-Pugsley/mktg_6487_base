# arithmetic
2 + 2

a <- 2 + 3

a + 1

a + a

# dataframes, 2 dimensional data structures, can combine different data types
data(mtcars)

print(mtcars)

summary(mtcars)

# subset data frame: [row, column]
mtcars[1:3, 1:3]

# subset based on logical criteria, using square brackets
mtcars[mtcars$mpg > 25, ]

# dplyr:  modern tool for data wrangling.
library(tidyverse)

# filter: subsets data frame by rows
filter(.data = mtcars, mpg > 25)

# summarize: creates summary table
summarize(mtcars, mean = mean(mpg))
mean(mtcars$mpg)

# with group_by--1 grouping variable, using pipes
mtcars |>
  group_by(cyl) |>
  summarize(mean = mean(mpg),
            sd = sd(mpg),
            min = min(mpg),
            max = max(mpg),
            median = median(mpg))

# with group_by -- 2 grouping variables
mtcars |>
  group_by(cyl, am)|>
  summarize(mean = mean(mpg),
            sd = sd(mpg),
            min = min(mpg),
            max = max(mpg),
            median = median(mpg))

# powerful!!