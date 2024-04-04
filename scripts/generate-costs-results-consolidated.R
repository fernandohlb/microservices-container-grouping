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
      destination_folder = "graphics_and_tables_consolidated/costs/with_hpa"
    } else {
      origem_folder = "raw_results"
      destination_folder = "graphics_and_tables_consolidated/costs/not_hpa"
    }


  ######################### COSTS RESULTS #########################
  metrics <- c("costs")
  costs_consolidated_table = consolidate_table(origem_folder,samples, workloads, scenarios,"costs",metrics,with_hpa)

  figCostsResult.scenario <- ggplot(costs_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=costs_result)) +
                      geom_boxplot() +
                      facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +    
                      # facet_wrap(~workload, scales = "free") +
                      # ggtitle("Monthly Cost (U$) x Scenario") + 
                      xlab("Grouping Scenarios") +
                      ylab("Monthly Cost (U$)")+
                      guides(color = guide_legend(title="Scenario")) + 
                      theme(plot.title = element_text(hjust = 0.5, vjust = 5, size = 20),
                            strip.text = element_text(size= 16),
                            plot.margin = unit(c(1,1,1,1), "cm"),
                            axis.text = element_text(size = 16),
                            axis.text.x = element_text(angle = -45), 
                            legend.title = element_text(size = 12),
                            legend.text = element_text(size = 12),
                            axis.title = element_text(size = 16),
                            axis.title.y=element_text(vjust=5),
                            axis.title.x=element_text(vjust=-5))
  
  pdf_file = paste(destination_folder,"/costs_result_consolidated.pdf",sep = "")
  table_file = paste(destination_folder,"/summarized_costs_result_consolidated.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder,"/costs_result_hpa_consolidated.pdf",sep = "")
    table_file = paste(destination_folder,"/summarized_costs_result_hpa_consolidated.csv",sep = "")
  }
  
  pdf(pdf_file, width = 16, height = 9)
  print(figCostsResult.scenario)
  consolidated_table_summary <- consolidate_summary(costs_consolidated_table, costs_consolidated_table$costs_result, workloads, scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()
  