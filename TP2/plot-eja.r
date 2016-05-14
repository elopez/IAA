minerrepoch = 16000
msefile = "out-eja/eja-l-0.01-m-0.9-21.mse"

library("ggplot2")
library("scales")
r = read.csv(msefile, header=F, sep="\t")
x = cbind(seq(200, 40000, 400), r)
colnames(x) <- c("epoch", "ign", "rtrain", "rver", "rtest", "ctrain", "cver", "ctest")
train = aes(y = ctrain, colour = "Entrenamiento")
verif = aes(y = cver, colour = "Verificación")
test = aes(y = ctest, colour = "Prueba")
p = ggplot(x, aes(epoch)) +
  geom_point(train) +
  geom_point(verif) +
  geom_point(test) +
  labs(y = "MSE") +
  labs(x = "Época") +
  theme(legend.title=element_blank()) +
  scale_x_continuous(labels = comma) +
  geom_vline(xintercept = minerrepoch)

p + geom_line(train) +
  geom_line(verif) +
  geom_line(test) +
  labs(title = "MSE por época")


p + stat_smooth(train) +
  stat_smooth(verif) +
  stat_smooth(test) +
  labs(title = "MSE por época (suavizado, 95% de confianza)")
