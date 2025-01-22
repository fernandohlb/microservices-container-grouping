setwd("~/Documentos/Mestrado/microservices-container-grouping/experiments_results")
library("ggplot2")
library("ggrepel")
library(dplyr)
source("results_functions.R")


  with_hpa = TRUE
  workloads <- c("300", "2400","4500")
  scenarios <- c("benchmark","all-in-one","by-stack","by-dependencies")
  samples <- 1:6
  
  # if (with_hpa) {
    origem_folder = "raw_results_distributed"
    destination_folder_consolidated = "graphics_and_tables_consolidated/hpa"
    destination_folder_by_time = "graphics_and_tables_by_time/resources"
  # } else {
  #   origem_folder = "raw_results"
  #   destination_folder_consolidated = "graphics_and_tables_consolidated/resources/not_hpa"
  #   destination_folder_by_time = "graphics_and_tables_by_time/resources/not_hpa"
  #   
  # }
  
  
  ######################### HPA RESULTS #########################
  metrics <- c("hpa_pods")
  hpa_consolidated_table = consolidate_table_by_time(origem_folder,samples, workloads, scenarios,"hpa",metrics,with_hpa)
  hpa_consolidated_table <- hpa_consolidated_table %>%
    mutate(scalability_rate = ((hpa_pods_result - qtd_microservices_pods)/qtd_microservices_pods)*100)
  #Exclude warmup time
  #filtered_cpu_consolidated_table <- cpu_consolidated_table[cpu_consolidated_table$seconds >= 300,]
  filtered_hpa_consolidated_table <- hpa_consolidated_table
  
  ######################### GENERATE CONSOLIDATED RESULTS#######################
  
  figHpaPods <- ggplot(filtered_hpa_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=hpa_pods_result)) +
    geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
    facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    #ggtitle("CPU Usage x Scenario") + 
    xlab("Grouping Scenarios") +
    ylab("Num Pods")+
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
  
  pdf_file = paste(destination_folder_consolidated,"/hpa_pods_consolidated.pdf",sep = "")
  table_file = paste(destination_folder_consolidated,"/summarized_hpa_pods_consolidated.csv",sep = "")
  
  
  pdf(pdf_file, width = 16, height = 9)
  print(figHpaPods)
  consolidated_table_summary <- consolidate_summary(filtered_hpa_consolidated_table, filtered_hpa_consolidated_table$hpa_pods_result, workloads, scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()  
  
  
  ######################## GENERATE RESULTS BY TIME ############################
  figHpaPods.time <- ggplot(filtered_hpa_consolidated_table, aes(x=factor(seconds), y=hpa_pods_result, color = factor(scenario))) +
    geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
    stat_summary(
      fun = median,
      geom = 'line',
      aes(group = scenario, colour = factor(scenario)),
      position = position_dodge(width = 0.9) #this has to be added
    ) +    
    facet_wrap(~workload,ncol=1, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    #ggtitle("Requests/s x Scenario") + 
    xlab("Seconds") +
    ylab("Num Pods")+
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
  
  pdf_file = paste(destination_folder_consolidated,"/hpa_pods_by_time.pdf",sep = "")
  table_file = paste(destination_folder_consolidated,"/summarized_hpa_pods_by_time.csv",sep = "")
  
  pdf(pdf_file, width = 16, height = 9)
  print(figHpaPods.time)
  consolidated_table_summary <- consolidate_summary_v2(filtered_hpa_consolidated_table, filtered_hpa_consolidated_table$hpa_pods_result, workloads, scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  ######################### GENERATE CONSOLIDATED RESULTS#######################
  
  figHpaPods <- ggplot(filtered_hpa_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=scalability_rate)) +
    geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
    facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    #ggtitle("CPU Usage x Scenario") + 
    xlab("Grouping Scenarios") +
    ylab("Scalability Rate (%)")+
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
  
  pdf_file = paste(destination_folder_consolidated,"/hpa_pods_scalability_rate_consolidated.pdf",sep = "")
  table_file = paste(destination_folder_consolidated,"/summarized_hpa_pods_scalability_rate_consolidated.csv",sep = "")
  
  
  pdf(pdf_file, width = 16, height = 9)
  print(figHpaPods)
  consolidated_table_summary <- consolidate_summary(filtered_hpa_consolidated_table, filtered_hpa_consolidated_table$scalability_rate, workloads, scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()  
  
  
  ######################## GENERATE RESULTS BY TIME ############################
  figHpaPods.time <- ggplot(filtered_hpa_consolidated_table, aes(x=factor(seconds), y=scalability_rate, color = factor(scenario))) +
    geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
    stat_summary(
      fun = median,
      geom = 'line',
      aes(group = scenario, colour = factor(scenario)),
      position = position_dodge(width = 0.9) #this has to be added
    ) +    
    facet_wrap(~workload,ncol=1, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    xlab("Seconds") +
    ylab("Scalability Rate (%)")+
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
  
  pdf_file = paste(destination_folder_consolidated,"/hpa_pods_scalability_rate_by_time.pdf",sep = "")
  table_file = paste(destination_folder_consolidated,"/summarized_hpa_pods_sacalability_rate_by_time.csv",sep = "")
  
  pdf(pdf_file, width = 16, height = 9)
  print(figHpaPods.time)
  consolidated_table_summary <- consolidate_summary_v2(filtered_hpa_consolidated_table, filtered_hpa_consolidated_table$scalability_rate, workloads, scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()

  
  