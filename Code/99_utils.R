## File:099_utils_BR
## Objective: 
## Ingest data and save it to Data_Raw

## Libraries
library(tidyverse)
library(sidrar)
library(chirps)
library(zip)
library(rnaturalearth)
library(sf)
library(curl)
library(readxl)
library(microdatasus)
library(fixest)
library(modelsummary)  
library(tmap)


## Download tools TOOLS
## function: Download_files_2_Raw
## Objectives: download zio from URL. Some trial and error, results in small modifications.
# Educ
Download_RAW_files=function(URL="TEXT",dir="Data_raw"){
  # Had 2 Increase time outs to donwload data, directly. 
  options(timeout = max(1200, getOption("timeout")))  
  File_2_check <- basename(URL)
  # check and create directory
  if (!dir.exists(dir)){ 
    dir.create(dir, recursive = TRUE)}
  # check and download
  ziped <- file.path(dir, File_2_check)
  if (!file.exists(ziped)){
    message("Downloadig:",File_2_check)
    download.file(URL, ziped, mode = "wb")
    # unzip(zipfile)
  }else {message("File already donwloaded")}
  
}
Download_SAEB_files=function(URL="TEXT",dir="Data_raw/SAEB"){
  # Had 2 Increase time outs to donwload data, directly. 
  options(timeout = max(1200, getOption("timeout")))  
  File_2_check <- basename(URL)
  # check and create directory
  if (!dir.exists(dir)){ 
    dir.create(dir, recursive = TRUE)}
  # check and download
  ziped <- file.path(dir, File_2_check)
  if (!file.exists(ziped)){
    message("Downloadig:",File_2_check)
    download.file(URL, ziped, mode = "wb")
    # unzip(zipfile)
  }else {message("File already donwloaded")}
  
}
Download_SAEB_tabela_Compliled=function(URL="TEXT",dir="Data_raw/SAEB_table"){
  # Had 2 Increase time outs to donwload data, directly. 
  options(timeout = max(1200, getOption("timeout")))  
  File_2_check <- basename(URL)
  # check and create directory
  if (!dir.exists(dir)){ 
    dir.create(dir, recursive = TRUE)}
  # check and download
  ziped <- file.path(dir, File_2_check)
  if (!file.exists(ziped)){
    message("Downloadig:",File_2_check)
    download.file(URL, ziped, mode = "wb",method = "curl")
    # unzip(zipfile)
  }else {message("File already donwloaded")}
  
}
# Health
Download_SIM_files=function(Year,Source="SIM-DO",dir="Data_raw/DATASUS_SIM"){
  # Had 2 Increase time outs to donwload data, directly. 
  options(timeout = max(2400, getOption("timeout")))  
  if (!dir.exists(dir)){ 
    dir.create(dir, recursive = TRUE)}
   File_out=paste(dir,paste(Source,Year,sep = "-"),sep = "/")
   if (!file.exists(File_out)){
     message("Downloadig:",File_out)
    sim_data <- fetch_datasus(
    year_start = Year,
    year_end   = Year,
    uf         = "all",   #
    information_system = "SIM-DO",stop_on_error = T)
sim_data_clean <- process_sim(sim_data)
    
saveRDS(object = sim_data,file =paste(File_out,".rds",sep ="" )    
)}else {message("File already donwloaded")}
}
Download_SIH_files=function(Year,Source="SIH-RD",dir="Data_raw/DATASUS_SIH"){
  # Had 2 Increase time outs to donwload data, directly. 
  options(timeout = max(2400, getOption("timeout")))  
  if (!dir.exists(dir)){ 
    dir.create(dir, recursive = TRUE)}

  for (mm in 1:12) {
    
  File_out=paste(dir,paste(Source,Year,"m",mm,sep = "-"),sep = "/")
  if (!file.exists(File_out)){
    message("Downloadig:",File_out)
    data <- fetch_datasus(
      year_start = Year,
      month_start = mm,
      month_end = mm,
      year_end   = Year,
      uf         = "all",   #
      information_system = "SIH-RD",stop_on_error = F)
    data_clean <- process_sinasc(sim_data)
    
    saveRDS(object = sim_data,file =paste(File_out,".rds",sep ="" )    
    )}else {message("File already donwloaded")}
  
  }
}
Download_CNES_files=function(Year,Source="CNES-ST",dir="Data_raw/DATASUS_SIH"){
  # Had 2 Increase time outs to donwload data, directly. 
  options(timeout = max(2400, getOption("timeout")))  
  if (!dir.exists(dir)){ 
    dir.create(dir, recursive = TRUE)}

  for (mm in 1:12) {  
  
File_out=paste(dir,paste(Source,Year,"m",mm,sep = "-"),sep = "/")
    
  if (!file.exists(File_out)){
    message("Downloadig:",File_out)
    data <- fetch_datasus(
      year_start = Year,
      month_start = mm,
      month_end = mm,
      year_end   = Year,
      uf         = "all",   #
      information_system = "CNES-ST",stop_on_error = F)
    data_clean <- process_cnes(sim_data, information_system = "CNES-ST")
    
    saveRDS(object = sim_data,file =paste(File_out,".rds",sep ="" )    
    )}else {message("File already donwloaded")}
}
  }
Download_health_facility_files=function(Source="CADASTRO-CNES",
                                        dir="Data_raw/CADASTRO_CNES"){
  require(geobr)
  # Had 2 Increase time outs to donwload data, directly. 
  options(timeout = max(2400, getOption("timeout")))  
  if (!dir.exists(dir)){ 
    dir.create(dir, recursive = TRUE)}
  

  File_out=paste(dir,paste(Source,sep = "-"),sep = "/")
    
    if (!file.exists(File_out)){
      message("Downloadig:",File_out)
      data=read_health_facilities(date = 202303, showProgress = TRUE, cache = TRUE)
      
      # data <- fetch_datasus(
      #   year_start = Year,
      #   month_start = mm,
      #   month_end = mm,
      #   year_end   = Year,
      #   uf         = "all",   #
      #   information_system = "CNES-ST",stop_on_error = F)
      # data_clean <- process_cnes(sim_data, information_system = "CNES-ST")
      # 
      saveRDS(object = data,file =paste(File_out,".rds",sep ="" )    
      )}else {message("File already donwloaded")}
}
# Climate data.
Download_PARQUET_files=function(URL="TEXT",FILE="total_precipitation_sum.parquet",dir="Data_raw/Climate"){
  require(httr)
  require(arrow)
  # Had 2 Increase time outs to donwload data, directly. 
  options(timeout = max(2400, getOption("timeout")))  
  File_2_check <- FILE
  # check and create directory
  if (!dir.exists(dir)){ 
    dir.create(dir, recursive = TRUE)}
  # check and download
  ziped <- file.path(dir, File_2_check)
  if (!file.exists(ziped)){
    message("Downloadig:",File_2_check)
  # resp <- httr::GET(URL, httr::write_disk(ziped, overwrite = TRUE), httr::progress())    
    curl_download(URL, ziped, mode = "wb")
  }else {message("File already donwloaded")}
  
}

## Climate map maker
Climate_maps <- function(Year_reference,Extreme_day2_Table=Extreme_day2_Table,Municipios=Municipios) {
  Extreme_day2_Table$Year_ref=Year_reference
  Extreme_day2_Table=Extreme_day2_Table |> dplyr::filter(Year==Year_ref)
  Municipios=Municipios|>
    left_join(Extreme_day2_Table)
  
  Muni_map_2sd=tm_shape(Municipios) +
    tm_polygons("Shock_Weather_2sd",
                palette = c("white", "darkred"),
                title = paste("Rainfall Shock (2sd) in",Year_reference,sep=""),
                labels = c("No shock", "Shock")) +
    tm_layout(frame = FALSE, legend.outside = TRUE)
  return(Muni_map_2sd)
}


