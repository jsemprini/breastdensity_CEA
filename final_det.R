
#after running probablistic (however, not running 11/6/19)

se <- define_dsa(
  price_mam, 50, 150,
  price_test, 0, 30,
  price_notification, 0, 50,
  rate, 0.01, 0.07,
  utility_notified, .98,1, 
  utility_fp, .98, 1,
  price_tomo, 150, 350,
  price_cancer_ear, 50000, 100000,
  utility_early, .79, .98,
  price_cancer_late, 115000, 200000,
  utility_late, .29, .69,
  p_cancer, .001, .002,
  rr_DB, 3,7,
  p_early, .9, .98,
  p_missed_early, .25, .75,
  rr_DB_l, 2, 17,

  p_DB, .53, .75, 
  p_adv, .1, .2,
  p_edeath, .006, .016,
  p_ldeath, .2, .3
)

dsa_mod <- run_dsa(
  model = prob_mod,
  dsa = se
)

dsa_mod

dsa_print <- print(dsa_mod)

plot(dsa_mod,
     strategy = "nolaw",
     result = "cost",
     type = "simple",
     remove_ns ="TRUE")

plot(dsa_mod,
     strategy = "law",
     result = "cost",
     type = "simple",
     remove_ns ="TRUE")

plot(dsa_mod, 
     strategy = "nolaw",
     result = "effect",
     type = "simple",
     remove_ns ="TRUE")

plot(dsa_mod, 
     strategy = "law",
     result = "effect",
     type = "simple",
     remove_ns ="TRUE")

plot(dsa_mod,
     strategy = "law",
     result = "cost",
     type = "difference",
     remove_ns ="TRUE")


plot(dsa_mod,
     strategy = "law",
     result = "effect",
     type = "difference",
     remove_ns ="TRUE")

plot(dsa_mod,
     strategy = "law",
     result = "icer",
     type = "difference",
     remove_ns ="TRUE")


#OTHER OPTION

plot(dsa_mod,
     strategy = "nolaw",
     result = "cost",
     type = "simple",
     remove_ns ="TRUE",
     limits_by_bars = FALSE)

plot(dsa_mod,
     strategy = "law",
     result = "cost",
     type = "simple",
     remove_ns ="TRUE",
     limits_by_bars = FALSE)

plot(dsa_mod, 
     strategy = "nolaw",
     result = "effect",
     type = "simple",
     remove_ns ="TRUE",
     limits_by_bars = FALSE)

plot(dsa_mod, 
     strategy = "law",
     result = "effect",
     type = "simple",
     remove_ns ="TRUE",
     limits_by_bars = FALSE)

plot(dsa_mod,
     strategy = "law",
     result = "cost",
     type = "difference",
     remove_ns ="TRUE",
     limits_by_bars = FALSE)


plot(dsa_mod,
     strategy = "law",
     result = "effect",
     type = "difference",
     remove_ns ="TRUE",
     limits_by_bars = FALSE)

plot(dsa_mod,
     strategy = "law",
     result = "icer",
     type = "difference",
     remove_ns ="TRUE",
     limits_by_bars = FALSE)

plot(dsa_mod,
     strategy = "law",
     result = "icer",
     type = "difference",
     remove_ns ="TRUE",
     limits_by_bars = FALSE)


