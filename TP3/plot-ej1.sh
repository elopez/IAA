library("ggplot2")
x = read.csv("out-ej7/plot-error-after-prune.csv", header=F)
a = aggregate(x[x[,1]=='a',3:4], list(x[x[,1]=='a',2]), mean)
b = aggregate(x[x[,1]=='b',3:4], list(x[x[,1]=='b',2]), mean)
w = read.csv("out-ej7/discrete-error.csv", header=F)
ann = aggregate(w[w[,1]=='a',3], list(w[w[,1]=='a',2]), median)
bnn = aggregate(w[w[,1]=='b',3], list(w[w[,1]=='b',2]), median)
v = read.csv("out-ej7/bayes-error.csv", header=F)
anb = aggregate(v[v[,1]=='a',3:4], list(v[v[,1]=='a',2]), median)
bnb = aggregate(v[v[,1]=='b',3:4], list(v[v[,1]=='b',2]), median)


atrain = aes(y = V3, colour = "A - Train", linetype="Decision Trees")
atest = aes(y = V4, colour = "A - Test", linetype="Decision Trees")
atestnn = aes(y = x, colour = "A - Test", linetype="Neural Networks")
atrainnb = aes(y = V3, colour = "A - Train", linetype="Naive Bayes")
atestnb = aes(y = V4, colour = "A - Test", linetype="Naive Bayes")
btrain = aes(y = V3, colour = "B - Train", linetype="Decision Trees")
btest = aes(y = V4, colour = "B - Test", linetype="Decision Trees")
btestnn = aes(y = x, colour = "B - Test", linetype="Neural Networks")
btrainnb = aes(y = V3, colour = "B - Train", linetype="Naive Bayes")
btestnb = aes(y = V4, colour = "B - Test", linetype="Naive Bayes")
ggplot(a, aes(Group.1)) +
  # A
  geom_point(atrain) +
  geom_point(atest) +
  geom_point(data = anb, atrainnb) +
  geom_point(data = anb, atestnb) +
  geom_point(data = ann, atestnn) +
  geom_line(atrain) +
  geom_line(atest) +
  geom_line(data = anb, atrainnb) +
  geom_line(data = anb, atestnb) +
  geom_line(data=ann, atestnn) +
  # B
  geom_point(data = b, btrain) +
  geom_point(data = b, btest) +
  geom_point(data = bnb, btrainnb) +
  geom_point(data = bnb, btestnb) +
  geom_point(data = bnn, btestnn) +
  geom_line(data = b, btrain) +
  geom_line(data = b, btest) +
  geom_line(data = bnb, btrainnb) +
  geom_line(data = bnb, btestnb) +
  geom_line(data = bnn, btestnn) +
  labs(y = "Error porcentual promedio") +
  labs(x = "Valor de d") +
  labs(title = "Error porcentual") +
  theme(legend.title=element_blank()) +
  guides(fill = guide_legend(keywidth = 1, keyheight = 1),
    linetype=guide_legend(keywidth = 2, keyheight = 1),
    colour=guide_legend(keywidth = 2, keyheight = 1))
