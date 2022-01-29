##### Setup #####

# Clear memory
rm(list=ls(all=T))

# Load libraries
source('config/libraries.R')

##### Prepare data #####

# Read data
source('src/read_data.R')

##### Basic analysis #####

# Compute letter frequencies
source('src/frequency_tables.R')

# Score words by letter and position frequencies
source('src/score_words.R')

##### Simulate games #####

