library("ggplot2")
library("scales")
r = read.csv("eja/eja-l-0.1-m-0-14.mse", header=F, sep="\t")
x = cbind(seq(200, 40000, 200), r)
colnames(x) <- c("epoch", "ign", "rtrain", "rver", "rtest", "ctrain", "cver", "ctest")
train = aes(y = ctrain, colour = "Entrenamiento")
verif = aes(y = cver, colour = "Verificación")
test = aes(y = ctest, colour = "Prueba")
ggplot(x, aes(epoch)) +
  geom_point(train) +
  geom_point(verif) +
  geom_point(test) +
  geom_line(train) +
  geom_line(verif) +
  geom_line(test) +
  labs(y = "MSE") +
  labs(x = "Época") +
  labs(title = "MSE por época") +
  theme(legend.title=element_blank()) +
  scale_x_continuous(labels = comma) +
  geom_vline(xintercept = 28400)
#  stat_smooth(train) +
#  stat_smooth(verif) +
#  stat_smooth(test)
