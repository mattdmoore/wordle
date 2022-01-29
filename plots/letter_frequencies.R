# Format data for ggplot
df = data.frame(letter=letters,
                n=frequencies$letter)

letter_frequencies = ggplot(df, aes(x=letter, y=n, fill=n)) + 
  geom_col() +
  scale_fill_viridis_b() +
  labs(x = '', y = '') + 
  theme_classic() + 
  theme(legend.position = 'none')

plot(letter_frequencies)

# Clean up
rm(df, letter_frequencies)