# How many guesses between specified or random word and target
n_guesses = function(words, word=NULL, target=NULL)
{
  random_word = function(word_list) word_list[sample(n[1], 1),]
  
  if(is.null(word)) word = random_word(words)
  if(is.null(target)) target = random_word(words)
  
  out = find_target(word, target, words, p=F)
  return(length(out) + 1)
}
