## File:03_Visuals_BR
## Objective: 
## Read panel data and raw data. 
## Save the resulting tables and figures in results in output folder..

## Climate shocks main plot
Panel_SAEB_Climate=read_rds(file = "data_processed/Panel_SAEB_Climate")
Panel_SAEB_Climate=Panel_SAEB_Climate|> ungroup()

Panel_SAEB_Climate |> group_by(YEAR) |>
  reframe(Municipality=n(),
          Shock_Weather_1sd=mean(Shock_Weather_1sd)*100,
          Shock_Weather_2sd=mean(Shock_Weather_2sd)*100,
          Shock_Weather_3sd=mean(Shock_Weather_3sd)*100) |> pivot_longer(cols = 3:5) |>
  
  ggplot(aes(x=YEAR,y=value,col=name))+geom_point()+geom_line()+
  labs(title = "Percent of municipalities that experience a climate shocks",
       y = "Percentage", x = "Year")+
  theme_bw()+
  scale_color_discrete(name="Shock:",labels = c("Shock_Weather_1sd" = ">1sd",
                                  "Shock_Weather_2sd" = ">2sd",
                                  "Shock_Weather_3sd" = ">3sd"))+
  theme(legend.position = "bottom")+geom_vline(xintercept = 2009,linetype = "dashed")
ggsave(filename = "outputs/figures/Climate_shocks.jpg",width = 7,height = 7)


## outcomes by shocks
Panel_SAEB_Climate |> select(CO_MUNICIPIO,Shock_Weather_1sd,YEAR,SAEBLP_ST,SAEBMT_ST,TA9)|>
  pivot_longer(cols =4:6) |> 
  ggplot(aes(col = Shock_Weather_1sd,x=value))+
  geom_density()+facet_wrap(.~name,scales = "free",nrow = 3)+
  scale_color_discrete(name="Shock (>1d):",labels = c("True" = ">1sd"))+xlab("")+
  theme_bw()+ggtitle("Distribution of outcomes by shock exposure (1sd)")+theme(legend.position = "bottom")
ggsave(filename = "outputs/figures/Climate_shocks_1d.jpg",width = 5,height = 10)


Panel_SAEB_Climate |> select(CO_MUNICIPIO,Shock_Weather_2sd,YEAR,SAEBLP_ST,SAEBMT_ST,TA9)|>
  pivot_longer(cols =4:6) |> 
  ggplot(aes(col = Shock_Weather_2sd,x=value))+
  geom_density()+facet_wrap(.~name,scales = "free",nrow = 3)+
  scale_color_discrete(name="Shock (>2d):",labels = c("True" = ">2sd"))+xlab("")+
  theme_bw()+ggtitle("Distribution of outcomes by shock exposure (2sd)")+theme(legend.position = "bottom")
ggsave(filename = "outputs/figures/Climate_shocks_2d.jpg",width = 5,height = 10)

Panel_SAEB_Climate |> select(CO_MUNICIPIO,Shock_Weather_3sd,YEAR,SAEBLP_ST,SAEBMT_ST,TA9)|>
  pivot_longer(cols =4:6) |> 
  ggplot(aes(col = Shock_Weather_3sd,x=value))+
  geom_density()+facet_wrap(.~name,scales = "free",nrow = 3)+
  scale_color_discrete(name="Shock (>3d):",labels = c("True" = ">3sd"))+xlab("")+
  theme_bw()+ggtitle("Distribution of outcomes by shock exposure (3sd)")+theme(legend.position = "bottom")
ggsave(filename = "outputs/figures/Climate_shocks_3d.jpg",width = 5,height = 10)


## Plot the size of shocks
Precipitation_month=readRDS(file = "Data_raw/Climate/Precipitation_month.rds")
cut_off_month=
  Precipitation_month |> group_by(code_muni,Month) |>
  reframe(
    tres_95 = quantile(value, 0.95, na.rm = TRUE),
    tres_90 = quantile(value, 0.90, na.rm = TRUE),
    tres_80 = quantile(value, 0.80, na.rm = TRUE),
    mean = mean(value,na.rm = TRUE),
    sd= sd(value,na.rm = TRUE))

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


Extreme_day2_Table=Extreme_day2_Table |> 
  mutate(Shock_Weather_1sd=Extreme_1sd>=1,
         Shock_Weather_2sd=Extreme_2sd>=1,
         Shock_Weather_3sd=Extreme_3sd>=1) |>
  rename(NMonths_Extreme_1sd=Extreme_1sd,
         NMonths_Extreme_2sd=Extreme_2sd,
         NMonths_Extreme_3sd=Extreme_3sd)

Extreme_day2_Table=Extreme_day2_Table |> mutate(CD_MUN=as.factor(code_muni))

## Last plot using spatial features
Municipios <- readRDS("Data_raw/Shape/Municipios.rds")
Pob_2021 <- readRDS("Data_raw/Pob_2021.rds")

Extreme_day2_Table |> filter(Year!=2023) |> group_by(Year) |>
  reframe(Municipality=n(),
          # Shock_Weather_1sd=mean(Shock_Weather_1sd)*100,
          # Shock_Weather_2sd=mean(Shock_Weather_2sd)*100,
          Shock_Weather_2sd=mean(Shock_Weather_2sd)*100) |> pivot_longer(cols = 3:3) |>
  ggplot(aes(x=Year,y=value,col=name))+geom_point()+geom_line()+
  labs(title = "Percent of municipalities that experience a climate shocks",
       y = "Percentage", x = "Year")+
  theme_bw()+
  scale_color_discrete(name="Shock:",labels = c(#"Shock_Weather_1sd" = ">1sd",
    #"Shock_Weather_2sd" = ">2sd",
    "Shock_Weather_2sd" = ">2sd"))+
  theme(legend.position = "bottom")
ggsave(filename = "outputs/figures/Climate_shocks_TS.jpg",width = 7,height = 7)


## MAPS
Map_21=Climate_maps(Year_reference = 2021,Extreme_day2_Table=Extreme_day2_Table,Municipios=Municipios)
Map_11=Climate_maps(Year_reference = 2011,Extreme_day2_Table=Extreme_day2_Table,Municipios=Municipios)

tmap_save(Map_21,filename = "outputs/figures/Map_shock_21.png",width = 7,height = 7)
tmap_save(Map_11,filename = "outputs/figures/Map_shock_11.png",width = 7,height = 7)

Pob_2021=Pob_2021 |> mutate(code_muni=as.numeric(`Município (Código)`)) |> select(code_muni,Valor)

## Last table
Extreme_day2_Table_21=Extreme_day2_Table |> filter(Year==2021) |> left_join(Pob_2021)

write.csv(
Extreme_day2_Table_21 |> group_by(Shock_Weather_2sd) |> 
  reframe(Pop=sum(Valor,na.rm = T),Municipalities=n()),file = "outputs/tables/BE_estimates.csv"
)

