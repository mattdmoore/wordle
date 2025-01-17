score_word = function(word, freq)
{
  idx = sapply(word, function(x) which(letters %in% x))
  return(freq[unique(idx)] / sum(freq))
}

# Sum of word letter frequencies over total letters
words$full$letter_score = apply(words$split, 1, function(word)  
{
  sum(score_word(word, frequencies$letter))
})

# Mean of position letter frequencies over letters per position
words$full$position_score = apply(words$split, 1, function(word)
{
  sapply(1:n[2], function(i)
  {
    score_word(word[i], frequencies$position[,i])
  }) %>% mean
})

words$full$total_score = words$full$letter_score * words$full$position_score

rm(score_word)