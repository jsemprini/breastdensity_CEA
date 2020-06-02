#after running non-homogenous

res_h <- update(het_mod, newdata = ceatab1)

summary(res_h)


plot(res_h, result = "effect", binwidth = 5)


plot(res_h, result = "cost", binwidth = 50)


plot(res_h, result = "icer", type = "difference",
     binwidth = 500)

plot(res_h, result = "effect", type = "difference",
     binwidth = .1)

plot(res_h, result = "cost", type = "difference",
     binwidth = 30)

plot(res_h, type = "counts")


