##### Functions used for correlation plot #####

# Histogram function to show univariate distribution
hist_func <- function(data, mapping, ...) {
  ggplot(data = data, mapping = mapping) +
    geom_histogram() +
    theme(panel.background = element_rect(fill = "white", colour = "black"))
}

# Function to retrieve correlation
# and color according to pearson's r
cor_func <- function(data, mapping, ...){

  # Retrieve data
  x <- eval_data_col(data, mapping$x)
  y <- eval_data_col(data, mapping$y)

  # calculate correlation
  corr <- cor(x, y, method = 'pearson', use = 'complete.obs')
  pearsr <-  paste('r =' , as.character(round(corr, 2)))

  colFn <- colorRampPalette(c("coral1", "white", "palegreen3"),
                            interpolate ='spline')
  fill <- colFn(100)[findInterval(corr, seq(-1, 1, length=100))]

  ggally_text(
    label = pearsr,
    mapping = aes(),
    xP = 0.5, yP = 0.5,
    color = 'black',
    ...) +
    theme(panel.background = element_rect(fill = fill, colour = "black"))
}

# Function to plot bivariate distributions with fitted OLS regression
smooth_func <- function(data, mapping, ...){

  x <- eval_data_col(data, mapping$x)
  y <- eval_data_col(data, mapping$y)

  ggplot(data = data, aes (x = x, y = y))+
    geom_point(shape = 16, colour = 'black') +
    geom_smooth(method = 'lm', se = FALSE, colour = 'red') +
    theme(panel.background = element_blank(),
          panel.border = element_rect(fill = NA, colour = 'black'))
}

# Function to combine the above functions into a correlation plot
corr_plot <- function(data, title = NULL, ...){

  ggpairs(data, columns = 1: ncol(data), title = title, switch = 'y',
          upper = list(continuous = wrap(cor_func)),
          lower = list(continuous = smooth_func),
          diag = list(continuous = hist_func),
          axisLabels = "none") +
    theme(strip.background = element_rect(fill = "white", colour = "black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
}
