words = list(full = read.csv('data/word_list.txt', 
                             header = F,
                             col.names = 'word'))

words$split = sapply(words$full, 
                     str_split_fixed, 
                     pattern = '', 
                     n = 5, 
                     simplify = F)[[1]]

n = nrow(words$full)