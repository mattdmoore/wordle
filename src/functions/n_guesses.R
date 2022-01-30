# How many guesses between specified or random word and target
n_guesses = function(word_list, word=NULL, target=NULL)
{
  random_word = function(word_list) word_list[sample(n[1], 1),]
  
  if(is.null(word)) word = random_word(word_list)
  if(is.null(target)) target = random_word(word_list)
  
  source('src/functions/find_target.R')
  out = find_target(word, target, word_list, p=F)
  return(length(out) + 1)
}
