# Load required data from cache
load('data/cached_words/later.RData')
load('data/cached_words/xylyl.RData')
load('data/bs_20000.RData')

p = ggplot() +
  geom_vline(xintercept = 6,
             col='darkred',
             size=.25,
             lty=5) + 
  geom_density(aes(x=y, fill='[Random]'),
               alpha=.5,
               lty=3,
               size=.2,
               bw=1) + 
  geom_density(aes(x=later$x, fill='Later'),
               alpha=.3,
               lty=3,
               size=.2,
               bw=1) +
  geom_density(aes(x=xylyl$x, fill='Xylyl'),
               alpha=.3,
               lty=3,
               size=.2,
               bw=1) +
  labs(x = 'N',
       y = 'Density',
       title = 'Guesses to Correct Answer') +
  scale_x_continuous(breaks=1:20) + 
  scale_fill_manual(
    name = 'Word',
    values = c('pink', 'blue', 'orange'), 
    labels = c('[Random]','Later', 'Xylyl')) +
  theme_classic() +
  theme(legend.position = 'right')

plot(p)

# Clean up
rm(p,y)
