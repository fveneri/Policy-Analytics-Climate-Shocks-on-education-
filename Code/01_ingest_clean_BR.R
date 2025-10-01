## File:01_ingest_clean_BR
## Objective: 
## Ingest data and save it to Data_Raw
# Note: 
# -IF   data is available on a repo/package
#      it was used to make the project shorter/doable by the deadline.
# - IF the data is available in a website, but no API is available,
#      the raw data is downloaded to ensure reproducibility (ie. downloading a copy)
# 
# Initial cleaning and simplification is performed at this steps and output saved to data raw as rds.


## Read the coding utils
source(file = "Code/99_utils.R")


## Geo units
Download_RAW_files(URL ="https://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2023/Brasil/BR_Municipios_2023.zip",
                   dir ="Data_raw/Shape" )
zip::unzip(zipfile = "Data_raw/Shape/BR_Municipios_2023.zip",
           exdir = "Data_raw/Shape/BR_Municipios")


### The following code is commented out, it requires a stable connection.
### Left for future use.

#### OUTCOMES:Microdata Health####
## Focus on mortality using SIM DATA (Mortality).
## This downloads the file 1:1 and save a clean version of the raw data as RDS
# year=2015:2019
# lapply(year, Download_SIM_files)
# 
# year=2016:2019
# lapply(year, Download_SIH_files)
# year=2015:2019
# lapply(year, Download_CNES_files)
# 
# ## Download Health Center information
# Download_health_facility_files()


#### OUTCOMES:Education####
#Commented out for size, microdatat is 600-700mb per year.
## This is individual level data
#Ref: https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/saeb
# Download_files(URL="https://download.inep.gov.br/microdados/microdados_saeb_2023.zip",
#                      dir="Data_raw/SAEB")
# Download_files_2_Raw(URL="https://download.inep.gov.br/microdados/microdados_saeb_2021_ensino_fundamental_e_medio.zip",
#                      dir="Data_raw/SAEB")
# 
# Download_files_2_Raw(URL="https://download.inep.gov.br/microdados/microdados_saeb_2017.zip",
#                      dir="Data_raw/SAEB")
# Download_files_2_Raw(URL="https://download.inep.gov.br/microdados/microdados_saeb_2019.zip",
#                      dir="Data_raw/SAEB")

# Download_SAEB_tabela_Compliled(URL ="https://download.inep.gov.br/microdados/planilhas_de_resultados_20250507.zip")
# zip::unzip(zipfile = "Data_raw/SAEB_table/planilhas_de_resultados_20250507.zip",
#            exdir = "Data_raw/SAEB_table/2025") ## the data is from-2023 actually
# Download_SAEB_tabela_Compliled(URL ="https://download.inep.gov.br/saeb/resultados/saeb_2021_brasil_estados_municipios.xlsx")
# Download_SAEB_tabela_Compliled(URL ="https://download.inep.gov.br/educacao_basica/saeb/2019/resultados/Resultados_Saeb_2019_Brasil_Estados_Municipios.xlsx")
# Download_SAEB_tabela_Compliled(URL ="https://download.inep.gov.br/educacao_basica/saeb/2019/resultados/Resultados_Saeb_2017_Brasil_Estados_Municipios.zip")
# Download_SAEB_tabela_Compliled(URL ="https://download.inep.gov.br/microdados/planilhas_de_resultados_20250507.zip")
# zip::unzip(zipfile = "Data_raw/SAEB_table/Resultados_Saeb_2017_Brasil_Estados_Municipios.zip",
#            exdir = "Data_raw/SAEB_table/2017")
# Download_SAEB_tabela_Compliled(URL ="https://download.inep.gov.br/educacao_basica/saeb/aneb_anresc/resultados/resultados_municipais_saeb_2015.xls")
# Download_SAEB_tabela_Compliled(URL ="https://download.inep.gov.br/educacao_basica/saeb/2013/resultado/resultados_saeb_2013_brasil_estados_municipios.xlsx")
# Download_SAEB_tabela_Compliled(URL ="https://download.inep.gov.br/educacao_basica/saeb/2011/resultado/resultados_saeb_2011_brasil_estados_municipios.xlsx")
# Download_SAEB_tabela_Compliled(URL ="https://download.inep.gov.br/educacao_basica/saeb/2009/resultado/resultados_saeb_2009_brasil__regioes_estados_municipios.xlsx")
# Download_SAEB_tabela_Compliled(URL ="https://download.inep.gov.br/educacao_basica/saeb/2007/resultado/resultados_saeb_2007_brasil_estados_municipios.xlsx")

## Clean, filter and save Tabelas as RDS
# SAEB_MUNICIPAL=bind_rows(
#   readxl::read_excel(path = "Data_raw/SAEB_table/2025/PLANILHAS DE RESULTADOS_20250507/TS_MUNICIPIO_20250507.xlsx")|>
#     filter(DEPENDENCIA_ADM=="Total - Federal, Estadual e Municipal" & LOCALIZACAO=="Total") |> mutate(YEAR=2023) |>
#     select(YEAR,NO_UF,NO_MUNICIPIO,CO_MUNICIPIO,MEDIA_9_LP,MEDIA_9_MT) |> mutate(CO_MUNICIPIO=as.numeric(CO_MUNICIPIO),
#                                                                                  MEDIA_9_LP=as.numeric(MEDIA_9_LP),
#                                                                                  MEDIA_9_MT=as.numeric(MEDIA_9_MT)),
#   
#   readxl::read_excel(path = "Data_raw/SAEB_table/saeb_2021_brasil_estados_municipios.xlsx",sheet = "Municípios")|>
#     filter(DEPENDENCIA_ADM=="Total - Federal, Estadual e Municipal" & LOCALIZACAO=="Total") |> mutate(YEAR=2021) |>
#     select(YEAR,NO_UF,NO_MUNICIPIO,CO_MUNICIPIO,MEDIA_9_LP,MEDIA_9_MT)|> mutate(CO_MUNICIPIO=as.numeric(CO_MUNICIPIO),
#                                                                                 MEDIA_9_LP=as.numeric(MEDIA_9_LP),
#                                                                                 MEDIA_9_MT=as.numeric(MEDIA_9_MT)),
#   
#   readxl::read_excel(path = "Data_raw/SAEB_table/Resultados_Saeb_2019_Brasil_Estados_Municipios.xlsx",sheet = "Municípios")|>
#     filter(DEPENDENCIA_ADM=="Total - Federal, Estadual e Municipal" & LOCALIZACAO=="Total") |> mutate(YEAR=2019) |>
#     select(YEAR,NO_UF,NO_MUNICIPIO,CO_MUNICIPIO,MEDIA_9_LP,MEDIA_9_MT)|> mutate(CO_MUNICIPIO=as.numeric(CO_MUNICIPIO),
#                                                                                 MEDIA_9_LP=as.numeric(MEDIA_9_LP),
#                                                                                 MEDIA_9_MT=as.numeric(MEDIA_9_MT)),
#   
#   readxl::read_excel(path = "Data_raw/SAEB_table/2017/TS_MUNICIPIO.xlsx")|>
#     filter(DEPENDENCIA_ADM=="Total - Federal, Estadual e Municipal" & LOCALIZACAO=="Total") |> mutate(YEAR=2017) |>
#     select(YEAR,NO_UF,NO_MUNICIPIO,CO_MUNICIPIO,MEDIA_9_LP,MEDIA_9_MT)|> mutate(CO_MUNICIPIO=as.numeric(CO_MUNICIPIO),
#                                                                                 MEDIA_9_LP=as.numeric(MEDIA_9_LP),
#                                                                                 MEDIA_9_MT=as.numeric(MEDIA_9_MT)))
# 
# 
# saveRDS(object = SAEB_MUNICIPAL,"Data_raw/SAEB_table/SAEB_MUNICIPAL")


#### OUTCOMES:Education Panel####
## The following steps download the formated panel

Download_SAEB_tabela_Compliled(URL ="https://download.inep.gov.br/ideb/resultados/divulgacao_anos_finais_escolas_2023.zip")
zip::unzip(zipfile = "Data_raw/SAEB_table/divulgacao_anos_finais_escolas_2023.zip",
           exdir = "Data_raw/SAEB_table/Full_Panel_SAEB_Escolas")

Download_SAEB_tabela_Compliled(URL ="https://download.inep.gov.br/ideb/resultados/divulgacao_anos_finais_municipios_2023.zip")
zip::unzip(zipfile = "Data_raw/SAEB_table/divulgacao_anos_finais_municipios_2023.zip",
           exdir = "Data_raw/SAEB_table/Full_Panel_SAEB_MUNI")


data_PANEL=readxl::read_excel(path = "Data_raw/SAEB_table/Full_Panel_SAEB_MUNI/divulgacao_anos_finais_municipios_2023/divulgacao_anos_finais_municipios_2023.xlsx",
                              # sheet = "IDEB_Escolas (Anos_Finais)",
                              skip=10,col_names = F)

data_PANEL=data_PANEL |>filter(...4=="Pública")

headers <- read_excel("Data_raw/SAEB_table/Full_Panel_SAEB_MUNI/divulgacao_anos_finais_municipios_2023/divulgacao_anos_finais_municipios_2023.xlsx", range = "A7:DH10", col_names = FALSE)
headers[,c(2,3)]

Cols=c(2,3,9,15,21,27,33,39,45,51,57,63,65,66,68,69,71,72,74,75,77,78,80,81,83,84,86,87,90,91,92,93)
headers[,Cols]
data_PANEL_clean=data_PANEL[,Cols]

names(data_PANEL_clean)=c("CO_MUNICIPIO","NO_MUNICIPIO",
                          "TA9_2005","TA9_2007","TA9_2009",
                          "TA9_2011","TA9_2013","TA9_2015",
                          "TA9_2017","TA9_2019","TA9_2021","TA9_2023",
                          "SAEBMT_2005","SAEBLP_2005",
                          "SAEBMT_2007","SAEBLP_2007",
                          "SAEBMT_2009","SAEBLP_2009",
                          "SAEBMT_2011","SAEBLP_2011",
                          "SAEBMT_2013","SAEBLP_2013",
                          "SAEBMT_2015","SAEBLP_2015",
                          "SAEBMT_2017","SAEBLP_2017",
                          "SAEBMT_2019","SAEBLP_2019",
                          "SAEBMT_2021","SAEBLP_2021",
                          "SAEBMT_2023","SAEBLP_2023"
)

saveRDS(data_PANEL_clean,"Data_raw/SAEB_table/data_PANEL_clean.RDS")

#### Climate data####
## The following link download the dataset in a parquet file. It requires a stable conection.
## Weather
Download_PARQUET_files(URL ="https://zenodo.org/records/10036212/files/total_precipitation_sum.parquet?download=1",FILE="total_precipitation_sum.parquet")

Precipitation=read_parquet(file = "Data_raw/Climate/total_precipitation_sum.parquet")
Precipitation=Precipitation|> filter(date >= date("1980-01-01"))
gc()

Precipitation=Precipitation|> mutate(Year=lubridate::year(date),
                                     Month=lubridate::month(date))
# Create monthly data
Precipitation_month=Precipitation |> group_by(code_muni,Year,Month) |>
  reframe(value=sum(value,na.rm = T))

saveRDS(object = Precipitation_month,file = "Data_raw/Climate/Precipitation_month.rds")

#### Control: Municipality level data ####
library(sidrar)
# Pob_2022 <- get_sidra(x = 6579,geo = "City",period ="202")
Pob_2021 <- get_sidra(x = 6579,geo = "City",period ="2021")
saveRDS(Pob_2021,file = "Data_raw/Pob_2021.rds")
## Save the data as RDS