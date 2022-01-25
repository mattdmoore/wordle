##### Setup #####

# Clear memory
rm(list=ls(all=T))

# Load libraries
source('config/libraries.R')

##### Prepare data #####

# Read data
source('scr/read_data.R')

##### Basic analysis #####

# Analyse letter frequencies
source('scr/frequency_tables.R')

# Rank words by letter and position frequencies
source('scr/rank_words.R')
