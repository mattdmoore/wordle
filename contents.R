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

# Rank words by letter and position frequencies
source('src/rank_words.R')

##### Simulate games #####
