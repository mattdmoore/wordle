data_dir = 'data'
files = list.files(data_dir)

# Load bootstrapped distribution with random starting words
if(any(grepl('bs', files))) 
{
  # Get file with highest bootstrap repetitions
  idx = files %>% 
    gsub('\\D','',.) %>% 
    as.numeric %>% 
    which.max
  
  file = paste(data_dir, files[idx], sep = '/')
  load(file)
  

  # Clean up
  rm(data_dir, files, idx, file)
  
} else {
  # Load cross-script functions
  source('src/functions/find_target.R')
  source('src/functions/n_guesses.R')
  
  # How many repetitions to bootstrap for
  R = 20000
  
  cat('Generating bootstrap distribution with', R, 'repetitions\n')
  y = numeric(R)
  for(i in 1:R)
  {
    y[i] = n_guesses(words$split)
    
    # Real-time progress monitoring
    cat(sprintf('\rMean: %.2f\tStDev: %.2f\tFail rate: %.02f%%\tN: %d/%d\t', 
                mean(y[y > 0]), 
                sd(y[y > 0]),
                100*length(which(y > 6))/i,
                i,R))
  }
  
  # Save output
  save(y, file=paste0('data/bs_', R, '.RData'))

  # Clean up
  rm(i, R, n_guesses, find_target, files, data_dir)
}
