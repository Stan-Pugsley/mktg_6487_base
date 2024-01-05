# arithmetic
2 + 2

a <- 2 + 3

a + 1

a + a

# vectors:  1 dimensional list of items, same data type
a <- LETTERS # Built in vector of capital letters

# subset by vector position: the index of each item
a[1:3]
v <- c(1:3, 25:26)
a[v]

# return the index (trivial example)
a[a=="B"]

# create a vector of numbers and letters
c(1:3, "A") # what happened?

# Factors
b <- factor(a)
b

c <- factor(c("small","medium", "large"))
d <- factor(c("apple", "banana", "Peach"))

# dataframes, 2 dimensional data structures, can combine different data types
data(mtcars)

head(mtcars)
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

