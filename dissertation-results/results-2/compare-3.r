setwd('/home/pc-752828/Dev/results-search-master')

data <- read.csv(file = 'output.out', sep = ',', header = T)
data_new <- data
value <- function(x, name) {
  mym = mean(x)
  mysd = sd(x)
  mysqrt = sqrt(length(x))
  
  return(c(mn = mym, sd = mysd/mysqrt, bo = name))
}

data_f<-data.frame(data_new[data_new['target'] == 0,])
bo1 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6rnd-EIdef-PI')))
bo1 <- as.data.frame(as.list(bo1))

data_f<-data.frame(data_new[data_new['target'] == 1,])
bo2 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6rnd-EIdef-Real')))
bo2 <- as.data.frame(as.list(bo2))

data_f<-data.frame(data_new[data_new['target'] == 2,])
bo3 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt-PI')))
bo3 <- as.data.frame(as.list(bo3))

data_f<-data.frame(data_new[data_new['target'] == 3,])
bo4 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt-Real')))
bo4 <- as.data.frame(as.list(bo4))

data_f<-data.frame(data_new[data_new['target'] == 4,])
bo5 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO6sel-EIdef-PI')))
bo5 <- as.data.frame(as.list(bo5))

data_f<-data.frame(data_new[data_new['target'] == 5,])
bo6 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO6sel-EIdef-Real')))
bo6 <- as.data.frame(as.list(bo6))

df <- rbind(bo1, bo2, bo3, bo4)
df$x.mn = as.numeric(as.character(df$x.mn))
df$Group.1 = as.numeric(as.character(df$Group.1))
df$x.sd = as.numeric(as.character(df$x.sd))
df_new <- df

p3 <- ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  coord_cartesian(ylim=c(1,1.2), xlim=c(1,30))+
  labs(color = element_blank(), x="Iteração", y="Média do Melhor Custo Normalizado")+
  theme(legend.position = "none")+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  scale_x_continuous(minor_breaks = seq(0, 35, 0.5))+
  scale_y_continuous(minor_breaks = seq(0, 10, 1))+ ggtitle('c) Zoom da Figura a')


p2 <- ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  coord_cartesian(ylim=c(1,2), xlim=c(1,30))+
  labs(color = element_blank(), x="Iteração", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.95, .95),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  scale_x_continuous(minor_breaks = seq(0, 35, 0.5))+
  scale_y_continuous(minor_breaks = seq(0, 10, 1))+ ggtitle('b) Zoom da Figura a')

p1 <- ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  labs(color = element_blank(), x="Iteração", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.95, .95),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8),
        legend.background = element_rect(fill=alpha('white', 0.6)))+
  scale_x_continuous(minor_breaks = seq(0, 35, 0.5))+
  scale_y_continuous(minor_breaks = seq(0, 800, 100))+ ggtitle('a) Melhor Custo Encontrado')

tikz('fig3.tex')
grid.arrange(p1, p2, nrow = 2, ncol=1, top="", left="Média do Melhor Custo Normalizado")
dev.off()







data <- read.csv(file = 'output_cost.out', sep = ',', header = T)
data_new <- data
value <- function(x, name) {
  mym = mean(x)
  mysd = sd(x)
  mysqrt = sqrt(length(x))
  
  return(c(mn = mym, sd = mysd/mysqrt, bo = name))
}



data_f<-data.frame(data_new[data_new['target'] == 0,])
bo1 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6rnd-EIdef-PI')))
bo1 <- as.data.frame(as.list(bo1))

data_f<-data.frame(data_new[data_new['target'] == 1,])
bo2 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6rnd-EIdef-Real')))
bo2 <- as.data.frame(as.list(bo2))

data_f<-data.frame(data_new[data_new['target'] == 2,])
bo3 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt-PI')))
bo3 <- as.data.frame(as.list(bo3))

data_f<-data.frame(data_new[data_new['target'] == 3,])
bo4 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt-Real')))
bo4 <- as.data.frame(as.list(bo4))

df <- rbind(bo1, bo2, bo3, bo4)
df$x.mn = as.numeric(as.character(df$x.mn))
df$Group.1 = as.numeric(as.character(df$Group.1))
df$x.sd = as.numeric(as.character(df$x.sd))
df_new <- df


p2 <- ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  coord_cartesian(ylim=c(1,300), xlim=c(1,30))+
  labs(color = element_blank(), x="Iteração", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.4, .95),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  scale_x_continuous(minor_breaks = seq(0, 35, 0.5))+
  scale_y_continuous(minor_breaks = seq(0, 300, 50))+ ggtitle('b) Zoom da Figura a')

p1 <- ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  labs(color = element_blank(), x="Iteração", y="Média do Custo Total Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.4, .95),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8),
        legend.background = element_rect(fill=alpha('white', 0.6)))+
  scale_x_continuous(minor_breaks = seq(0, 35, 0.5))+
  scale_y_continuous(minor_breaks = seq(0, 10000, 1000)) + ggtitle('a) Custo Total da Busca')
  #geom_segment(aes(x = 31, y = 500, xend = 31, yend = 6500), arrow = arrow(length = unit(0.5, "cm")))

tikz('fig4.tex')
grid.arrange(p1, p2, nrow = 2, ncol=1, top="", left="Média do Custo Normalizado")
dev.off()
