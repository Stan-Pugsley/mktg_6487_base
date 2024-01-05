# IS 6487 Class 2 Script

### Agenda

# Loading installed packages
# Setting up and using an RStudio project
# Getting data into R
# Inspect data
# Explore plot types with ggplot2 

# Make sure you have downloaded tonight's script and data from Canvas.

########################################### 
### Loading installed packages
########################################### 

# Even if you have installed the package, you still need to load it! 
# RStudio will preserve your workspace if you are in a project, but you still need to
# load packages into memory every time you come back toi R for a new session.

```{r}

library(tidyverse) 


```
########################################### 
### Demo: setting up and using an RStudio project
########################################### 

# Recommendation: 

# Do your work for this class in a project. This helps keep your stuff organized.

# When you create a project, RStudio creates a folder in your file directory. 

# You do not need to create a folder independently.

########################################### 
### Getting data into R
########################################### 

# Data that is built in:
data("mtcars")

# Inspect
?mtcars # get info on the dataset

head(mtcars, n = 10) # look at the top 6 (by default) rows
tail(mtcars)

summary(mtcars) # get a numerical summary of the dataset

# Click on the spreadsheet icon next to the mtcars object in memory
# for an Excel-like view of the data

# Data from an external source.
# 1. Go to canvas and find megatelco.csv in Files.  Download it.
# 2. Manually move the dataset from the downloads folder to your working 
#    directory in the folder you created with your project.
# 3. Save the data as an R object, stored in memory, so it is available for use.

m <- read_csv(file = "megatelco.csv")


?read_csv
m$college

# Here is another option: use the file.choose() function

m <- read_csv(file.choose())

# Another option:  Use the "Import Dataset" under the Environment tab in the upper right quadrant.

# The problem with both of these methods, while seemingly easy, is that they don't put 
# the data in your working directory which can create problems when you were looking for it later on.

########################################### 
### Inspect Data
########################################### 

head(m)
summary(m) # Any obvious problems with the dataset?
glimpse(m) # Handy tidyverse function

# What would the target variable be for a model of churn (customer departure)?
# Are there any variables that would definitely NOT be used in a model?

# Quick cleaning using dplyr:
m_clean <- m |> 
  filter(income > 0, 
         house > 0,
         handset_price < 1500)

# Explanation of code. 
# 1. m_clean <- m:  create a cleaned dataset from the initial downloaded dataset.
# 2. |>:  the pipe.  This makes it easy to read the code. Read it as: "and then."
# 3. filter():  The logical conditions for removing rows. Read as: "keep rows where
#    income > 0 and house > 0 and handset_price < 1000."

# Summary table.  
# What is average house price at the two levels of leave?

m_clean |> 
  group_by(leave) |> 
  summarize(avg_house_price = mean(house))

# Explanation of code. 
# 1. m_clean:  I'm not saving this table a new object, just printing it to the screen for convenience.
# 2. |>:  the pipe.  
# 3. group_by():  Defines the grouping variable. Indicates that the summary statistic 
#    should be produced for each level of the categorical leave variable.
# 3. summarize():  Creates the summary table, which is smaller than the original table, 
#    based on the summary statistics defined within the function.

# Conclusion?  Stayers have substantially more expensive homes.

########################################### 
### Plot types with ggplot2
########################################### 

# Basic syntax: 

# Set up blank canvas: ggplot(data, aes(x, y))

# Then add plot type:

# 1. histogram: geom_histogram(). Distribution of single continuous variable.

# 2. scatterplot: geom_point(). Relationship between 2 continuous variables.

# 3. boxplot: geom_boxplot(). Relationship between continuous and categorical 
#   variables.

# Histogram
ggplot(data = m_clean, aes(x = house)) +
  geom_histogram() 

# Scatterplot
ggplot(data = m_clean, aes(x = house, y = income)) +
  geom_point() +
  geom_smooth()

# Boxplot
ggplot(m_clean, aes(x = leave, y = house)) +
  geom_boxplot()
