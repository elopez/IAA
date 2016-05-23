library("ggplot2")
x = read.csv("out-ej7/plot-error-after-prune.csv", header=F)
a = aggregate(x[x[,1]=='a',3:4], list(x[x[,1]=='a',2]), mean)
b = aggregate(x[x[,1]=='b',3:4], list(x[x[,1]=='b',2]), mean)
w = read.csv("out-ej7/discrete-error.csv", header=F)
ann = aggregate(w[w[,1]=='a',3], list(w[w[,1]=='a',2]), median)
bnn = aggregate(w[w[,1]=='b',3], list(w[w[,1]=='b',2]), median)

atrain = aes(y = V3, colour = "A - DT - Train")
atest = aes(y = V4, colour = "A - DT - Test")
atestnn = aes(y = x, colour = "A - NN - Test")
btrain = aes(y = V3, colour = "B - DT - Train")
btest = aes(y = V4, colour = "B - DT - Test")
btestnn = aes(y = x, colour = "B - NN - Test")
ggplot(a, aes(Group.1)) +
  # A
  geom_point(atrain) +
  geom_point(atest) +
  geom_point(data = ann, atestnn) +
  geom_line(atrain) +
  geom_line(atest) +
  geom_line(data=ann, atestnn) +
  # B
  geom_point(data = b, btrain) +
  geom_point(data = b, btest) +
  geom_point(data = bnn, btestnn) +
  geom_line(data = b, btrain) +
  geom_line(data = b, btest) +
  geom_line(data = bnn, btestnn) +
  labs(y = "Error porcentual promedio") +
  labs(x = "Valor de d") +
  labs(title = "Error porcentual") +
  theme(legend.title=element_blank())
