# Explicit package loading in case run as local job
library('tidyverse')
library('magrittr')

# Starting word and N games to simulate
word = 'tares'
N = 0

simulate_games = function(word, 
                          N, 
                          word_list, 
                          solutions_list, 
                          cache_threshold=200)
{
  # Check if word is cached
  data_dir = 'data/cached_words'
  files = list.files(data_dir)
  idx = str_detect(files, word)
  if(any(idx)){
    load(paste(data_dir, files[idx], sep='/'))
    out = get(word) # assign dynamic variable to avoid repeated get() calls
  }
  
  # Continue from existing cached data
  x = numeric(N)
  Nx = 0
  if(exists('out'))
  {
    if(out$word == word)
    {
      x = c(x, out$x)
      Nx = length(out$x)
    }
  }
  
  # Load cross-script functions
  source('src/functions/n_guesses.R')
  source('src/functions/bootstrap_distribution.R')
  
  cat('Bootstrapping statistics for word:', paste0(word, collapse=''), '\n')
  for(i in 1:N)
  {
    x[i] = n_guesses(word_list, 
                     strsplit(word,'') %>% unlist,
                     solutions_list=solutions_list)
    
    # Real-time progress monitoring
    cat(sprintf('\rMean: %.2f\tStDev: %.2f\tFail rate: %.02f%%\tN: %d/%d\t', 
                mean(x[x > 0]), 
                sd(x[x > 0]),
                100 * length(which(x > 6)) / (i + Nx),
                (i + Nx), (N + Nx)))
  }
  
  # Does the chosen word result in a significant reduction in required guesses?
  out = list(word=word,
             t.test=t.test(x, bootstrap_distribution()), 
             x=x)
  cat('\n')
  print(out$t.test)
  
  # Cache words simulated more than 200 times
  assign(word, out)
  if((N + Nx) >= cache_threshold)
  {
    file = paste0(word, '.RData', collapse='')
    save(list=word, file=paste(data_dir, file, sep = '/'))
    
    rm(file)
  }
  
  return(out)
}

assign(word, simulate_games(word, N, words$split, solutions$split))

# Clean up
rm(simulate_games, N, word, bootstrap_distribution, n_guesses, find_target)
