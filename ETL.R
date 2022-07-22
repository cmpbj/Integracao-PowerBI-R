# Carregando os pacotes

library(tidyverse)
library(tidyr)
library(janitor)
library(lubridate)
library(ggplot2)
library(dplyr)
library(RColorBrewer)
library(stringr)


# Extraindo os dados

tabela1 <- "https://www.gov.br/anp/pt-br/centrais-de-conteudo/dados-abertos/arquivos/shpc/dsan/2022/precos-gasolina-etanol-01.csv"
tabela2 <- "https://www.gov.br/anp/pt-br/centrais-de-conteudo/dados-abertos/arquivos/shpc/dsan/2022/precos-gasolina-etanol-02.csv"
tabela3 <- "https://www.gov.br/anp/pt-br/centrais-de-conteudo/dados-abertos/arquivos/shpc/dsan/2022/precos-gasolina-etanol-03.csv"
tabela4 <- "https://www.gov.br/anp/pt-br/centrais-de-conteudo/dados-abertos/arquivos/shpc/dsan/2022/precos-gasolina-etanol-04.csv"
tabela5 <- "https://www.gov.br/anp/pt-br/centrais-de-conteudo/dados-abertos/arquivos/shpc/dsan/2022/precos-gasolina-etanol-05.csv"

path1 <- "C://Users//MicrosofPowerBI-DSA//cap12//precos-gasolina-etanol-01.csv"
path2 <- "C://Users//MicrosofPowerBI-DSA//cap12//precos-gasolina-etanol-02.csv"
path3 <- "C://Users//MicrosofPowerBI-DSA//cap12//precos-gasolina-etanol-03.csv"
path4 <- "C://Users//MicrosofPowerBI-DSA//cap12//precos-gasolina-etanol-04.csv"
path5 <- "C://Users//MicrosofPowerBI-DSA//cap12//precos-gasolina-etanol-05.csv"

download.file(tabela1, path1)
download.file(tabela2, path2)
download.file(tabela3, path3)
download.file(tabela4, path4)
download.file(tabela5, path5)

# Carregando as tabelas

df1 <- read.csv("precos-gasolina-etanol-01.csv", sep = ";", dec = ",", na = "")
df2 <- read.csv("precos-gasolina-etanol-02.csv", sep = ";", dec = ",", na = "")
df3 <- read.csv("precos-gasolina-etanol-03.csv", sep = ";", dec = ",", na = "")
df4 <- read.csv("precos-gasolina-etanol-04.csv", sep = ";", dec = ",", na = "")
df5 <- read.csv("precos-gasolina-etanol-05.csv", sep = ";", dec = ",", na = "")

# Concatenando os dataframes. A base de dados completa vai conter dados de janeiro a maio de 2022

dataset <- rbind(df1, df2, df3, df4, df5)


# Exploração inicial

View(dataset)
str(dataset)
summary(dataset$Valor.de.Venda)
summary(dataset$Valor.de.Compra)
sapply(dataset, function(x) sum(is.na(x)))

# Verificando os nomes das colunas 

colnames(dataset)

# Vamos fazer uma limpeza no nome das colunas

dataset <- clean_names(dataset)
colnames(dataset)

# Selecionando as colunas de interesse

dataset <- select(dataset, data_da_coleta, regiao_sigla, estado_sigla, municipio, revenda, bandeira, produto,
             valor_de_venda)

# Verificando os valores únicos das colunas categóricas para ver se há alguma inconsistência

unique(dataset$data_da_coleta)
unique(dataset$regiao_sigla)
unique(dataset$estado_sigla)
unique(dataset$municipio)
unique(dataset$revenda)
unique(dataset$bandeira)
unique(dataset$produto)

# Vamos transformar os valores de algumas colunas em minúsculo. Isso é importante
# porque textos com letras maiúsculas ou minúsculas são tratados como diferentes

dataset$municipio <- str_to_title(dataset$municipio)
dataset$revenda <- str_to_title(dataset$revenda)
dataset$bandeira <- str_to_title(dataset$bandeira)
dataset$produto <- str_to_title(dataset$produto)

# Vamos remover os acentos pelo mesmo motivo citado acima
# A fonte da função utilizada abaixo foi: 
# https://www.ufrgs.br/wiki-r/index.php?title=Normalizando_strings


RemoveAcentos <- function(textoComAcentos) {
  
  # Se nao foi informado texto
  if(!is.character(textoComAcentos)){
    on.exit()
  }
  
  # Letras com acentos
  letrasComAcentos <- "áéíóúÁÉÍÓÚýÝàèìòùÀÈÌÒÙâêîôûÂÊÎÔÛãõÃÕñÑäëïöüÄËÏÖÜÿçÇ´`^~¨"
  
  # Letras equivalentes sem acentos
  letrasSemAcentos <- "aeiouAEIOUyYaeiouAEIOUaeiouAEIOUaoAOnNaeiouAEIOUycC     "
  
  textoSemAcentos <- chartr(
    old = letrasComAcentos,
    new = letrasSemAcentos,
    x = textoComAcentos
  ) 
  
  # Retorno da funcao
  return(textoSemAcentos)
}

dataset <- dataset %>%
  mutate_if(is.character, RemoveAcentos)


# Alterando as siglas das regiões pela palavra correspondente

dataset$regiao_sigla[dataset$regiao_sigla == "N"] <- "Norte"
dataset$regiao_sigla[dataset$regiao_sigla == "NE"] <- "Nordeste"
dataset$regiao_sigla[dataset$regiao_sigla == "SE"] <- "Sudeste"
dataset$regiao_sigla[dataset$regiao_sigla == "CO"] <- "Centro-Oeste"
dataset$regiao_sigla[dataset$regiao_sigla == "S"] <- "Sul"


# Alguma das limitações do uso da Linguagem R no Power BI estão 
# relacionadas ao tamanho dos dados. O Power BI suporta 150 mil linhas,
# sendo que a base de dados que estamos trabalhando tem mais de 200 mil linhas.
# Pensando nisso, vamos agrupar os dados pelo mês do registro para diminuir a quantidade de linhas.

dataset$data_da_coleta <- dmy(dataset$data_da_coleta)

dataset$data_da_coleta <- format(dataset$data_da_coleta, "%m-%Y")

dataset <- summarize(group_by(dataset, data_da_coleta, regiao_sigla,
                              estado_sigla, municipio, revenda,
                              bandeira, produto),
                     valor_de_venda = mean(valor_de_venda))


# Persistindo o arquivo 

write_delim(dataset, file = "preco_combustivel_2022.csv", delim = ";")






