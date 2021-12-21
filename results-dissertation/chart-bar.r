setwd('/home/pc-752828/Dev/results-search-master/results-csv')

library(dplyr)
library(gridExtra)
library(grid)
library(ggplot2)
library(dplyr)
library(extrafont)
library(dplyr)
library('EnvStats')
library(gtable)

data <- read.csv(file = 'output-n.out', sep = ',', header = T)

data_f1 <- data[data['ite'] == 20 & data['target'] == 0,]
data_f2 <- data[data['ite'] == 20 & data['target'] == 1,]
data_f3 <- data[data['ite'] == 20 & data['target'] == 2,]
data_f4 <- data[data['ite'] == 20 & data['target'] == 6,]

nrow(data_f3)
nrow(data_f1)
nrow(unique(data_f1['name']))
nrow(unique(data_f3['name']))

unique(data_f3['name'])
data_f4a <- data_f4 %>% filter(grepl('-A', name))
data_f3a <- data_f3 %>% filter(grepl('-A', name))
data_f2a <- data_f2 %>% filter(grepl('-A', name))
data_f1a <- data_f1 %>% filter(grepl('-A', name))

data_f4b <- data_f4 %>% filter(grepl('-B', name))
data_f3b <- data_f3 %>% filter(grepl('-B', name))
data_f2b <- data_f2 %>% filter(grepl('-B', name))
data_f1b <- data_f1 %>% filter(grepl('-B', name))

data_f4c <- data_f4 %>% filter(grepl('-C', name))
data_f3c <- data_f3 %>% filter(grepl('-C', name))
data_f2c <- data_f2 %>% filter(grepl('-C', name))
data_f1c <- data_f1 %>% filter(grepl('-C', name))

value <- function(x, myname) {
  mym = mean(x)
  mysd = sd(x)
  print(mysd)
  mysqrt = sqrt(length(x))
  return(c(mn = mym, sd = mysd/mysqrt, name=myname))
}

run_plot <- function(data, title) {
  bo1 <- aggregate(x = data$best,
                   by = list(data$name),
                   FUN = function(x) return(value(x, title)))
  bo1 <- as.data.frame(as.list(bo1))
  bo1$x.mn = as.numeric(as.character(bo1$x.mn))
  bo1$x.sd = as.numeric(as.character(bo1$x.sd))
  return(bo1)
}

bo1 <- run_plot(data_f1a, "BO-6rnd-EIdef")
bo2 <- run_plot(data_f2a, "BO com Início Estratégico")
bo4 <- run_plot(data_f4a, "BO com Função de Aquisição Nova")
bo3 <- run_plot(data_f3a, "PB3Opt")
bo <- rbind(bo1, bo3)

ggplot(bo, aes(x=Group.1, y=x.mn, fill = x.name))+
  geom_bar(stat="identity",  position=position_dodge(), alpha=0.7)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  expand_limits(y = 1) +
  coord_cartesian(ylim=c(0,3))+
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd), width=0.8, alpha=.9, size=.8, position=position_dodge(.9),
                colour="orange") +
  geom_hline(yintercept=1, linetype="dashed", color = "black", size=.5)+
  labs(fill = "Modo de Busca", x="Entrada A", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(.95, .95),legend.position=c(.95, .95),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8),
        legend.background = element_rect(fill=alpha('white', 0.6)))+ ggtitle('b) Zoom da Figura a')


bo1 <- run_plot(data_f1a, "BO-6rnd-EIdef")
bo2 <- run_plot(data_f2a, "BO com Início Estratégico")
bo4 <- run_plot(data_f4a, "BO com Função de Aquisição Nova")
bo3 <- run_plot(data_f3a, "PB3Opt")
bo <- rbind(bo1, bo3)

p1 <- ggplot(bo, aes(x=Group.1, y=x.mn, fill = x.name))+
  geom_bar(stat="identity",  position=position_dodge(), alpha=0.7)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  expand_limits(y = 1) +
  #coord_cartesian(ylim=c(1,3))+
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd), width=0.8, alpha=.9, size=.8, position=position_dodge(.9),
                colour="orange") +
  geom_hline(yintercept=1, linetype="dashed", color = "black", size=.5)+
  labs(fill = "Modo de Busca", x="Entrada A", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(.95, .95),legend.position=c(.95, .95),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8),
        legend.background = element_rect(fill=alpha('white', 0.6)))+ ggtitle('a) Melhor Custo Encontrado')



grid.arrange(p1, p2, nrow = 1, ncol=2, top="", bottom="Carga de Trabalho", 
             left="Média do Melhor Custo Normalizado")



bo1 <- run_plot(data_f1b, "BO-6rnd-EIdef")
bo2 <- run_plot(data_f2b, "BO com Início Estratégico")
bo4 <- run_plot(data_f4b, "BO com Função de Aquisição Nova")
bo3 <- run_plot(data_f3b, "PB3Opt")
bo <- rbind(bo1, bo3)

p2 <- ggplot(bo, aes(x=Group.1, y=x.mn, fill = x.name))+
  geom_bar(stat="identity",  position=position_dodge(), alpha=0.7)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  expand_limits(y = 1) +
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd), width=0.8, alpha=.9, size=.8, position=position_dodge(.9),
                colour="orange") +
  geom_hline(yintercept=1, linetype="dashed", color = "black", size=.5)+
  labs(fill = "Modo de Busca", x="Carga de Trabalho com Entrada B", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(.5, .5),legend.position=c(.5, .5),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8),
        legend.background = element_rect(fill=alpha('white', 0.6)))


bo1 <- run_plot(data_f1c, "BO-6rnd-EIdef")
bo2 <- run_plot(data_f2c, "BO com Início Estratégico")
bo4 <- run_plot(data_f4c, "BO com Função de Aquisição Nova")
bo3 <- run_plot(data_f3c, "PB3Opt")
bo <- rbind(bo1, bo3)

p3 <- ggplot(bo, aes(x=Group.1, y=x.mn, fill = x.name))+
  geom_bar(stat="identity",  position=position_dodge(), alpha=0.7)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  expand_limits(y = 1) +
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd), width=0.8, alpha=.9, size=.8, position=position_dodge(.9),
                colour="orange") +
  geom_hline(yintercept=1, linetype="dashed", color = "black", size=.5)+
  labs(fill = "Modo de Busca", x="Carga de Trabalho com Entrada C", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(.5, .5),legend.position=c(.5, .5),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8),
        legend.background = element_rect(fill=alpha('white', 0.6)))



grid.arrange(p1, p2, p3, nrow = 3, ncol=1, top="", bottom="Carga de Trabalho", 
             left="Média do Melhor Custo Normalizado")









  #scale_x_continuous(minor_breaks = seq(0, 35, 0.5))+
  #scale_y_continuous(minor_breaks = seq(0, 800, 100))+ ggtitle('a) Melhor Custo Encontrado')
  #coord_cartesian(ylim=c(1,1.5))
  #theme(legend.position = "top",
  #      axis.title.x=element_blank(),
  #      axis.title.y=element_blank(),
  #      axis.text.y=element_blank(),
  #      axis.ticks.y=element_blank())
#dev.off()

bo1 <- run_plot(data_f1a, "BO com Início Aleatório")
bo2 <- run_plot(data_f2a, "BO com Início Estratégico")
bo3 <- run_plot(data_f3a, "Abordagem Proposta")
bo <- rbind(bo1, bo3)
#pdf("rplot.pdf") 
p1 <- ggplot(bo, aes(x=Group.1, y=x.mn, fill = x.name))+
  geom_bar(stat="identity",  position=position_dodge(), alpha=0.7)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  expand_limits(y = 1) +
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd), width=0.4, alpha=.9, size=.8, position=position_dodge(.9),
                colour="orange") +
  geom_hline(yintercept=1, linetype="dashed", color = "black", size=.5)+
  theme(legend.position = "none",
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())
#  labs(fill = "Modo de Busca", x="Carga de Trabalho", y="Média do Melhor Custo Normalizado")
#dev.off()

bo1 <- run_plot(data_f1b, "BO com Início Aleatório")
bo2 <- run_plot(data_f2b, "BO com Início Estratégico")
bo3 <- run_plot(data_f3b, "Abordagem Proposta")
bo <- rbind(bo1, bo3)
#pdf("rplot.pdf") 
p2 <- ggplot(bo, aes(x=Group.1, y=x.mn, fill = x.name))+
  geom_bar(stat="identity",  position=position_dodge(), alpha=0.7)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  expand_limits(y = 1) +
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd), width=0.4, alpha=.9, size=.8, position=position_dodge(.9),
                colour="orange") +
  geom_hline(yintercept=1, linetype="dashed", color = "black", size=.5)+
  theme(legend.position = "none",
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())
#  labs(fill = "Modo de Busca", x="none", y="none")
#dev.off()

bo1 <- run_plot(data_f1a, "BO com Início Aleatório")
bo2 <- run_plot(data_f2a, "BO com Início Estratégico")
bo3 <- run_plot(data_f3a, "Abordagem Proposta")
bo <- rbind(bo1, bo3)
p3 <- ggplot(bo, aes(x=Group.1, y=x.mn, fill = x.name))+
  geom_bar(stat="identity",  position=position_dodge(), alpha=0.7)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  expand_limits(y = 1) +
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd), width=0.4, alpha=.9, size=.8, position=position_dodge(.9),
                colour="orange") +
  geom_hline(yintercept=1, linetype="dashed", color = "black", size=.5)+
  theme(axis.title.x=element_blank(),
        axis.title.y=element_blank())
  #labs(fill = "Modo de Busca", x="", y="")

#legend = gtable_filter(ggplot_gtable(ggplot_build(p3)), "guide-box")

#pdf("rplot.pdf") 
grid.arrange(p1, p2, p3, nrow = 3, ncol=1, top="", bottom="Carga de Trabalho", 
             left="Média do Melhor Custo Normalizado")
#dev.off()
