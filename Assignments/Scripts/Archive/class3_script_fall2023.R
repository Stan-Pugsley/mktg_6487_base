########################################### 
### Class 3
########################################### 

# The primary goal of this script is to prepare you with code and
# concepts, using the Megatelco case as an example, for completing 
# the  project for this module (which is presented as a Canvas quiz).

# Plan to do your project coding using the provided .R template. 

###########################################  
### Open the quiz 
########################################### 

# Go to Canvas and open the quiz for the project and look at the questions.

########################################### 
### Download data from Canvas for this webinar
########################################### 

# 1. Go to Canvas and download the megatelco.csv file for this example.  
# 2. Move it to the folder you created with your project (your working directory). 

########################################### 
### Needed skills for the project 
########################################### 

# Here is what you need to be able to do for the AdviseInvest project:

# 1. Identify the target variable for an analysis based on the business problem.
# 2. Decide which non-binary variables should be recoded as factors, and recode
#    them.
# 3. Compute the mean of a binary variable.
# 4. Use ggplot2 to plot a numeric (or count) variable against a categorical 
#    variable.
# 5. Calculate a count (and a proportion) for a categorical variable 
#    using dplyr and pipe the result into a plot.

########################################### 
### Load Packages
########################################### 

library(tidyverse) # Remember: must always load packages at the beginning of a session!

########################################### 
### Import data 
########################################### 

m <- read.csv("megatelco.csv")

########################################### 
### Create data frame
########################################### 

data.frame(first_col = c(1, 2, 3, NA),
           second_col = c("A", "B", "C", NA))

########################################### 
### Inspect
########################################### 

str(m) # Which should be factors?
summary(m)

m$reported_usage_level |> 
  unique()

m$reported_satisfaction |> 
  unique()

# Issues: 

# 1. College has values of  `zero` and `one.`  We will change these to "no" and
#    "yes," since there are only two values, and spelling out the numbers is weird.
# 2. Turn college into a factor variable. This is not essential in this case, but it 
#    gives you an example for the project.
# 3. Remove negative values of `income` and `house`. 
# 4. Remove absurdly large value of `handset_price`.

########################################### 
### Clean dataset
########################################### 

# Notes:
# 1. dplyr verbs: mutate(), filter(), and below we use summarize() also.
#    - mutate(): creates a new column.
#    - filter(): removes rows based on logical conditions.
#    - summarize():  creates a smaller summary table.
# 2. factor(). The default setting will create alphabetic factor levels for character variables.
# 3. ifelse() is a handy function for recoding, identical to Excel's "if" function.

m_clean <- m |> 
  mutate(college = ifelse(college == "one", "yes", "no"), # recode college
         college = factor(college),                       # factor college
         leave = factor(leave)) |>                       # factor leave
  filter(income > 0,
         house > 0,
         handset_price < 1000) 

# Check whether the operation was successful
summary(m_clean)

########################################### 
### Identify target
########################################### 

# The target variable for a model of churn will be LEAVE. (Why?)
# The target is the data representation of the phenomenon we are interested in 
# understanding/modeling.

########################################### 
### Compute the mean of a binary 0/1 variable
########################################### 

example1 <- c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1) # create an arbitrary 0/1 vector
example1 # check vector
mean(example1) # Calculate the mean, which is the proportion of 1s

# How would we calculate the mean of a numeric column such as handset price?
mean(m_clean$handset_price) # Notice the dollar sign notation

# Or, if you wanted to use dplyr (more typing in this case):
m_clean |> 
  summarize(mean_price = mean(handset_price))

#################################################
### Explore variable relationships: leave ~ house
#################################################

# Are wealthier customers more likely to churn?
# What is the relationship between leave and house price?
# Note: Leave is binary, house price is numeric, so categorical vs.
# continuous.  Boxplot is a good choice.  It shows us the distribution 
# of house price for each value of leave.

# By "distribution" we mean: the range and frequency of values in the column.

# empty canvas
ggplot(data = m_clean)

# empty canvas with mapping
ggplot(data = m_clean, mapping = aes(x = leave, y = house))

# add plot type
ggplot(data = m_clean, mapping = aes(x = leave, y = house)) +
  geom_boxplot() +
  labs(title = "leave ~ house")

# Are there other possibilities?  Yes, but none as informative:

# Scatterplot 
ggplot(data = m_clean, aes(x = leave, y = house)) +
  geom_point() + 
  labs(title = "leave ~ house")

# Bar plot, which requires some preliminary data manipulation
m_clean |> 
  group_by(leave) |> 
  summarize(avg_house_price = mean(house)) |> 
  ggplot(aes(x = leave, y = avg_house_price)) +
  geom_col() +
  labs(title = "leave ~ house")

# Sidebar:  what is the distribution of the house variable?
ggplot(m_clean, aes(x = house)) +
  geom_histogram() + 
  labs(title = "Distribution of house")

# What is the best measure of central tendency?  Mean or median?

mean(m_clean$house)
median(m_clean$house)

#################################################################
### Explore variable relationships: leave ~ college
#################################################################

# Both variables are categorical. 

# First, what does NOT work:
m_clean |> 
  ggplot(aes(x = leave, y = college)) +
  geom_boxplot() +
  labs(title = "leave ~ college")

# This does not work because boxplots are designed for categorical vs. continuous,
# not categorical vs. categorical.

# Instead, we will calculate the proportion of leavers at each level of college  
# This allows us to see whether customer departure depends on, or is related 
# to, college.

# Here is how it works, in steps:

# 1. Create a summary table of counts:
m_clean |> 
  count(leave, college) 

# (Notice that I'm not saving this table but  printing it to the console.)

# count() automatically creates a new column, with the default name n, with the 
# counts for each unique combination of leave and college

# 2. Pipe new table into ggplot for viz.  We will use geom_col() plot type for
# for pre-calculated values, rather than geom_bar (which is for raw values).
m_clean |> 
  count(leave, college) |> 
  ggplot(mapping = aes(x = college, y = n, fill = leave)) + # Notice "fill" argument!
  geom_col() +
  labs(title = "counts of leave by college")

# Hard to interpret!  Why?

# Let's "dodge" the bars.

m_clean |> 
  count(leave, college) |> 
  ggplot(aes(x = college, y = n, fill = leave)) +
  geom_col(position = "dodge") +
  labs(title = "counts of leave by college")

########################################### 
### Optional!
########################################### 

# An even better (more informative) plot than the one above would calculate the 
# proportion of leave and stay at each level of college.

# Warning: this type of plot is quite a bit more complicated and involved. Only for
# the stout-hearted!

# Base table
m_clean |> 
  count(college, leave) 

# Add proportion to the table
m_clean |> 
  count(college, leave) |> 
  group_by(college) |> 
  mutate(proportion = n / sum(n))

# Pipe this table into ggplot using geom_col with dodged bars.
m_clean |> 
  count(college, leave) |> 
  group_by(college) |> 
  mutate(proportion = n / sum(n)) |> 
  ggplot(aes(college, proportion, fill = leave)) + 
  geom_col(position = "dodge") +
  labs(title = "Proportion of leave by college") +
  theme_minimal()

# This is pretty close to the plot with counts, in this case.  When counts are really
# different between categories putting proportions on the y-axis tends to work better.

# What story does this plot tell??
