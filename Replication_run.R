## Replicate run

## Create directory stucture required
if (!dir.exists("outputs/figures")){ 
  dir.create(dir, recursive = TRUE)}

if (!dir.exists("outputs/tables")){ 
  dir.create(dir, recursive = TRUE)}

if (!dir.exists("outputs/data_processed")){ 
  dir.create(dir, recursive = TRUE)}

source(file = "Code/99_utils.R")
# source(file = "Code/01_ingest_clean_BR.R")
source(file = "Code/02_feature_engineering_BR.R")
source(file = "Code/03_feature_engineering_BR.R")
source(file = "Code/04_Visuals_BR.R")
