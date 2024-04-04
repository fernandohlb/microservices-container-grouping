setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results")
library("ggplot2")
library(dplyr)
source("results_functions.R")

    workloads <- c("300", "2400","4500")
    scenarios <- c("benchmark","all-in-one","by-stack","by-dependencies")
    samples <- 1:6
    with_hpa = FALSE
    
    if (with_hpa) {
      origem_folder = "raw_results_distributed"
      destination_folder = "graphics_and_tables_by_time/costs/with_hpa"
    } else {
      origem_folder = "raw_results"
      destination_folder = "graphics_and_tables_by_time/costs/not_hpa"
    }


  ######################### COSTS RESULTS #########################
  metrics <- c("costs")
  costs_consolidated_table = consolidate_table_by_time(origem_folder,samples, workloads, scenarios,"costs",metrics,with_hpa)

  figCostsResult.scenario <- ggplot(costs_consolidated_table, aes(x=factor(seconds), y=costs_result, color = factor(scenario))) +
    geom_boxplot(position = position_dodge(width = 0.9)) +
    stat_summary(
      fun = median,
      geom = 'line',
      aes(group = scenario, colour = factor(scenario)),
      position = position_dodge(width = 0.9) #this has to be added
    ) +    
    facet_wrap(~workload,ncol=1, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    xlab("Seconds") +
    ylab("Monthly Cost (U$)")+
    guides(color = guide_legend(title="Scenario")) + 
    theme(plot.title = element_text(hjust = 0.5, vjust = 5, size = 20),
          strip.text = element_text(size= 20),
          plot.margin = unit(c(1,1,1,1), "cm"),
          axis.text = element_text(size = 16),
          axis.text.x = element_text(angle = -45), 
          legend.title = element_text(size = 14),
          legend.text = element_text(size = 12),
          axis.title = element_text(size = 16),
          axis.title.y=element_text(vjust=5),
          axis.title.x=element_text(vjust=-5))
  
  pdf_file = paste(destination_folder,"/costs_result_by_time.pdf",sep = "")
  table_file = paste(destination_folder,"/summarized_costs_result_by_time.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder,"/costs_result_hpa_by_time.pdf",sep = "")
    table_file = paste(destination_folder,"/summarized_costs_result_hpa_by_time.csv",sep = "")
  }
  
  pdf(pdf_file, width = 16, height = 9)
  print(figCostsResult.scenario)
  consolidated_table_summary = consolidate_summary_v2(costs_consolidated_table,costs_consolidated_table$costs_result,workloads,scenarios)  
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()
  