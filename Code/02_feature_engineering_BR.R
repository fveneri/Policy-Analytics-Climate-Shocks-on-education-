## File:02_feature_engineering_BR
## Objective: 
## Read data, perform feature engineering and return a formatted panel to run models. 
## Panel structure Year X Municipalit: Variable, climate shocks (rainfall)

source(file = "Code/99_utils.R")
SAEB_MUNICIPAL_PANEL=readRDS(file = "Data_raw/SAEB_table/data_PANEL_clean.RDS")


## Feature for educational outcome:
SAEB_MUNICIPAL_PANEL=SAEB_MUNICIPAL_PANEL |> pivot_longer(cols = 3:32,names_to = "Varia_Year") |>
  separate(Varia_Year, into = c("VAR", "YEAR"), sep = "_")

SAEB_MUNICIPAL_PANEL=SAEB_MUNICIPAL_PANEL |> mutate(value = gsub(",", ".", value)) 

SAEB_MUNICIPAL_PANEL=SAEB_MUNICIPAL_PANEL |> pivot_wider(names_from = VAR,values_from = value)

SAEB_MUNICIPAL_PANEL$TA9=as.numeric(SAEB_MUNICIPAL_PANEL$TA9)
SAEB_MUNICIPAL_PANEL$SAEBMT=as.numeric(SAEB_MUNICIPAL_PANEL$SAEBMT)
SAEB_MUNICIPAL_PANEL$SAEBLP=as.numeric(SAEB_MUNICIPAL_PANEL$SAEBLP)

SAEB_MUNICIPAL_PANEL=SAEB_MUNICIPAL_PANEL |> group_by(YEAR) |> 
          mutate(SAEBMT_ST=
                   (SAEBMT-mean(SAEBMT,na.rm=T))/sd(SAEBMT,na.rm=T),
                 SAEBLP_ST=
                   (SAEBLP-mean(SAEBLP,na.rm=T))/sd(SAEBLP,na.rm=T)
                 )
#Keep until 2023, last year of Climate panel is 2022
SAEB_MUNICIPAL_PANEL=SAEB_MUNICIPAL_PANEL |> dplyr::filter(YEAR!=2023)

## Feature for climate
Precipitation_month=readRDS(file = "Data_raw/Climate/Precipitation_month.rds")


cut_off_month=
    Precipitation_month |> group_by(code_muni,Month) |>
    reframe(
    tres_95 = quantile(value, 0.95, na.rm = TRUE),
    tres_90 = quantile(value, 0.90, na.rm = TRUE),
    tres_80 = quantile(value, 0.80, na.rm = TRUE),
    mean = mean(value,na.rm = TRUE),
    sd= sd(value,na.rm = TRUE))

# Create variables, only for school years-months.
Precipitation_month=
  Precipitation_month|>
  filter(Year==2021|Year==2019|Year==2017|Year==2015|Year==2013|Year==2011|Year==2009|Year==2007|Year==2005)|>
  filter(Month>1 &  Month<10) 

Precipitation_month_2=Precipitation_month |>
  left_join(cut_off_month) 

Extreme_day2_Table=Precipitation_month_2 |>
  mutate(Extreme_1sd=value>(mean+sd),
         Extreme_2sd=value>(mean+(2*sd)),
         Extreme_3sd=value>(mean+(3*sd))) |>
         group_by(Year,code_muni)|>
         reframe(Extreme_1sd=sum(Extreme_1sd),
                 Extreme_2sd=sum(Extreme_2sd),
                 Extreme_3sd=sum(Extreme_3sd))
## Re compute
Extreme_day2_Table=Extreme_day2_Table |> 
  mutate(Shock_Weather_1sd=Extreme_1sd>=1,
         Shock_Weather_2sd=Extreme_2sd>=1,
         Shock_Weather_3sd=Extreme_3sd>=1) |>
          rename(NMonths_Extreme_1sd=Extreme_1sd,
                 NMonths_Extreme_2sd=Extreme_2sd,
                 NMonths_Extreme_3sd=Extreme_3sd)

Extreme_day2_Table=Extreme_day2_Table|>
  select(Year,code_muni,Shock_Weather_1sd,Shock_Weather_2sd,Shock_Weather_3sd,
         NMonths_Extreme_1sd,NMonths_Extreme_2sd,NMonths_Extreme_3sd) 
Extreme_day2_Table=Extreme_day2_Table |> rename(CO_MUNICIPIO=code_muni,YEAR=Year)

## format and keep the correct objects
SAEB_MUNICIPAL_PANEL$YEAR=as.numeric(SAEB_MUNICIPAL_PANEL$YEAR)
SAEB_MUNICIPAL_PANEL_Climate=SAEB_MUNICIPAL_PANEL |> left_join(Extreme_day2_Table)
SAEB_MUNICIPAL=SAEB_MUNICIPAL_PANEL_Climate |> filter(!is.na(Shock_Weather_1sd))

## Save a RDS with the panel: 
saveRDS(object = SAEB_MUNICIPAL,file = "data_processed/Panel_SAEB_Climate")

