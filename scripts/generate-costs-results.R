setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results")
library("ggplot2")
library(dplyr)
source("results_functions.R")

  workloads <- c("300", "2400","4500")
  scenarios <- c("benchmark","all-in-one","by-stack","by-dependencies")
  samples <- 1:6


  ######################### COSTS RESULTS #########################
  metrics <- c("costs")
  costs_consolidated_table = consolidate_table(samples, workloads, scenarios,"costs",metrics)

  figCostsResult.scenario <- ggplot(costs_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=costs_result)) +
                      geom_boxplot() +
                      facet_wrap(~workload, scales = "free") +
                      ggtitle("Monthly Cost (U$) x Scenario") + 
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
  
  pdf("graphics_and_tables/costs_result_scenario.pdf", width = 16, height = 9)
  print(figCostsResult.scenario)
  consolidated_table_summary <- consolidate_summary(costs_consolidated_table, costs_consolidated_table$costs_result, workloads, scenarios)
  write.table(consolidated_table_summary, "graphics_and_tables/summarized_costs_result.csv", sep=",",row.names=FALSE)
  dev.off()
  