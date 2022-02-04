library('magrittr')
library('tidyverse')
bootstrap_distribution = function(word_list=NULL, 
                                  R=NULL) 
{
  data_dir = 'data'
  files = list.files(data_dir)
  Rx = 0
  y = NULL
  if(any(grepl('bootstrap', files))) {
    idx = grepl('bootstrap', files) %>% which
    file = paste(data_dir, files[idx], sep = '/')
    load(file)
    Rx = length(y)
  } 
  
  # Generate new bootstrap distribution, 
  if(!is.null(R))
  {
    y = c(numeric(R), y)
    # Load cross-script functions
    source('src/functions/n_guesses.R')
    
    cat('Generating bootstrap distribution with', R, 'repetitions\n')
    for(i in 1:R)
    {
      y[i] = n_guesses(words$split, solutions_list = solutions$split)
      
      # Real-time progress monitoring
      cat(sprintf('\rMean: %.2f\tStDev: %.2f\tFail rate: %.02f%%\tN: %d/%d', 
                  mean(y[y > 0]), 
                  sd(y[y > 0]),
                  100 * length(which(y > 6)) / i,
                  i + Rx,
                  R + Rx))
      
      # Save checkpoint every 500 simulations
      checkpoint = y[y > 0]
      if((i %% 500) == 0) save(checkpoint, file='data/bootstrap.RData')
    }
  }
  
  save(y, file='data/bootstrap.RData')
  return(y)
}
