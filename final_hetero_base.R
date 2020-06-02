library(heemod)

param2 <- define_parameters(
  #static
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
  rr_DB = 4.7,
  p_early = .94,
  p_missed_early = .5,
  p_late = 1- p_early,
  rr_DB_l = 7,
  p_adv = .15,
  p_edeath = .011,
  p_ldeath = .2282,
  
  #variable
  age_init = 40,
  hist = 0,
  # age increases with cycles
  age = age_init + markov_cycle,
  
  # parameters for calculating cancer probability
  cons = .0016155,
  ageC = 0.000264767,
  fam1 = 0,
  fam2 = 0,
  hist1C = 1.77,
  hist2C = 2.52,
  
  p_cancer = (cons + ageC * age + ageC*ageC*age + cons*fam1*hist1C + cons*hist2C*fam2),
  
  #parameters for calculating BD probability
  cons2= .617,
  ageC2= -0.012666667,
  
  p_DB = cons2 + age_init*ageC2 - age_init*ageC2^2 + age_init*ageC2^3,
  
  #model
  
  p_ecancer_DB_nolaw = p_cancer*rr_DB*p_early*p_missed_early,
  p_lcancer_DB_nolaw = p_cancer*rr_DB*p_late*rr_DB_l,
  p_ecancer_noDB = p_cancer*p_early,
  p_lcancer_noDB = p_cancer*p_late,
  
  p_ecancer_DB_law = p_cancer*rr_DB*p_early,
  p_lcancer_DB_law = p_cancer*rr_DB*p_late
)
param2

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
    law = .99*utility_fp), rate)
)





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

het_mod <- run_model(
  nolaw = nolaw_strat,
  law      = law_strat,
  parameters = param2,
  cycles = 25,
  cost = cost_total,
  effect = utility
)

summary(het_mod)


#plots
plot(het_mod, type = "counts", panel = "by_strategy")


plot(het_mod, type = "counts", panel = "by_state")


plot(het_mod, type = "values", panel = "by_value", free_y = "TRUE")

plot(het_mod, type = "values", panel = "by_value", values =c("QALY"))

plot(het_mod, type = "values", panel = "by_value", values =c("utility"))

plot(het_mod, type = "values", panel = "by_value", values =c("life_year"))

plot(het_mod, type = "counts", panel = "by_state", free_y= "TRUE", states= c("D", "E", "F","G"))

plot(het_mod, type = "values", panel = "by_value", values ="cost_total")  
