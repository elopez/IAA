library("ggplot2")

v = read.csv("bayes-error.csv", header=F)
vals = aggregate(v[,2:4], list(v[,1]), median)

atrain = aes(y = V2, colour = "Train")
aval = aes(y = V3, colour = "Validation")
atest = aes(y = V4, colour = "Test")

g = ggplot(vals, aes(Group.1)) +
  geom_point(atrain) +
  geom_point(aval) +
  geom_point(atest) +
  theme(legend.title=element_blank()) +
  labs(y = "Error (porcentaje)", x = "Cantidad de bins", title = "Errores por cantidad de bins")

print(g +
  geom_line(atrain) +
  geom_line(aval) +
  geom_line(atest))
