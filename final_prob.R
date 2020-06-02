#https://cran.r-project.org/web/packages/heemod/vignettes/c_homogeneous.html

library(heemod)

param <- define_parameters(
  price_mam = 100, 
  price_test = 0, 
  price_notification = 0, 
  rate = 0.03, 
  utility_notified = .99, 
  utility_fp = .9899,
  price_tomo = 215,
  price_cancer_ear = 82121,
  utility_early = .91,
  price_cancer_late = 134682,
  utility_late = .45,
  price_death = 0, 
  
  p_cancer = .0016155,
  rr_DB = 4.7,
  p_early = .94,
  p_missed_early = .5,
  p_late = 1- p_early,
  rr_DB_l = 7,
  
  p_DB = .617, 
  p_ecancer_DB_nolaw = p_cancer*rr_DB*p_early*p_missed_early,
  p_lcancer_DB_nolaw = p_cancer*rr_DB*p_late*rr_DB_l,
  p_ecancer_noDB = p_cancer*p_early,
  p_lcancer_noDB = p_cancer*p_late,
  p_adv = .15,
  p_edeath = .011,
  p_ldeath = .2282,
  p_ecancer_DB_law = p_cancer*rr_DB*p_early,
  p_lcancer_DB_law = p_cancer*rr_DB*p_late
)


nolaw_trans <- define_transition(
  0,p_DB,C,0,0,0,0,0,0,0,0,
  0,0,0,C,p_ecancer_DB_nolaw,p_lcancer_DB_nolaw,0,0,0,0,0,
  0,0,0,0,0,0,0,C,p_ecancer_noDB,p_lcancer_noDB,0,
  0,0,0,C,p_ecancer_DB_nolaw,p_lcancer_DB_nolaw,0,0,0,0,0,
  0,0,0,0,C,p_adv,p_edeath,0,0,0,0,
  0,0,0,0,0,C,p_ldeath,0,0,0,0,
  0,0,0,0,0,0,1,0,0,0,0,
  0,0,0,0,0,0,0,C,p_ecancer_noDB,p_lcancer_noDB,0,
  0,0,0,0,0,0,0,0,C,p_adv,p_edeath,
  0,0,0,0,0,0,0,0,0,C,p_ldeath,
  0,0,0,0,0,0,0,0,0,0,1
)

law_trans <- define_transition(
  0,p_DB,C,0,0,0,0,0,0,0,0,
  0,0,0,C,p_ecancer_DB_law,p_lcancer_DB_law,0,0,0,0,0,
  0,0,0,0,0,0,0,C,p_ecancer_noDB,p_lcancer_noDB,0,
  0,0,0,C,p_ecancer_DB_law,p_lcancer_DB_law,0,0,0,0,0,
  0,0,0,0,C,p_adv,p_edeath,0,0,0,0,
  0,0,0,0,0,C,p_ldeath,0,0,0,0,
  0,0,0,0,0,0,1,0,0,0,0,
  0,0,0,0,0,0,0,C,p_ecancer_noDB,p_lcancer_noDB,0,
  0,0,0,0,0,0,0,0,C,p_adv,p_edeath,
  0,0,0,0,0,0,0,0,0,C,p_ldeath,
  0,0,0,0,0,0,0,0,0,0,1
)

plot(nolaw_trans)
plot(law_trans)



state_A <- define_state(
  cost_total = 0,
  life_year = 0,
  utility =0
)



state_B <- define_state(
  cost_total = discount(dispatch_strategy(
    nolaw = price_mam,
    law = price_tomo + price_test + price_notification
  ), rate),
  life_year = discount(1, rate),
  utility =discount(dispatch_strategy(
    nolaw = 1,
    law = utility_notified*utility_fp), rate)
)


#


state_C <- define_state(
  cost_total = discount(dispatch_strategy(
    nolaw = price_mam,
    law = price_mam + price_test
  ),rate),
  life_year = discount(1, rate),
  utility =discount(dispatch_strategy(
    nolaw = 1,
    law = 1), rate)
)

state_D <- define_state(
  cost_total = discount(dispatch_strategy(
    nolaw = price_mam,
    law = price_tomo
  ), rate),
  life_year = discount(1, rate),
  utility =discount(dispatch_strategy(
    nolaw = 1,
    law = 1), rate)
  )

state_E <- define_state(
  cost_total = discount(dispatch_strategy(
    nolaw = price_mam + price_cancer_ear,
    law = price_tomo + price_cancer_ear
  ), rate),
  life_year = discount(1, rate),
  utility = discount(utility_early, rate)
)


state_F <- define_state(
  cost_total = discount(dispatch_strategy(
    nolaw = price_mam + price_cancer_late,
    law = price_tomo + price_cancer_late
  ),rate),
  life_year = discount(1, rate),
  utility = discount(utility_late, rate)
)

state_G <- define_state(
  cost_total = discount(price_death, rate),
  life_year = 0,
  utility = 0
)


state_H <- define_state(
  cost_total = discount(dispatch_strategy(
    nolaw = price_mam,
    law = price_tomo
  ), rate),
  life_year = discount(1, rate),
  utility =discount(dispatch_strategy(
    nolaw = 1,
    law = 1), rate)
  )

state_I <- define_state(
  cost_total = discount(price_cancer_ear + price_mam, rate),
  life_year = discount(1, rate),
  utility = discount(utility_early, rate)
)


state_J <- define_state(
  cost_total = discount(price_cancer_late + price_mam, rate),
  life_year = discount(1, rate),
  utility = discount(utility_late, rate)
)

state_K <- define_state(
  cost_total = discount(price_death, rate),
  life_year = 0,
  utility = 0
)


nolaw_strat <- define_strategy(
  transition = nolaw_trans,
  state_A,
  state_B,
  state_C,
  state_D,
  state_E,
  state_F,
  state_G,
  state_H,
  state_I,
  state_J,
  state_K
)

nolaw_strat


law_strat <- define_strategy(
  transition = law_trans,
  state_A,
  state_B,
  state_C,
  state_D,
  state_E,
  state_F,
  state_G,
  state_H,
  state_I,
  state_J,
  state_K
)

law_strat




prob_mod <- run_model(
  nolaw = nolaw_strat,
  law = law_strat,
  parameters = param,
  cycles = 25,
  cost = cost_total,
  effect = utility,
  init = c(20000000,0,0,0,0,0,0,0,0,0,0)
)

#summary CEA
summary(prob_mod,
        threshold = c(1000, 5000, 6000, 10000, 50000))

rsp <- define_psa(
  price_mam ~ gamma(mean = 100, sd = sqrt(100)),
  price_tomo ~ gamma(mean = 215, sd = sqrt(215)),
  price_cancer_ear ~ gamma(mean = 82121, sd = sqrt(82121)),
  price_cancer_late ~ gamma(mean =134682, sd = sqrt(134682)),
  
  rr_DB ~ lognormal(mean = 4.7, sd = 1.12 ),
  rr_DB_l ~ lognormal(mean = 7, sd = 5.459),

  p_DB ~ binomial(prob = .617, size = 350000),
  p_missed_early ~ binomial(prob = .5, size = 169),
  p_edeath ~ binomial(prob = .011, size = 45000),
  p_ldeath ~ binomial(prob = .2282, size = 45000),
  p_adv ~ binomial(prob = .15, size = 45000),
  p_cancer ~ binomial(prob = .0016155, size = 3400000),
  p_early ~ binomial (prob = .94, size = 34000000)
)

pm <- run_psa(
  model = prob_mod,
  psa = rsp,
  N = 1000
)

summary(pm,
        threshold = c(1000, 5000, 6000, 10000, 100000))


plot(pm, type = "ce")

plot(pm, type = "ac", max_wtp = 10000, log_scale = FALSE)

plot(pm, type = "evpi", max_wtp = 10000, log_scale = FALSE)


plot(pm, type = "cov")


plot(pm, type = "cov", diff = TRUE, threshold = 5000)


library(ggplot2)

plot(pm, type = "ce") +
  theme_minimal()

library(BCEA)

bcea <- run_bcea(pm, plot = TRUE, Kmax = 50000, ref=2)

bcea <- run_bcea(pm, plot = "FALSE", Kmax = 50000, ref=2)


summary(bcea)
