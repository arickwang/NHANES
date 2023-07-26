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

tab_prevs <- function(svyobj, pivot, label = NULL, sig = "%.1f") {
  pivot = rlang::enquo(pivot)
  
  if(is.null(label)) {label = pivot} else {label = rlang::enquo(label)}
  
  
  
  tmp <- svyobj %>% 
    group_by(!!pivot) %>%
    summarise(n = unweighted(n()),
              mean = survey_mean(vartype = "ci")*100) %>%
    mutate(group = !!pivot,
           mean2CI = makePretty(mean, mean_low, mean_upp, sig = sig)) %>%
    select(group, n, mean2CI) %>%
    rename(!!label := group)
  
  return(tmp)
}