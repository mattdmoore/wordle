# Count occurrences of each letter in character vector
count_letters = function(vec) 
{
  sapply(letters, function(x) length(which(vec %in% x)))
}

frequencies = list(
  # Raw frequencies
  'letter' = count_letters(words$split),
  # By letter position
  'position' = sapply(1:n[2], function(i) count_letters(words$split[,i]))
)

# Clean up
rm(count_letters)