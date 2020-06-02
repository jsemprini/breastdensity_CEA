#https://cran.r-project.org/web/packages/heemod/vignettes/c_homogeneous.html

library(heemod)


nolaw_trans <- define_transition(
  0,0.617,C,0,0,0,0,0,0,0,0,
  0,0,0,C,0.00356864,0.003188997,0,0,0,0,0,
  0,0,0,0,0,0,0,0.9983845,0.00151857,0.00009693,0,
  0,0,0,C,0.00356864,0.003188997,0,0,0,0,0,
  0,0,0,0,0.839,0.15,0.011,0,0,0,0,
  0,0,0,0,0,0.7718,0.2282,0,0,0,0,
  0,0,0,0,0,0,1,0,0,0,0,
  0,0,0,0,0,0,0,0.9983845,0.00151857,0.00009693,0,
  0,0,0,0,0,0,0,0,0.839,0.15,0.011,
  0,0,0,0,0,0,0,0,0,0.7718,0.2282,
  0,0,0,0,0,0,0,0,0,0,1)

law_trans <- define_transition(
  0,.617,C,0,0,0,0,0,0,0,0,
  0,0,0,C,0.007137279,0.000455571,0,0,0,0,0,
  0,0,0,0,0,0,0,0.9983845,0.00151857,0.00009693,0,
  0,0,0,C,0.007137279,0.000455571,0,0,0,0,0,
  0,0,0,0,0.839,0.15,0.011,0,0,0,0,
  0,0,0,0,0,0.7718,0.2282,0,0,0,0,
  0,0,0,0,0,0,1,0,0,0,0,
  0,0,0,0,0,0,0,0.9983845,0.00151857,0.00009693,0,
  0,0,0,0,0,0,0,0,0.839,0.15,0.011,
  0,0,0,0,0,0,0,0,0,0.7718,0.2282,
  0,0,0,0,0,0,0,0,0,0,1
)

plot(nolaw_trans)
plot(law_trans)

#parameters
#state1
price_mam <- 100 #medicare reimbursement
price_test <- 0 #medicare reimbursement
price_notification <- 0 #assumption
rate <- 0.03 #assumption
utility_notified <- .99 #based on disutility of screening

#state2
utility_fp <- .9899 #de Hayes 1991

#state4 
price_tomo <- 215

#state5 
price_cancer_ear <- 82121
utility_early <- .91

#state6 
price_cancer_late <- 134682
utility_late <-.45

#state7 
price_death <- 0 #consider 




state_A <- define_state(
  cost_health = 0,
  cost_screen = 0,
  cost_total = discount(cost_health + cost_screen, rate),
  life_year = 0,
  utility =0,
  QALY = discount(life_year*utility, rate)
)



state_B <- define_state(
  cost_health = 0,
  cost_screen = dispatch_strategy(
    nolaw = price_mam,
    law = price_tomo + price_test + price_notification
  ), 
  cost_total = discount(cost_health + cost_screen, rate),
  life_year = 1,
  utility =dispatch_strategy(
    nolaw = 1,
    law = .99*utility_fp),
  QALY = discount(life_year*utility, rate)
)


#


state_C <- define_state(
  cost_health = 0,
  cost_screen = dispatch_strategy(
    nolaw = price_mam,
    law = price_mam + price_test
  ), 
  cost_total = discount(cost_health + cost_screen, rate),
  life_year = 1,
  utility =dispatch_strategy(
    nolaw = 1,
    law = 1),
  QALY = discount(life_year*utility, rate)
)

state_D <- define_state(
  cost_health = 0,
  cost_screen = dispatch_strategy(
    nolaw = price_mam,
    law = price_tomo
  ), 
  cost_total = discount(cost_health + cost_screen,rate),
  life_year = 1,
  utility =dispatch_strategy(
    nolaw = 1,
    law = 1),
  QALY = discount(life_year*utility, rate)
)

state_E <- define_state(
  cost_health = price_cancer_ear,
  cost_screen = dispatch_strategy(
    nolaw = price_mam,
    law = price_tomo
  ), 
  cost_total = discount(cost_health + cost_screen, rate),
  life_year = 1,
  utility = utility_early,
  QALY = discount(life_year*utility, rate)
)


state_F <- define_state(
  cost_health = price_cancer_late,
  cost_screen = dispatch_strategy(
    nolaw = price_mam,
    law = price_tomo
  ), 
  cost_total = discount(cost_health + cost_screen, rate),
  life_year = 1,
  utility = utility_late,
  QALY = discount(life_year*utility, rate)
)

state_G <- define_state(
  cost_health = price_death,
  cost_screen = 0,
  cost_total = discount(cost_health + cost_screen, rate),
  life_year = 0,
  utility = 0,
  QALY = 0
)


state_H <- define_state(
  cost_health = 0,
  cost_screen = dispatch_strategy(
    nolaw = price_mam,
    law = price_tomo
  ), 
  cost_total = discount(cost_health + cost_screen, rate),
  life_year = 1,
  utility =dispatch_strategy(
    nolaw = 1,
    law = 1),
  QALY = discount(life_year*utility, rate)
)

state_I <- define_state(
  cost_health = price_cancer_ear,
  cost_screen = price_mam,
  cost_total = discount(cost_health + cost_screen, rate),
  life_year = 1,
  utility = utility_early,
  QALY = discount(life_year*utility, rate)
)


state_J <- define_state(
  cost_health = price_cancer_late, 
  cost_screen = price_mam, 
  cost_total = discount(cost_health + cost_screen, rate),
  life_year = 1,
  utility = utility_late,
  QALY = discount(life_year*utility, rate)
)

state_K <- define_state(
  cost_health = price_death,
  cost_screen = 0,
  cost_total = discount(cost_health + cost_screen, rate),
  life_year = 0,
  utility = 0,
  QALY = 0
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





homo_mod <- run_model(
  nolaw = nolaw_strat,
  law = law_strat,
  cycles = 25,
  cost = cost_total,
  effect = QALY,
  init = c(20000000,0,0,0,0,0,0,0,0,0,0)
)

#summary CEA
summary(homo_mod,
        threshold = c(1000, 5000, 6000, 10000, 100000))



#plots
plot(homo_mod, type = "counts", panel = "by_strategy")


plot(homo_mod, type = "counts", panel = "by_state")


plot(homo_mod, type = "values", panel = "by_value", free_y = "TRUE")

plot(homo_mod, type = "values", panel = "by_value", values =c("QALY"))

plot(homo_mod, type = "values", panel = "by_value", values =c("utility"))

plot(homo_mod, type = "values", panel = "by_value", values =c("life_year"))

plot(homo_mod, type = "counts", panel = "by_state", free_y= "TRUE", states= c("D", "E", "F","G"))

plot(homo_mod, type = "values", panel = "by_value", values ="cost_total")


df <- get_values(homo_mod)


