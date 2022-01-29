find_target = function(word, target = NULL, word_list, print=T, i=1)
{
  try_word = function(word, target)
  {
    # Yellow letters: in word but incorrect place
    misplaced = mapply(function(x,y) xor(x %in% target, x==y), 
                       x=word, 
                       y=target) %>% unname
    
    unplaced = misplaced %>% 
      word[.] %>%
      unique
    
    # Green letters: in word and correct place
    placed = sapply(1:length(word), function(x) word[x] == target[x])
    
    # Black letters: not in word
    excluded = sapply(word, function(x) !x %in% target) %>%
      unname %>% 
      word[.] %>%
      unique
    
    out = list(
      word = word,
      excluded=excluded,
      unplaced=unplaced,
      misplaced=misplaced,
      placed=placed
    )
    return(out)
  }
  
  remove_unplaced = function(word_list, guess)
  {
    idx = apply(word_list, 1, function(word)
    {
      sapply(guess$unplaced, function(letter) letter %in% word) %>% all
    })
    word_list %<>% .[idx,]
    return(word_list)
  }
  
  remove_placed = function(word_list, guess)
  {
    if(length(which(guess$placed)) == 1) 
    {
      idx = word_list[,guess$placed] == guess$word[guess$placed]
    } else {
      idx = apply(word_list[,guess$placed], 1, function(letters)
      {
        all(letters == guess$word[guess$placed])
      })
    }
    word_list %<>% .[idx,]
    return(word_list)
  }
  
  remove_misplaced = function(word_list, guess)
  {
    if(length(which(guess$misplaced)) == 1) 
    {
      idx = word_list[,guess$misplaced] == guess$word[guess$misplaced]
    } else {
      idx = apply(word_list[,guess$misplaced], 1, function(letters)
      {
        any(letters == guess$word[guess$misplaced])
      })
    }
    word_list %<>% .[!idx,]
    return(word_list)
  }
  
  remove_excluded = function(word_list, guess)
  {
    idx = apply(word_list, 1, function(word)
    {
      sapply(guess$excluded, function(letter) letter %in% word) %>% any
    })
    word_list %<>% .[!idx,]
    return(word_list)
  }
  
  update_frequencies = function(word_list, guess)
  {
    count_letters = function(vec) 
    {
      sapply(letters, function(x) length(which(vec %in% x)))
    }
    
    freq = list(
      # Raw frequencies
      'letter' = count_letters(word_list),
      # By letter position
      'position' = sapply(1:n[2], function(i) count_letters(word_list[,i]))
    )
    
    freq$letter[letters %in% guess$word] %<>% {. * .5}
    return(freq)
  }
  
  choose_word = function(word_list, freq)
  {
    score_word = function(word, freq)
    {
      idx = sapply(word, function(x) which(letters %in% x))
      return(freq[unique(idx)] / sum(freq))
    }
    
    idx = apply(word_list, 1, function(word)  
    {
      sum(score_word(word, freq$letter))
    }) %>% which.max
    
    return(word_list[idx,])
  }
  
  collapse_word = function(word) paste0(word, collapse='')
  
  check_valid_word_list = function(word_list)
  {
    single = !is.matrix(word_list)
    if(single) 
    {
      # Edge case: hit by exclusion on first recursion
      if(i == 1 & print){cat(i, collapse_word(word), '\n'); i=i+1}
      
      word = word_list
      
      if(print)
      {
        cat(i, collapse_word(word), '\n')
        cat('Done\n\n')
      }
    }
    return(single)
  }
  
  # Try word against target to get hits and misses
  guess = try_word(word, target)
  
  # Remove all words containing any black letters
  word_list %<>% remove_excluded(.,guess)
  if(check_valid_word_list(word_list)) return()
  
  # Remove all words missing any yellows
  word_list %<>% remove_unplaced(.,guess)
  if(check_valid_word_list(word_list)) return()
  
  # Remove all words containing any misplaced yellows
  word_list %<>% remove_misplaced(.,guess)
  if(check_valid_word_list(word_list)) return()
  
  # Remove all words containing non-matching greens
  word_list %<>% remove_placed(.,guess)
  if(check_valid_word_list(word_list)) return()  
  
  # Choose next best word based on frequency
  freq = update_frequencies(word_list, guess)
  while(!all(target == word))
  {
    if(print) cat(i, collapse_word(word), '\n')
    word = choose_word(word_list,freq); i=i+1
    return(c(paste0(word, collapse=''),
             find_target(word, target, word_list, print, i)))
  }
}