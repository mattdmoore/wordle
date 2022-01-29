# Load cross-script functions
source('src/functions/find_target.R')
source('src/functions/n_guesses.R')

# Starting word and N games to simulate
word = 'irate'
N = 300

# Check if word is cached
data_dir = 'data/cached_words'
files = list.files(data_dir)
idx = str_detect(files, word)
if(any(idx)){
  load(paste(data_dir, files[idx], sep='/'))
  out = get(word) # assign dynamic variable to out to avoid repeated get() calls
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


cat('Bootstrapping statistics for word:', paste0(word, collapse=''), '\n')
for(i in 1:N)
{
  x[i] = n_guesses(words$split, strsplit(word,'') %>% unlist)
  
  # Real-time progress monitoring
  cat(sprintf('\rMean: %.2f\tStDev: %.2f\tFail rate: %.02f%%\tN: %d/%d\t', 
              mean(x[x > 0]), 
              sd(x[x > 0]),
              100 * length(which(x > 6)) / (i + Nx),
              (i + Nx), (N + Nx)))
}

# Does the chosen word result in a significant reduction in required guesses?
out = list(word=word,t.test=t.test(x, y), x=x)
cat('\n')
print(out$t.test)

assign(word, out)
if((N + Nx) >= 100)
{
  file = paste0(word, '.RData', collapse='')
  save(list=word, file=paste(data_dir, file, sep = '/'))
  
  rm(file)
}

# Clean up
rm(i,N,Nx,n_guesses,x,find_target,word,idx,files,data_dir,out)
