library("ggplot2")
library("scales")

get_data <- function(msefile) {
    r = read.csv(msefile, header=F, sep="\t")
    x = cbind(seq(50, 10000, 50), r)
    colnames(x) <- c("epoch", "ign", "rtrain", "rver", "rtest", "ctrain", "cver", "ctest")
    return(x);
}

train = aes(y = rtrain, colour = "Entrenamiento")
verif = aes(y = rver, colour = "Verificación")
test = aes(y = rtest, colour = "Prueba")

do_plot <- function(msefile, pct, minerrepoch) {
    x = get_data(msefile)
    q = ggplot(x, aes(epoch)) +
      geom_point(train) +
      geom_point(verif) +
      geom_point(test) +
      labs(y = "MSE") +
      labs(x = "Época") +
      theme(legend.title=element_blank()) +
      scale_x_continuous(labels = comma) +
      geom_vline(xintercept = minerrepoch)

    print(q + geom_line(train) +
      geom_line(verif) +
      geom_line(test) +
      labs(title = paste("MSE por época, entrenando con", pct)))

    print(q + stat_smooth(train) +
      stat_smooth(verif) +
      stat_smooth(test) +
      labs(title = paste("MSE por época, entrenando con", pct, "(suavizado, 95% de confianza)")))
}

do_plot("out-ejc/ejc-t-100-9.mse", "50%", 3150)
do_plot("out-ejc/ejc-t-150-10.mse", "75%", 2800)
do_plot("out-ejc/ejc-t-190-16.mse", "95%", 9650)


