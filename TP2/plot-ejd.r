library("ggplot2")
library("scales")
options(scipen = 9999)

get_data <- function(msefile, gamma) {
    r = read.csv(msefile, header=F, sep="\t")
    x = cbind(seq(200, 100000, 200), r)
    colnames(x) <- c("epoch", "ign", "rtrain", "rver", "rtest", "ctrain", "cver", "ctest", "mse_decay")
    x$decay <- x$mse_decay * gamma
    return(x);
}

atrain = aes(y = rtrain, colour = "Entrenamiento")
atest = aes(y = rtest, colour = "Prueba")
adecay = aes(y = decay, colour = "Decay")

do_plot <- function(msefile, gamma) {
    x = get_data(msefile, gamma)
    q = ggplot(x, aes(epoch)) +
      labs(x = "Época") +
      theme(legend.title=element_blank()) +
      scale_x_continuous(labels = comma)

#    print(q +
#      geom_point(atrain) +
#      geom_point(atest) +
#      geom_line(atrain) +
#      geom_line(atest) +
#      labs(title = paste("Errores por época, gamma", gamma)))

    print(q +
      geom_point(adecay) +
      geom_line(adecay) +
      labs(y = "Decay") +
      labs(title = paste("Decay por época, gamma", gamma)))

    print(q +
      geom_point(atrain) +
      geom_point(atest) +
      stat_smooth(atrain) +
      stat_smooth(atest) +
      labs(y = "Error") +
      labs(title = paste("Errores por época (suavizado), gamma", gamma)))
}

do_plot("out-ejd/ejd-g-0..00000001-12.mse", 0.00000001)
do_plot("out-ejd/ejd-g-0.0000001-10.mse",   0.0000001)
do_plot("out-ejd/ejd-g-0.000001-7.mse",     0.000001)
do_plot("out-ejd/ejd-g-0.00001-3.mse",      0.00001)
do_plot("out-ejd/ejd-g-0.0001-7.mse",       0.0001)
do_plot("out-ejd/ejd-g-0.001-18.mse",       0.001)
do_plot("out-ejd/ejd-g-0.01-9.mse",         0.01)
do_plot("out-ejd/ejd-g-0.1-6.mse",          0.1)
do_plot("out-ejd/ejd-g-1-5.mse",            1)

