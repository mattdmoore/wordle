# Read complete words from file
words = list(full = read.csv('data/word_list.txt', 
                             header = F,
                             col.names = 'word'))

# Split into character matrix
words$split = sapply(words$full,
                     str_split_fixed,
                     pattern = '',
                     n = nchar(words$full[1,]), # get n from word length to avoid hard-coded values
                     simplify = F)[[1]]

# Store total number of words
n = dim(words$split)
