# Format data for ggplot
df = frequencies$position %>% 
  data.frame(letter=letters) %>% 
  pivot_longer(-letter, 
               names_to = 'position', 
               values_to = 'n')

df$position %<>% 
  gsub('\\D','Position ',.) %>% 
  as.factor

scale_x_reordered = function(..., sep = "___") 
{
  reg = paste0(sep, ".+$")
  ggplot2::scale_x_discrete(labels = function(x) gsub(reg, "", x), ...)
}

reorder_within = function(x, by, within, fun = mean, sep = "___", ...) 
{
  new_x = paste(x, within, sep = sep)
  stats::reorder(new_x, by, FUN = fun)
}

position_frequencies = ggplot(df, aes(x=reorder_within(letter, -n, position),y=n,fill=position,order=n)) + 
  geom_col() + 
  labs(title = 'Letter Frequencies by Position in Word',
       x='',
       y='') +
  scale_x_reordered() +
  scale_fill_brewer(palette = 'Dark2') +
  theme_classic() + 
  theme(legend.position = 'none') +
  facet_wrap(~position,
             scales='free_x',
             nrow=1)

plot(position_frequencies)
  
# Clean up
rm(df, position_frequencies, scale_x_reordered, reorder_within)