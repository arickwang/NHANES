makePretty <- function(mean,lower,upper,sig = "%.1f") {
  lower = ifelse(lower < 0, 0, lower)
  
  mean_pretty = sprintf(sig, mean)
  lower_pretty = sprintf(sig, lower)
  upper_pretty = sprintf(sig, upper)
  
  pretty = paste0(mean_pretty, " (", 
                  lower_pretty, ", ",
                  upper_pretty, ")")
  
  return(pretty)
}