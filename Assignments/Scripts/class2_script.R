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


# Data from an external source.
# 1. Go to canvas and find megatelco.csv in Files.  Download it.
# 2. Manually move the dataset from the downloads folder to your working 
#    directory in the folder you created with your project.
# 3. Save the data as an R object, stored in memory, so it is available for use.

m <- read_csv(file = "https://raw.githubusercontent.com/Stan-Pugsley/mktg_6487_base/main/Assignments/DataSets/megatelco.csv")

#Alternate method:
# m <- read_csv(file.choose())

########################################### 
# Megatelco Data Dictionary
########################################### 

# DEMOGRAPHIC VARIABLES:
# College - has the customer attended some college (one, zero)
# Income - annual income of customer
# House - estimated price of the customer's home (if applicable)

# USAGE VARIABLES:
# Data Overage Mb - Average number of megabytes that the customer used in excess of the plan limit (over last 12 months)
# Data Leftover Mb - Average number of megabytes that the customer use was below the plan limit (over last 12 months)
# Data Mb Used - Average number of megabytes used per month (over last 12 months)
# Text Message Count - Average number of texts per month (over last 12 months)
# Over 15 Minute Calls Per Month - Average number of calls over 15 minutes in duration per month (over last 12 months)
# Average Call Duration- Average call duration (over last 12 months)

#PHONE VARIABLES:
# Operating System - Current operating system of phone
# Handset Price - Retail price of the phone used by the customer

#ATTITUDINAL VARIABLES:
# Reported Satisfaction - Survey response to "How satisfied are you with your current phone plan?" (high, med, low)
# Reported Usage Level - Survey response to "How much do your use your phone?" (high, med, low)
# Considering Change of Plan - Survey response to "Are you currently planning to change companies when your contract expires?" (high, med, low)

#OTHER VARIABLES
# Leave - Did this customer churn with the last contract expiration? (LEAVE, STAY)
# ID - Customer identifier


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
