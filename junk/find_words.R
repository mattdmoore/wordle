find_next = function(word, word_list, freq)
{ 
  freq[sapply(letters, function(x) x %in% word)] = 0
  idx = apply(word_list, 1, function(word)
  {
    sum(score_word(word, freq))
  }) %>% which.max
  
  if(!is_empty(idx)) 
  {
    print(words$full[idx,1])
    return(c(words$full[idx,1], 
             find_next(word_list[idx,], word_list, freq)))
  }
}

find_target = function(word, word_list, freq, target = NULL)
{
  hits = word %in% target
  hit_idx = sapply(1:n[2], function(i) 
  {
    word_list[,i] %in% word[hits]
  }) %>% apply(1, any)
  
  miss_idx = sapply(1:n[2], function(i) 
  {
    word_list[,i] %in% word[!hits]
  }) %>% apply(1, any)
  
  freq[sapply(letters, function(x) x %in% word[!hits])] = 0

  placed = sapply(1:n[2], function(i) #TODO fix fucky logic
  {
    if(target[i]==word[i]) word_list[,i] == word[word == target[i]] # anagrams break this
    else !logical(nrow(word_list))
  }) %>% apply(1,all)
  
  word_list = word_list[placed & hit_idx & !miss_idx,]
  
  idx = apply(word_list, 1, function(word)
  {
    sum(score_word(word, freq))
  }) %>% which.max

  
  if(!is_empty(idx)) 
  {
    print(paste(word_list[idx,], collapse = ''))
    while(!all(word_list[idx,] == target))
    {
      return(find_target(word_list[idx,], word_list, freq, target))
    }
  }
}

random_word = function() words$split[runif(1, max = n),]
