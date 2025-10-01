## File:03_modeling_BR
## Objective: 
## Read panel data, run FE models. 
## Save the resulting tables and figures in results in output folder.


# source("Code/99_utils.R")
# Read panel
Panel_SAEB_Climate=read_rds(file = "data_processed/Panel_SAEB_Climate")
Panel_SAEB_Climate=Panel_SAEB_Climate|> ungroup()

Panel_SAEB_Climate |> 
  reframe(Municipality=n(),
          Shock_Weather_1sd=mean(Shock_Weather_1sd)*100,
          Shock_Weather_2sd=mean(Shock_Weather_2sd)*100,
          Shock_Weather_3sd=mean(Shock_Weather_3sd)*100) 

## Main models
  mod_shock_1sd_MT <- feols(SAEBMT_ST ~ Shock_Weather_1sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate)
  mod_shock_2sd_MT <- feols(SAEBMT_ST ~ Shock_Weather_2sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate)
  mod_shock_3sd_MT <- feols(SAEBMT_ST ~ Shock_Weather_3sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate)

  mod_shock_1sd_LP <- feols(SAEBLP_ST ~ Shock_Weather_1sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate)
  mod_shock_2sd_LP <- feols(SAEBLP_ST ~ Shock_Weather_2sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate)
  mod_shock_3sd_LP <- feols(SAEBLP_ST ~ Shock_Weather_3sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate)
  
  mod_shock_1sd_TA9 <- feols(TA9 ~ Shock_Weather_1sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate)
  mod_shock_2sd_TA9 <- feols(TA9 ~ Shock_Weather_2sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate)
  mod_shock_3sd_TA9 <- feols(TA9 ~ Shock_Weather_3sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate)

# Table output  
  modelsummary(
    list(
      "SAEB Math std" = mod_shock_1sd_MT, 
      "SAEB Lenguage std" = mod_shock_1sd_LP, 
      "Pass rate (%)" = mod_shock_1sd_TA9, 
      "SAEB Math std" = mod_shock_2sd_MT,
      "SAEB Lenguage std" = mod_shock_2sd_LP,
      "Pass rate (%)" = mod_shock_2sd_TA9,
      "SAEB Math std" = mod_shock_3sd_MT,
      "SAEB Lenguage std" = mod_shock_3sd_LP,
      "Pass rate (%)" = mod_shock_3sd_TA9
    ),
    coef_map = c(
      "Shock_Weather_1sdTRUE" = "Rainfall Shock (1sd)",
      "Shock_Weather_2sdTRUE" = "Rainfall Shock (2sd)",
      "Shock_Weather_3sdTRUE" = "Rainfall Shock (3sd)"),
    stars = TRUE,
    gof_omit = "IC|Log|Adj|Within",output = "outputs/tables/FE_models.xlsx")  # 
  
  
## Robustness check, same results.
  mod_shock_1sd_MT_R <- feols(SAEBMT_ST ~ Shock_Weather_1sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate |> filter(YEAR!=2009))
  mod_shock_2sd_MT_R <- feols(SAEBMT_ST ~ Shock_Weather_2sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate|> filter(YEAR!=2009))
  mod_shock_3sd_MT_R <- feols(SAEBMT_ST ~ Shock_Weather_3sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate|> filter(YEAR!=2009))
  
  mod_shock_1sd_LP_R <- feols(SAEBLP_ST ~ Shock_Weather_1sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate|> filter(YEAR!=2009))
  mod_shock_2sd_LP_R <- feols(SAEBLP_ST ~ Shock_Weather_2sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate|> filter(YEAR!=2009))
  mod_shock_3sd_LP_R <- feols(SAEBLP_ST ~ Shock_Weather_3sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate|> filter(YEAR!=2009))
  
  mod_shock_1sd_TA9_R <- feols(TA9 ~ Shock_Weather_1sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate|> filter(YEAR!=2009))
  mod_shock_2sd_TA9_R <- feols(TA9 ~ Shock_Weather_2sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate|> filter(YEAR!=2009))
  mod_shock_3sd_TA9_R <- feols(TA9 ~ Shock_Weather_3sd | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate|> filter(YEAR!=2009))
  
  modelsummary(
    list(
      "SAEB Math std" = mod_shock_1sd_MT_R, 
      "SAEB Lenguage std" = mod_shock_1sd_LP_R, 
      "Pass rate (%)" = mod_shock_1sd_TA9_R, 
      "SAEB Math std" = mod_shock_2sd_MT_R,
      "SAEB Lenguage std" = mod_shock_2sd_LP_R,
      "Pass rate (%)" = mod_shock_2sd_TA9_R,
      "SAEB Math std" = mod_shock_3sd_MT_R,
      "SAEB Lenguage std" = mod_shock_3sd_LP_R,
      "Pass rate (%)" = mod_shock_3sd_TA9_R
    ),
    coef_map = c(
      "Shock_Weather_1sdTRUE" = "Rainfall Shock (1sd)",
      "Shock_Weather_2sdTRUE" = "Rainfall Shock (2sd)",
      "Shock_Weather_3sdTRUE" = "Rainfall Shock (3sd)"),
    stars = TRUE,
    gof_omit = "IC|Log|Adj|Within",output = "outputs/tables/FE_models_ROBUST.xlsx") 
  
  
## EFFECTS BY MONTH and output.
  mod_shock_2sd_MT_COUNTS <- feols(SAEBMT_ST ~ as.factor(NMonths_Extreme_1sd) | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate)
  mod_shock_2sd_LP_COUNTS <- feols(SAEBLP_ST ~ as.factor(NMonths_Extreme_1sd) | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate)
  mod_shock_2sd_TA9_COUNTS <- feols(TA9 ~ as.factor(NMonths_Extreme_1sd) | CO_MUNICIPIO + YEAR, data = Panel_SAEB_Climate)
  
  tidy_MT <- broom::tidy(mod_shock_2sd_MT_COUNTS, conf.int = TRUE)
  tidy_LP <- broom::tidy(mod_shock_2sd_MT_COUNTS, conf.int = TRUE)
  tidy_TA <- broom::tidy(mod_shock_2sd_TA9_COUNTS, conf.int = TRUE)
  
  
  tidy_MT$Response="Standarized Math score"
  tidy_LP$Response="Standarized Lenguage score"
  tidy_TA$Response="Pass rate (%)"
  
  tidy_models=rbind(tidy_MT,tidy_LP,tidy_TA)
  
  tidy_models$Coef_num=rep(1:6,3)
  
  Coef_plots=tidy_models |>  
    ggplot(aes(x = Coef_num, y = estimate)) + facet_wrap(.~Response,scales = "free_y")+
    geom_point()+
    geom_errorbar(aes(ymin = conf.low, ymax = conf.high), 
                  width = 0.2) +
    geom_hline(yintercept = 0, linetype = "dashed",col="red") +
    labs(title = "Coefficient asosciated with number of shock \n(Fixed Effect Models,Shock 1sd)", y = "Estimate", x = "Number of Months (>1sd)")+
    scale_x_continuous(limits = c(1, 6), breaks = 1:6) +theme_bw()
  
  ggsave(filename = "outputs/figures/Coef_plots.png",width = 10,height = 5)