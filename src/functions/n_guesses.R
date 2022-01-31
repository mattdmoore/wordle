# How many guesses between specified or random word and target
n_guesses = function(word_list, word=NULL, target=NULL, solutions_list)
{
  random_word = function(word_list) word_list[sample(nrow(word_list), 1),]
  
  if(is.null(word)) word = random_word(word_list) %>% unlist
  if(is.null(target)) target = random_word(solutions_list)
  
  source('src/functions/find_target.R')
  out = find_target(word, target, word_list, p=F)
  return(length(out) + 1)
}
