setwd('/home/pc-752828/Dev/results-search-master/results-csv')

library(ggplot2)
library(reshape2)
library(ggstatsplot)
library(tcltk)
library(rstatix)
library(PMCMRplus)

data <- read.csv(file = 'output-n.out', sep = ',', header = T)
data_new <- data

value <- function(x, name) {
  mym = mean(x)
  mysd = sd(x)
  mysqrt = sqrt(length(x))
  
  return(c(mn = mym, sd = mysd/mysqrt, bo = name))
}

for(i in levels(factor(data_new$name))) {
print(i)
data_f<-data.frame(data[data['name'] == i & data['bo'] == 'bo1',])
bo1 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6rnd-EIdef')))
bo1 <- as.data.frame(as.list(bo1))

data_f<-data.frame(data[data['name'] == i & data['bo'] == 'bo4' & data['target'] == 2,])
bo2 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt')))
bo2 <- as.data.frame(as.list(bo2))

data_f<-data.frame(data[data['name'] == i & data['bo'] == 'rs',])
bo3 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'RS')))
bo3 <- as.data.frame(as.list(bo3))

data_f<-data.frame(data[data['name'] == i & data['bo'] == 'bo5',])
bo4 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6rnd-EInova')))
bo4 <- as.data.frame(as.list(bo4))

df <- rbind(bo1, bo2, bo3, bo4)
df$x.mn = as.numeric(as.character(df$x.mn))
df$Group.1 = as.numeric(as.character(df$Group.1))
df$x.sd = as.numeric(as.character(df$x.sd))
df_new <- df

name <- paste('imgs', i, sep = "/" )
pdf(paste(name, "-zoom.pdf", sep=""))

print(ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  coord_cartesian(ylim=c(1,2), xlim=c(1,30))+
  labs(color = element_blank(), x="Iteração", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.8, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  scale_x_continuous(breaks = seq(1, 30, 1)))
dev.off()

pdf(paste(name, "pdf", sep="."))
print(ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  #coord_cartesian(ylim=c(1,2), xlim=c(1,30))+
  labs(color = element_blank(), x="Iteração", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.8, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  scale_x_continuous(breaks = seq(1, 30, 1)))
dev.off()
}
















library(ggplot2)
library(reshape2)
library(reshape)
library(ggstatsplot)
library(tcltk)
library(rstatix)
library(dplyr)

data <- read.csv(file = 'output-n.out', sep = ',', header = T)
data_new <- data

my_ite <- 15
bo1 <- list()
bo2 <- list()
bo3 <- list()
bo4 <- list()
rs <- list()
app <- list()

for(seed in seq(2, 2)) {
  for(i in levels(factor(data_new$name))) {
    #r_my <- data[data['name'] == i & data['bo'] == 'bo4' & data['target'] == 2 & data['ite'] == my_ite,][seed,]
    r_bo1 <- data[data['name'] == i & data['bo'] == 'bo1' & data['ite'] == my_ite,][seed,]
    r_bo4 <- data[data['name'] == i & data['bo'] == 'bo4' & data['ite'] == my_ite,][seed,]
    r_bo3 <- data[data['name'] == i & data['bo'] == 'bo3' & data['ite'] == my_ite,][seed,]
    r_bo2 <- data[data['name'] == i & data['bo'] == 'bo5' & data['ite'] == my_ite,][seed,]
    r_rs <- data[data['name'] == i & data['bo'] == 'rs' & data['ite'] == my_ite,][seed,]
    bo1 <- append(bo1, levels(factor(r_bo1$best)))
    bo2 <- append(bo2, levels(factor(r_bo2$best)))
    bo3 <- append(bo3, levels(factor(r_bo3$best)))
    bo4 <- append(bo4, levels(factor(r_bo4$best)))
    rs <- append(rs, levels(factor(r_rs$best)))
    app <- append(app, i)
  }
}

df_1<-cbind(bo1, bo2, bo3, bo4, rs, app)
df_1 <- data.frame(df_1)

df_2<-cbind(bo1, bo2, bo3, bo4, rs, app)
df_2 <- data.frame(df_2)

df_1$bo1 = as.numeric(as.character(df_1$bo1))
df_1$bo2 = as.numeric(as.character(df_1$bo2))
df_1$bo3 = as.numeric(as.character(df_1$bo3))
df_1$bo4 = as.numeric(as.character(df_1$bo4))
df_1$rs = as.numeric(as.character(df_1$rs))

df_2$bo1 = as.numeric(as.character(df_2$bo1))
df_2$bo2 = as.numeric(as.character(df_2$bo2))
df_2$bo3 = as.numeric(as.character(df_2$bo3))
df_2$bo4 = as.numeric(as.character(df_2$bo4))
df_2$rs = as.numeric(as.character(df_2$rs))

summary(df$bo1)
summary(df$bo2)
summary(df$bo3)
summary(df$bo4)
summary(df$rs)

cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search", "ID")
colnames(df_1) <- cols

View(df)
glimpse(df_1)

df_1$ID = as.character(df_1$ID)
df_1$ID <- factor(df_1$ID)

cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search")
new_df <- melt(df, id = "ID", measured = cols)

glimpse(new_df)

#new_df$app = as.character(new_df$app)
write.csv(x=df_1,file="teste.csv", row.names = FALSE)

new_df <- data.frame(new_df)
glimpse(new_df)

new_df <- sort_df(new_df, vars = 'id')
new_df$id <- as.numeric(new_df$id)
new_df$id <- factor(new_df$id)

glimpse(new_df)

new_df %>% group_by(variable) %>%
  identify_outliers(value)

new_df %>% group_by('variable') %>%
  shapiro_test(value)

new_df %>% group_by("variable") %>%
  get_summary_stats(value, type = "median_iqr")

new_df %>% group_by(variable) %>%
  print(value)

shapiro.test(df$`Ranking Search`)

kruskal.test(value ~ variable, data = new_df)


dunn_test(value ~ variable, data = new_df, p.adjust.method = "holm", detailed = FALSE)

df$dif <- df$bo1-df$bo4

par(mfrow=c(2, 3))
xrange <- range( 0, 95, 50)
hist(df$bo1, breaks=50, col=rgb(1, 1,1,0.5), xlim = xrange,
     xlab="Custo Normalizado" , ylab="Frequência", main = "BO-6rnd-EIdef")
axis(1, at=seq(10,30,by=10), labels=seq(10,30,by=10) )

hist(df$bo2, breaks=50, col=rgb(1,1,1,0.5), xlab="height" , ylab="nbr of plants")
hist(df$bo3, breaks=50, col=rgb(1,1,1,0.5), xlab="height" , ylab="nbr of plants")
hist(df$bo4, breaks=50, col=rgb(1,1,1,0.5), xlab="height" , ylab="nbr of plants")
hist(df$rs, breaks=50, col=rgb(1,1,1,0.5), xlab="height" , ylab="nbr of plants")

ggplot(df, aes(x=bo3)) + geom_histogram()+
  theme(legend.justification=c(1, 1),legend.position=c(.9, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8),
        legend.background = element_rect(fill=alpha('white', 0.6)))

wilcox.test(df$bo1, df$bo4, paired = TRUE, alternative = "greater", conf.int = TRUE)


tikz('boxplot.tex')

par(mfrow=c(2, 3))

boxplot(df_1$bo1,df_1$bo2, df_1$bo3, df_1$bo4, df_1$rs, xlab = "Abordagem", ylab = "Custo Normalizado", outline = FALSE)
grid(nx=16, ny=16)
boxplot(df$bo1,df$bo2, df$bo3, df$bo4, df$rs, add = TRUE,
        xlab = "Abordagem", 
        ylab = "Custo Normalizado",
        names=c('A1', 'A2', 'A3', 'A4', 'A5'))
legend(x=2,y=2,legend=c("A1 - BO-6rnd-EIdef",
                        "A2 - BO-6rnd-EInova",
                        "A3 - BO-6sel-EIdef",
                        "A4 - BO3Opt",
                        "A5 - Ranking Search"),
       fill=c("white","white","white","white","white"), bty = "n")


dev.off()















par(mfrow=c(3, 2))

p1<-ggplot(new_df, aes(x = value))+
  geom_histogram(aes(color = variable, fill = variable),
                 alpha = 0.3, position = "dodge", binwidth = 2)+
  labs(x="Custo Normalizado", y="Frequência")+
  #coord_cartesian(ylim=c(1,20), xlim=c(1,30))+
  theme(legend.justification=c(1, 1),legend.position=c(.9, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  scale_x_continuous(breaks = seq(1, 97, 4))+
  ggtitle('a) Melhor Custo Encontrado')

p2<-ggplot(new_df, aes(x = value))+
  geom_histogram(aes(color = variable, fill = variable),
                 alpha = 0.3, position = "dodge", binwidth = 2)+
  labs(x="Custo Normalizado", y="Frequência")+
  coord_cartesian(ylim=c(1,20), xlim=c(1,30))+
  theme(legend.justification=c(1, 1),legend.position=c(.9, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  scale_x_continuous(breaks = seq(1, 97, 4))+
  ggtitle('b) Zoom da Figura a')

tikz('hist.tex')
grid.arrange(p1, p2, nrow = 2, ncol=1, top="", left="Frequência")
dev.off()






library("ggpubr")

ggline(new_df, x = "variable", y = "value", 
       add = c("mean_se", "jitter"), 
       order = c("ctrl", "trt1", "trt2"),
       ylab = "Weight", xlab = "Treatment")

p0 <-ggplot(new_df, aes(x = value, y= variable, color = variable, fill = variable))+
  geom_boxplot(alpha=0.7, colour = "black")+
  stat_summary(fun.y=mean, geom="point", shape=20, size=2, color="red", fill="red") +
  theme(legend.position="none")+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  labs(color = element_blank(), x="Custo Normalizado", y="Frequência")

ylim1<- c(1, 2)
p0 + coord_cartesian(xlim = ylim1)










View(new_df)
View(df)



friedman.test(value ~ variable | ID, data = new_df)

frdAllPairsSiegelTest(new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")
frdAllPairsConoverTest(new_df$value, new_df$variable, new_df$ID, p.adjust = "bonferroni")
frdAllPairsNemenyiTest(new_df$value, new_df$variable, new_df$ID, p.adjust = "bonferroni")


new_df
colnames(new_df) <- c("ID", "Abordagem", "Best")
new_df %>% group_by(Abordagem) %>%
  get_summary_stats(Best, type = "median_iqr")
new_df
