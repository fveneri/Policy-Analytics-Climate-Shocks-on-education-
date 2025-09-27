## File:01_ingest_clean_BR
## Objective: 
## Ingest data and save it to Data_Raw
# Note: 
# -IF   data is available on a repo/package
#      it was used to make the project more consise.
# - IF the data is available in a website, but no API is avalible,
#      the raw data is donwloadad to ensure reproducibility (ie. Folks taking data out of website)
#       




#Outcomes: 
## Education in brasil databases
#https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados

#source: SAEB individual education level outcomes.
#Ref: https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/saeb
## This files are 600mb each
Download_files_2_Raw(URL="https://download.inep.gov.br/microdados/microdados_saeb_2023.zip",
                     dir="Data_raw/SAEB")
Download_files_2_Raw(URL="https://download.inep.gov.br/microdados/microdados_saeb_2021_ensino_fundamental_e_medio.zip",
                     dir="Data_raw/SAEB")

Download_files_2_Raw(URL="https://download.inep.gov.br/microdados/microdados_saeb_2017.zip",
                     dir="Data_raw/SAEB")

Download_files_2_Raw(URL="https://download.inep.gov.br/microdados/microdados_saeb_2019.zip",
                     dir="Data_raw/SAEB")

# Download_files_2_Raw(URL="https://download.inep.gov.br/microdados/microdados_saeb_2015.zip",
#                      dir="Data_raw/SAEB")


##