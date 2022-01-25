# Required packages:
reqLibs = list(
  # General use
  'tidyverse',
  'magrittr')

# Install missing packages
lapply(reqLibs[!reqLibs %in% installed.packages()], 
       install.packages, 
       verbose = T)

# Attach required packages
lapply(reqLibs[!reqLibs %in% .packages()], 
       library, 
       character.only = T, 
       verbose = T)

# Clean up
rm(reqLibs)