# Sum of word letter frequencies over total letters
words$full$letter_score = apply(words$split, 1, function(word)  
{
  idx = sapply(letters, function(x) x %in% word)
  return(sum(frequencies$letter[idx]) / (n * 5))
})

# Mean of position letter frequencies over letters per position
words$full$position_score = sapply(1:5, function(i)
{
  apply(words$split, 1, function(word)  
  {
  idx = sapply(letters, function(x) x %in% word[i])
  return(frequencies$position[idx,i] / n)
  })
}) %>% rowMeans
