guess_distributions = function(words)
{
  # Load bootstrap distribution
  source('src/functions/bootstrap_distribution.R')
  df = data.frame(N = bootstrap_distribution(), 
                  Word = '[Random]')
  
  # Load required data from cache
  cache_dir = 'data/cached_words'
  for(word in words)
  {
    file = paste0(word, '.RData')
    path = paste(cache_dir, file, sep='/')
    
    load(path)
    
    df = rbind(df, data.frame(N = get(word)$x, Word = word))
  }
  
  
  p = ggplot(df, aes(x = N, fill = Word)) + 
    geom_density(bw=1,
                 alpha=.5) +
    geom_vline(xintercept = 6,
               lty = 3,
               col='darkred') +
    scale_x_continuous(breaks = 1:20) +
    labs(title = 'Guesses to Correct Answer',
         y = 'Density') +
    theme_classic()
  
  plot(p)
}

guess_distributions(c('tales','xylyl'))

# Clean up
rm(guess_distributions, bootstrap_distribution)
