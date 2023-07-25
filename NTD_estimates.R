
RBC_molloy_convert <- function(RBC) {
  RBC = (RBC-34.2802)/0.7876
  
  return(RBC)
}


RBC_estimate_mean_variance <- function(RBC) {
  pcts = c(0.01, seq(0.05, 0.95, 0.05), 0.99)
  quants = quantile(RBC, pcts)
  
  dat = tibble(pcts = qnorm(pcts),
               RBC = log(quants))
  
  tmp = lm(RBC~pcts, data = dat)
  output = tibble(mean = tmp$coefficients[1],
                  sd = tmp$coefficients[2])
  
  return(output)
}


RBC_mean_variance_quantsOnly <- function(data, pcts, quants) {
  pcts = rlang::enquo(pcts)
  quants = rlang::enquo(quants)
  
  pcts = data %>% pull(!!pcts)/100
  quants = data %>% pull(!!quants)
  
  dat = tibble(pcts = qnorm(pcts),
               RBC = log(quants))
  
  tmp = lm(RBC~pcts, data = dat)
  output = tibble(mean = tmp$coefficients[1],
                  sd = tmp$coefficients[2])
  
  return(output)
}


NTD_estimate <- function(RBC, nsamp = 10000) {
  
  gen = rnorm(nsamp)
  
  lb_1_gen = 4.56 + (1.067*gen)
  rho = -0.997
  mu_2 = -1.7 + 0.16*rho*gen
  sig_2_2 = 0.16*0.16*(1-rho*rho)
  
  lb_2_gen = mu_2 + sqrt(sig_2_2)*rnorm(nsamp)
  
  e1 = lb_1_gen + lb_2_gen*log(RBC)
  p_hat1 = exp(e1)/(1 + exp(e1))*nsamp
  
  quants = quantile(p_hat1, c(0.025, 0.5, 0.975))
  output = tibble(median = quants[2],
                  ll = quants[1],
                  ul = quants[3])
  
  return(output)
}

NTD_estimate_pop <- function(RBC_params, nsamp = 10000, npop = 100000, censor = "Both") {
  mu = RBC_params[1] %>% as.numeric()
  sig = RBC_params[2] %>% as.numeric()
  
  gen = rnorm(nsamp)
  
  lb_1_gen = 4.56 + (1.067*gen)
  rho = -0.997
  mu_2 = -1.7 + 0.16*rho*gen
  sig_2_2 = 0.16*0.16*(1-rho*rho)
  
  lb_2_gen = mu_2 + sqrt(sig_2_2)*rnorm(nsamp)
  
  RBC = exp(mu + rnorm(npop) * sig)
  cases = tibble(ntds = numeric())
  
  for (i in 1:nsamp) {
    
    e1 = lb_1_gen[i] + lb_2_gen[i]*log(RBC)
    p_hat1 = exp(e1)/(1 + exp(e1))
    
    if(censor %in% c("Upper", "Both")) {p_hat1[RBC > 1500] = 0.000389}
    if(censor %in% c("Lower", "Both")) {p_hat1[RBC < 300] = 0.005917}
    
    u1 = runif(npop)
    
    numNTD = sum(p_hat1 > u1)
    
    cases = cases %>% add_case(ntds = numNTD)
  }
  
  scale = npop/nsamp
  
  quants = quantile(cases$ntds, c(0.025, 0.5, 0.975))/scale
  
  output = tibble(median = quants[2],
                  ll = quants[1],
                  ul = quants[3])
  
  return(output)
  
}


NTD_estimate_pop2 <- function(RBC_params1, RBC_params2, nsamp = 10000, npop = 100000, censor = "Both") {
  mu1 = RBC_params1[1] %>% as.numeric()
  sig1 = RBC_params1[2] %>% as.numeric()
  
  mu2 = RBC_params2[1] %>% as.numeric()
  sig2 = RBC_params2[2] %>% as.numeric()
  
  gen = rnorm(nsamp)
  
  lb_1_gen = 4.56 + (1.067*gen)
  rho = -0.997
  mu_2 = -1.7 + 0.16*rho*gen
  sig_2_2 = 0.16*0.16*(1-rho*rho)
  
  lb_2_gen = mu_2 + sqrt(sig_2_2)*rnorm(nsamp)
  
  RBC1 = exp(mu1 + rnorm(npop) * sig1)
  RBC2 = exp(mu2 + rnorm(npop) * sig2)
  cases = tibble(ntds1 = numeric(),
                 ntds2 = numeric())
  
  for (i in 1:nsamp) {
    
    e1 = lb_1_gen[i] + lb_2_gen[i]*log(RBC1)
    p_hat1 = exp(e1)/(1 + exp(e1))
    
    if(censor %in% c("Upper", "Both")) {p_hat1[RBC1 > 1500] = 0.000389}
    if(censor %in% c("Lower", "Both")) {p_hat1[RBC1 < 300] = 0.005917}
    
    u1 = runif(npop)
    numNTD1 = sum(p_hat1 > u1)
    
    e2 = lb_1_gen[i] + lb_2_gen[i]*log(RBC2)
    p_hat2 = exp(e2)/(1 + exp(e2))
    
    if(censor %in% c("Upper", "Both")) {p_hat2[RBC2 > 1500] = 0.000389}
    if(censor %in% c("Lower", "Both")) {p_hat2[RBC2 < 300] = 0.005917}
    
    u2 = runif(npop)
    numNTD2 = sum(p_hat2 > u2)
    
    cases = cases %>% add_case(ntds1 = numNTD1,
                               ntds2 = numNTD2)
  }
  
  scale = npop/nsamp
  
  cases = cases %>%
    mutate(diff = ntds1 - ntds2,
           p_gt = case_when(diff > 0 ~ 1,
                            TRUE ~ 0))
  
  quants1 = quantile(cases$ntds1, c(0.025, 0.5, 0.975))/scale
  quants2 = quantile(cases$ntds2, c(0.025, 0.5, 0.975))/scale
  quantsDiff = quantile(cases$diff, c(0.025, 0.5, 0.975))/scale
  
  p_gt_0 <- mean(cases$p_gt)
  
  output = tribble(~pop, ~median, ~ll, ~ul,
                   "1", quants1[2], quants1[1], quants1[3],
                   "2", quants2[2], quants2[1], quants2[3],
                   "Diff", quantsDiff[2], quantsDiff[1], quantsDiff[3],
                   "P gt 0", p_gt_0, NA_real_, NA_real_)
  
  return(output)
  
}

