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

# Bar chart of letter frequencies
source('plots/letter_frequencies.R')

# Bar charts of letter frequencies by position in word
source('plots/position_frequencies.R')

##### Simulate games #####

# Test specific words against bootstrapped distribution
source('src/simulate_games.R')

# Visualise guess distributions
source('plots/guess_distributions.R')
