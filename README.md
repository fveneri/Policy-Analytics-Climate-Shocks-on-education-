# Policy-Analytics-Climate
This repo contains the replication package for a policy analytics on climate challenges and development outcomes project. The repo provides the code used and clean versions of the data used as RDS for replication purposes. The raw data is available upon request or found in the files described in the data sources section or in [data links](./Data_links/):

## The following data is made available
- [Data Clean](./Data_raw/): Provides the clean version of the data used for this project. 
    - SAEB Municipality-level educational outcomes: Standardized tests in Math and Language.
    - Municipality-level monthly precipitation: Aggregated rainfall for 1980-2022.
    - Municipal shapefiles
    - Population for 2022
       
- [Panel data](./data_processed/): Provides a balanced panel of municipalities, with educational outcomes and yearly information on climate shocks.

- Due to logistical limitations, full raw data is available upon request or can be accessed from the links in the data section.


## Results: 
Results are presented as slides in  [Slide](./docs/):

## Code 
There are 4 main R scripts to reproduce the results in  [Code](./Code/)
    -[Ingest](./Code/01_ingest_clean_BR.R): performs the initial data ingestion and initial data cleaning, results are saved on [Data_raw](./Data_raw/).
        Simplified files are saved as RDS to allow replication of the code.
   - [Feature Engineering](./Code/02_feature_engineering.R): performs feature engineering and prepares a balanced panel with educational outcomes at the municipality level and indicators for climate shock events during the school year.
   - [Modeling](./Code/03_modeling_BR.R): Produce estimates to quantify the relationship between rainfall shocks and educational outcomes.
   - [Visual](./Code/04_Visuals_BR.R): Produce visualitations used on the slides.
   - [Utils](./Code/99_utils_BR.R): Loads the libraries used and utility functions.

## Data Sources: 
Additional information is presented on the slides.
 - [INEP-SAEB](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados)
 - [IBGE-shapefiles](https://www.ibge.gov.br/en/geosciences/territorial-organization/territorial-meshes/18890-municipal-mesh.html)
 - [Zonal Statistics of Weather Indicators for Brazilian Municipalities](https://zenodo.org/records/13906834). Available under Creative Commons attribution 4

## Replication. 
Analysis was performed using R (4.0).
The main libraries required are presented at the start of the utils script. The first lines check if the libraries are available and can be uploaded. 
   tidyverse: 2.0.0        
   sidrar: 0.2.9        
   chirps: 0.1.4
   zip: 2.2.3
   rnaturalearth: 1.0.1
   sf: 1.0.19
   curl: 6.3.0
   readx: 1.4.3
   microdatasus: 2.4.3
   fixest: 0.12.1
   modelsummary: 2.50
   tmap: 4.0
   httr: 1.4.7
   arrow: 17.0.0.1
   geobr: 1.9.1
