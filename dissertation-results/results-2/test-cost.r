setwd('/home/pc-752828/Dev/results-search-master/outputs-normal')

library(reshape2)
library(nortest)

data_norm <- read.csv(file = 'output-n-price.csv', sep = ',', header = T)

get_df <- function(seed, data) {
  my_ite <- 10
  bo1 <- list()
  bo2 <- list()
  bo3 <- list()
  bo4 <- list()
  rs <- list()
  app <- list()
  seed_l <- list()
  
  for(i in levels(factor(data$name))) {
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
    seed_l <- append(seed_l, seed)
  }
  
  df <- cbind(bo1, bo2, bo3, bo4, rs, app)
  df <- data.frame(df)
  df$bo1 = as.numeric(as.character(df$bo1))
  df$bo2 = as.numeric(as.character(df$bo2))
  df$bo3 = as.numeric(as.character(df$bo3))
  df$bo4 = as.numeric(as.character(df$bo4))
  df$rs = as.numeric(as.character(df$rs))
  
  return(df)
}

get_effect_size <- function(df) {
  cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search", "ID")
  colnames(df) <- cols
  df$ID = as.character(df$ID)
  df$ID <- factor(df$ID)
  new_df <- melt(df, id = c("ID"), measured = cols)
  new_df %>% wilcox_effsize(value ~ variable, paired = TRUE)
}

get_wilco <- function(df) {
  cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search", "ID")
  colnames(df) <- cols
  df$ID = as.character(df$ID)
  df$ID <- factor(df$ID)
  new_df <- melt(df, id = c("ID"), measured = cols)
  pairwise.wilcox.test(new_df$value, new_df$variable, p.adjust = "bonferroni", paired = TRUE, exact = F)
}
  

df_1 <- get_df(1, data_norm)
df_2 <- get_df(2, data_norm)
df_3 <- get_df(3, data_norm)
df_4 <- get_df(4, data_norm)
df_5 <- get_df(5, data_norm)

get_effect_size(df_1)
get_effect_size(df_2)
get_effect_size(df_3)
get_effect_size(df_4)
get_effect_size(df_5)

get_wilco(df_1)
get_wilco(df_2)
get_wilco(df_3)
get_wilco(df_4)
get_wilco(df_5)

df_norm <- rbind(df_1, df_2, df_3, df_4, df_5)
df <- df_norm
df <- df_3

cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search", "ID")
colnames(df) <- cols
df$ID = as.character(df$ID)
df$ID <- factor(df$ID)
new_df <- melt(df, id = c("ID"), measured = cols)

glimpse(df)
friedman.test(value ~ variable | ID, data = new_df)
colnames(new_df) <- c("ID", "Abordagem", "Best")

wilcox.test(df$`BO-6rnd-EIdef`, df$`BO-6rnd-EInova`, paired = TRUE, alternative = "greater")

new_df %>% wilcox_effsize(value ~ variable, paired = TRUE)
pairwise.wilcox.test(new_df$value, new_df$variable, p.adjust = "bonferroni", paired = TRUE, exact = F)

cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search", "ID")
colnames(df) <- cols
df$ID = as.character(df$ID)
df$ID <- factor(df$ID)
cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search")
new_df <- melt(df, id = c("ID"), measured = cols)
glimpse(df)
friedman.test(value ~ variable | ID, data = new_df)
colnames(new_df) <- c("ID", "Abordagem", "Best")

shapiro.test(df$bo1)

new_df %>% group_by(Abordagem) %>%
  print(Best)

ad.test(df$rs)
new_df

new_df %>% group_by(Abordagem) %>%
  shapiro.test(Best)

new_df %>% friedman_effsize(value ~ variable | ID)
new_df %>% wilcox_effsize(value ~ variable, paired = TRUE)

new_df %>% group_by(Abordagem) %>%
  get_summary_stats(Best, type = "median_iqr")

new_df %>% group_by(Abordagem) %>%
  get_summary_stats(Best, type = "median_iqr")



frdAllPairsSiegelTest (new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")
frdAllPairsConoverTest(new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")
frdAllPairsNemenyiTest(new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")

library(WebPower)
library(pwr)
library(wmwpow)

pwr.anova.test(k = NULL, n = 38, f = 0.311, sig.level = 0.05, power = NULL)
wp.rmanova(n = NULL, ng = 1, nm = 5, f = .3, alpha = 0.05, power = .8, type = 0)
wp.rmanova(n=30, ng=1, nm=5, f=0.36, nscor=0.7)
wmwpowd(n=38, m=38, distn="norm", distm="norm", sides="greater", alpha = 0.05, nsims = 10000)
shiehpow(n = 38, m = 38, p=.5, alpha = .05, sides="one.sided")
wmwpowp(38, 38, "norm", k = 1, p = NA, wmwodds = .5, sides="greater", alpha = 0.05, nsims = 10000)
