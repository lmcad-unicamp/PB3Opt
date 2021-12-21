setwd('/home/pc-752828/Dev/results-search-master/outputs-ecp')

library(reshape2)
library(nortest)
library(coin)
library(reshape)

data_norm <- read.csv(file = 'output-ecp-norm.csv', sep = ',', header = T)
data_price <- read.csv(file = 'output-ecp-norm-cost.csv', sep = ',', header = T)


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
  cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova", "PB3Opt", "Ranking Search", "ID")
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
  pairwise.wilcox.test(new_df$value, new_df$variable, p.adjust = "bonferroni", paired = TRUE, exact = F, alt = 'two.sided')
}

get_normal <- function(df) {
  print("####################################################################")
  print(ad.test(df$rs))
  print(ad.test(df$bo1))
  print(ad.test(df$bo2))
  print(ad.test(df$bo3))
  print(ad.test(df$bo4))
  print("####################################################################3")
}


df_1 <- get_df(1, data_norm)
df_2 <- get_df(2, data_norm)
df_3 <- get_df(3, data_norm)
df_4 <- get_df(4, data_norm)
df_5 <- get_df(5, data_norm)

get_normal(df_1)
get_normal(df_2)
get_normal(df_3)
get_normal(df_4)
get_normal(df_5)

get_wilco(df_1)
get_wilco(df_2)
get_wilco(df_3)
get_wilco(df_4)
get_wilco(df_5)

get_effect_size(df_1)
get_effect_size(df_2)
get_effect_size(df_3)
get_effect_size(df_4)
get_effect_size(df_5)

df_1 <- get_df(1, data_price)
df_2 <- get_df(2, data_price)
df_3 <- get_df(3, data_price)
df_4 <- get_df(4, data_price)
df_5 <- get_df(5, data_price)

get_normal(df_1)
get_normal(df_2)
get_normal(df_3)
get_normal(df_4)
get_normal(df_5)

get_wilco(df_1)
get_wilco(df_2)
get_wilco(df_3)
get_wilco(df_4)
get_wilco(df_5)

get_effect_size(df_1)
get_effect_size(df_2)
get_effect_size(df_3)
get_effect_size(df_4)
get_effect_size(df_5)
