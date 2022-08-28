setwd('/home/pc-752828/Dev/results-search-master/outputs-normal')

library(ggplot2)
library(dplyr)
library(extrafont)
library(dplyr)
library('EnvStats')
library("tikzDevice")

data <- read.csv(file = 'output-n-norm-bo4-with-o-w.csv', sep = ',', header = T)
data_new <- data
value <- function(x, name) {
  mym = mean(x)
  mysd = sd(x)
  mysqrt = sqrt(length(x))
  
  return(c(mn = mym, sd = mysd/mysqrt, bo = name))
}




data_f<-data.frame(data_new[data_new['bo'] == 'bo3',])
bo3 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6sel-EIdef')))
bo3 <- as.data.frame(as.list(bo3))



data_f<-data.frame(data_new[data_new['bo'] == 'bo4' & data_new['target'] == 0,])
bo4 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt - Previsto')))
bo4 <- as.data.frame(as.list(bo4))

data_f<-data.frame(data_new[data_new['bo'] == 'bo4' & data_new['target'] == 1,])
bo5 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt - Ótimo - SC')))
bo5 <- as.data.frame(as.list(bo5))

data_f<-data.frame(data_new[data_new['bo'] == 'bo4' & data_new['target'] == 3,])
bo6 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt - Pior - SC')))
bo6 <- as.data.frame(as.list(bo6))

data_f<-data.frame(data_new[data_new['bo'] == 'bo4' & data_new['target'] == 2,])
bo7 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt - Aleatório')))
bo7 <- as.data.frame(as.list(bo7))





data_f<-data.frame(data_new[data_new['bo'] == 'rs',])
bo9 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'Ranking Search')))
bo9 <- as.data.frame(as.list(bo9))


data_f<-data.frame(data_new[data_new['bo'] == 'bo4' & data_new['target'] == 5,])
bo10 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt - Ótimo - TOP5')))
bo10 <- as.data.frame(as.list(bo10))

data_f<-data.frame(data_new[data_new['bo'] == 'bo4' & data_new['target'] == 4,])
bo11 <- aggregate(x = data_f$best,
                  by = list(data_f$ite),
                  FUN = function(x) return(value(x, 'PB3Opt - Pior - TOP5')))
bo11 <- as.data.frame(as.list(bo11))

df <- rbind(bo3, bo4, bo5, bo6, bo10, bo11, bo7, bo9)
df$x.mn = as.numeric(as.character(df$x.mn))
df$Group.1 = as.numeric(as.character(df$Group.1))
df$x.sd = as.numeric(as.character(df$x.sd))
df_new <- df[df['Group.1'] >= 6,]

tikz('fig2.tex')
ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.mn-1.96*x.sd, ymax=x.mn+1.96*x.sd,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  #coord_cartesian(ylim=c(1,1.2), xlim=c(1,30))+
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  #geom_hline(yintercept=1.22369954611662, linetype="dashed", color = "red", size=1)+
  labs(color = element_blank(), x="Iteração", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.8, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        #axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  scale_x_continuous(breaks = seq(1, 30, 1))
dev.off()
