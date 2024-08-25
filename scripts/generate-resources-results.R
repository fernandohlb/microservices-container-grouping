setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results")
library("ggplot2")
library("ggrepel")
library(dplyr)
source("results_functions.R")


  with_hpa = FALSE
  workloads <- c("300", "2400","4500")
  scenarios <- c("benchmark","all-in-one","by-stack","by-dependencies")
  samples <- 1:6
  
  if (with_hpa) {
    origem_folder = "raw_results_distributed"
    destination_folder_consolidated = "graphics_and_tables_consolidated/resources/with_hpa"
    destination_folder_by_time = "graphics_and_tables_by_time/resources/with_hpa"
  } else {
    origem_folder = "raw_results"
    destination_folder_consolidated = "graphics_and_tables_consolidated/resources/not_hpa"
    destination_folder_by_time = "graphics_and_tables_by_time/resources/not_hpa"
    
  }
  
  
  ######################### CPU RESULTS #########################
  metrics <- c("cpu_usage")
  cpu_consolidated_table = consolidate_table_by_time(origem_folder,samples, workloads, scenarios,"cpu",metrics,with_hpa)
  #Exclude warmup time
  #filtered_cpu_consolidated_table <- cpu_consolidated_table[cpu_consolidated_table$seconds >= 300,]
  filtered_cpu_consolidated_table <- cpu_consolidated_table
  
  ######################### GENERATE CONSOLIDATED RESULTS#######################
  
  figCpuUsage.scenario <- ggplot(filtered_cpu_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=cpu_usage_result)) +
    geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
    facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    #ggtitle("CPU Usage x Scenario") + 
    xlab("Grouping Scenarios") +
    ylab("CPU Usage (cores)")+
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
  
  pdf_file = paste(destination_folder_consolidated,"/cpu_usage_scenario_consolidated.pdf",sep = "")
  table_file = paste(destination_folder_consolidated,"/summarized_cpu_usage_consolidated.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_consolidated,"/cpu_usage_scenario_hpa_consolidated.pdf",sep = "")
    table_file = paste(destination_folder_consolidated,"/summarized_cpu_usage_hpa_consolidated.csv",sep = "")
  }
  
  
  pdf(pdf_file, width = 16, height = 9)
  print(figCpuUsage.scenario)
  consolidated_table_summary <- consolidate_summary(filtered_cpu_consolidated_table, filtered_cpu_consolidated_table$cpu_usage, workloads, scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()  
  
  
  ######################## GENERATE RESULTS BY TIME ############################
  figCpuUsage.scenario <- ggplot(cpu_consolidated_table, aes(x=factor(seconds), y=cpu_usage_result, color = factor(scenario))) +
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
    ylab("CPU Usage (cores)")+
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
  
  pdf_file = paste(destination_folder_by_time,"/cpu_usage_scenario_by_time.pdf",sep = "")
  table_file = paste(destination_folder_by_time,"/summarized_cpu_usage_by_time.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_by_time,"/cpu_usage_scenario_hpa_by_time.pdf",sep = "")
    table_file = paste(destination_folder_by_time,"/summarized_cpu_usage_hpa_by_time.csv",sep = "")
  }
  
  
  pdf(pdf_file, width = 16, height = 9)
  print(figCpuUsage.scenario)
  consolidated_table_summary = consolidate_summary_v2(cpu_consolidated_table,cpu_consolidated_table$cpu_usage,workloads,scenarios)
  #consolidated_table_summary <- consolidate_summary(cpu_consolidated_table, cpu_consolidated_table$cpu_usage, workloads, scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()

  ######################### MEMORY RESULTS #########################
  metrics <- c("memory")
  
  memory_consolidated_table = consolidate_table_by_time(origem_folder,samples, workloads, scenarios,"memory",metrics,with_hpa)
  memory_consolidated_table <- memory_consolidated_table %>% 
    mutate(across(.cols = c(memory_result), .fns = ~.x /1024/1024/1024))
  
  #filtered_memory_consolidated_table <- memory_consolidated_table[memory_consolidated_table$seconds >= 300,]
  filtered_memory_consolidated_table <- memory_consolidated_table
  ######################### GENERATE CONSOLIDATED RESULTS#######################
  
  figMemoryUsage.scenario <- ggplot(filtered_memory_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=memory_result)) +
    geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
    facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    #ggtitle("Memory Usage x Scenario") + 
    xlab("Grouping Scenarios") +
    ylab("Memory Usage(Gbi)")+
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
  
  pdf_file = paste(destination_folder_consolidated,"/memory_usage_scenario_consolidated.pdf",sep = "")
  table_file = paste(destination_folder_consolidated,"/summarized_memory_usage_consolidated.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_consolidated,"/memory_usage_scenario_hpa_consolidated.pdf",sep = "")
    table_file = paste(destination_folder_consolidated,"/summarized_memory_usage_hpa_consolidated.csv",sep = "")
  }
  
  
  pdf(pdf_file, width = 16, height = 9)
  print(figMemoryUsage.scenario)
  
  consolidated_table_summary <- consolidate_summary(filtered_memory_consolidated_table, filtered_memory_consolidated_table$memory_result, workloads, scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  
  ######################## GENERATE RESULTS BY TIME ############################

  figMemoryUsage.scenario <- ggplot(memory_consolidated_table, aes(x=factor(seconds), y=memory_result, color = factor(scenario))) +
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
    ylab("Memory Usage(Gbi)")+
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
  
  pdf_file = paste(destination_folder_by_time,"/memory_usage_scenario_by_time.pdf",sep = "")
  table_file = paste(destination_folder_by_time,"/summarized_memory_usage_by_time.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_by_time,"/memory_usage_scenario_hpa_by_time.pdf",sep = "")
    table_file = paste(destination_folder_by_time,"/summarized_memory_usage_hpa_by_time.csv",sep = "")
  }
  
  
  pdf(pdf_file, width = 16, height = 9)
  print(figMemoryUsage.scenario)
  
  consolidated_table_summary = consolidate_summary_v2(memory_consolidated_table,memory_consolidated_table$memory_result,workloads,scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  
  ######################### NETWORK RESULTS #########################
  metrics <- c("network_receive","network_transmit")
  
  network_consolidated_table = consolidate_table_by_time(origem_folder,samples, workloads, scenarios,"network",metrics,with_hpa)
  network_consolidated_table <- network_consolidated_table %>% 
    mutate(across(.cols = c(network_receive_result), .fns = ~.x /1024/1024))  
  network_consolidated_table <- network_consolidated_table %>% 
    mutate(across(.cols = c(network_transmit_result), .fns = ~.x /1024/1024*-1))
  
  network_consolidated_table$network_total_result <- with(network_consolidated_table, network_receive_result + network_transmit_result)
  
  #Filter warm up time
  #filtered_network_consolidated_table <- network_consolidated_table[network_consolidated_table$seconds >= 300,]
  filtered_network_consolidated_table <- network_consolidated_table

  ######################### GENERATE CONSOLIDATED RESULTS#######################
  
  #Receive
  figNetworkUsage.receive.scenario <- ggplot(filtered_network_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=network_receive_result)) +
    geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
    facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    #facet_wrap(~workload, scales = "free") +
    #ggtitle("Network Usage Receive (Mb/s) x Scenario") + 
    xlab("Grouping Scenarios") +
    ylab("Network Usage Receive (Mb/s)")+
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
  
  pdf_file = paste(destination_folder_consolidated,"/network_usage_receive_consolidated.pdf",sep = "")
  table_file = paste(destination_folder_consolidated,"/summarized_network_usage_receive_consolidated.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_consolidated,"/network_usage_receive_hpa_consolidated.pdf",sep = "")
    table_file = paste(destination_folder_consolidated,"/summarized_network_usage_receive_hpa_consolidated.csv",sep = "")
  }
  
  pdf(pdf_file, width = 16, height = 9)
  print(figNetworkUsage.receive.scenario)
  
  consolidated_table_summary <- consolidate_summary(filtered_network_consolidated_table, filtered_network_consolidated_table$network_receive_result, workloads, scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  #Transmit
  figNetworkUsage.transmit.scenario <- ggplot(filtered_network_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=network_transmit_result)) +
    geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
    facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    #facet_wrap(~workload, scales = "free") +
    #ggtitle("Network Usage Transmit (Mb/s) x Scenario") + 
    xlab("Grouping Scenarios") +
    ylab("Network Usage Transmit (Mb/s)")+
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
  
  pdf_file = paste(destination_folder_consolidated,"/network_usage_transmit_consolidated.pdf",sep = "")
  table_file = paste(destination_folder_consolidated,"/summarized_network_usage_transmit_consolidated.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_consolidated,"/network_usage_transmit_hpa_consolidated.pdf",sep = "")
    table_file = paste(destination_folder_consolidated,"/summarized_network_usage_transmit_hpa_consolidated.csv",sep = "")
  }
  
  pdf(pdf_file, width = 16, height = 9)
  print(figNetworkUsage.transmit.scenario)
  
  consolidated_table_summary <- consolidate_summary(filtered_network_consolidated_table, filtered_network_consolidated_table$network_transmit_result, workloads, scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  #Total - Receive + Trasmit
  figNetworkUsage.total.scenario <- ggplot(filtered_network_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=network_total_result)) +
    geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
    facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    #facet_wrap(~workload, scales = "free") +
    #ggtitle("Network Usage Total (Mb/s) x Scenario") + 
    xlab("Grouping Scenarios") +
    ylab("Network Usage Total (Mb/s)")+
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
  
  pdf_file = paste(destination_folder_consolidated,"/network_usage_total_consolidated.pdf",sep = "")
  table_file = paste(destination_folder_consolidated,"/summarized_network_usage_total_consolidated.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_consolidated,"/network_usage_total_hpa_consolidated.pdf",sep = "")
    table_file = paste(destination_folder_consolidated,"/summarized_network_usage_total_hpa_consolidated.csv",sep = "")
  }
  
  pdf(pdf_file, width = 16, height = 9)
  print(figNetworkUsage.total.scenario)
  
  consolidated_table_summary <- consolidate_summary(filtered_network_consolidated_table, filtered_network_consolidated_table$network_total_result, workloads, scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  ######################## GENERATE RESULTS BY TIME ############################
  figNetworkUsage.receive.scenario <- ggplot(network_consolidated_table, aes(x=factor(seconds), y=network_receive_result, color = factor(scenario))) +
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
    ylab("Network Usage Receive (Mb/s)")+
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
  
  pdf_file = paste(destination_folder_by_time,"/network_usage_receive_by_time.pdf",sep = "")
  table_file = paste(destination_folder_by_time,"/summarized_network_usage_receive_by_time.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_by_time,"/network_usage_receive_hpa_by_time.pdf",sep = "")
    table_file = paste(destination_folder_by_time,"/summarized_network_usage_receive_hpa_by_time.csv",sep = "")
  }
  
  pdf(pdf_file, width = 16, height = 9)
  print(figNetworkUsage.receive.scenario)
  
  
  consolidated_table_summary <- consolidate_summary_v2(network_consolidated_table,network_consolidated_table$network_receive_result,workloads,scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  figNetworkUsage.transmit.scenario <- ggplot(network_consolidated_table, aes(x=factor(seconds), y=network_transmit_result, color = factor(scenario))) +
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
    ylab("Network Usage Transmit (Mb/s)")+
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
  
  
  pdf_file = paste(destination_folder_by_time,"/network_usage_transmit_by_time.pdf",sep = "")
  table_file = paste(destination_folder_by_time,"/summarized_network_usage_transmit_by_time.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_by_time,"/network_usage_transmit_hpa_by_time.pdf",sep = "")
    table_file = paste(destination_folder_by_time,"/summarized_network_usage_transmit_hpa_by_time.csv",sep = "")
  }
  
  pdf(pdf_file, width = 16, height = 9)
  print(figNetworkUsage.transmit.scenario)
  
  consolidated_table_summary <- consolidate_summary_v2(network_consolidated_table,network_consolidated_table$network_transmit_result,workloads,scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  figNetworkUsage.total.scenario <- ggplot(network_consolidated_table, aes(x=factor(seconds), y=network_total_result, color = factor(scenario))) +
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
    ylab("Network Usage Total (Mb/s)")+
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
  
  
  pdf_file = paste(destination_folder_by_time,"/network_usage_total_by_time.pdf",sep = "")
  table_file = paste(destination_folder_by_time,"/summarized_network_usage_total_by_time.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_by_time,"/network_usage_total_hpa_by_time.pdf",sep = "")
    table_file = paste(destination_folder_by_time,"/summarized_network_usage_total_hpa_by_time.csv",sep = "")
  }
  
  pdf(pdf_file, width = 16, height = 9)
  print(figNetworkUsage.total.scenario)
  
  consolidated_table_summary <- consolidate_summary_v2(network_consolidated_table,network_consolidated_table$network_total_result,workloads,scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  ######################### FILESYSTEM RESULTS #########################
  metrics <- c("disk_usage")
  filesystem_consolidated_table = consolidate_table_by_time(origem_folder,samples, workloads, scenarios,"filesystem",metrics,with_hpa)
  filesystem_consolidated_table <- filesystem_consolidated_table %>% 
    mutate(across(.cols = c(disk_usage_result), .fns = ~.x /1024/1024))
  
  #Filter warm up time
  #filtered_filesystem_consolidated_table <- filesystem_consolidated_table[filesystem_consolidated_table$seconds >= 300,]
  filtered_filesystem_consolidated_table <- filesystem_consolidated_table
  
  ######################### GENERATE CONSOLIDATED RESULTS#######################
  figDiskUsage.scenario <- ggplot(filtered_filesystem_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=disk_usage_result)) +
    geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
    facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    #facet_wrap(~workload, scales = "free") +
    #ggtitle("Disk Usage x Scenario") + 
    xlab("Grouping Scenarios") +
    ylab("Disk Usage(Mbi)")+
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
  
  pdf_file = paste(destination_folder_consolidated,"/disk_usage_consolidated.pdf",sep = "")
  table_file = paste(destination_folder_consolidated,"/summarized_disk_usage_consolidated.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_consolidated,"/disk_usage_hpa_consolidated.pdf",sep = "")
    table_file = paste(destination_folder_consolidated,"/summarized_disk_usage_hpa_consolidated.csv",sep = "")
  }
  
  pdf(pdf_file, width = 16, height = 9)
  print(figDiskUsage.scenario)  
  
  consolidated_table_summary <- consolidate_summary(filtered_filesystem_consolidated_table, filtered_filesystem_consolidated_table$disk_usage_result, workloads, scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()
  ######################## GENERATE RESULTS BY TIME ############################
  
  figDiskUsage.scenario <- ggplot(filesystem_consolidated_table, aes(x=factor(seconds), y=disk_usage_result, color = factor(scenario))) +
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
    ylab("Network Usage Total (Mb/s)")+
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

  pdf_file = paste(destination_folder_by_time,"/disk_usage_by_time.pdf",sep = "")
  table_file = paste(destination_folder_by_time,"/summarized_disk_usage_by_time.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_by_time,"/disk_usage_hpa_by_time.pdf",sep = "")
    table_file = paste(destination_folder_by_time,"/summarized_disk_usage_hpa_by_time.csv",sep = "")
  }
  
  pdf(pdf_file, width = 16, height = 9)
  print(figDiskUsage.scenario)  

  consolidated_table_summary <- consolidate_summary_v2(filesystem_consolidated_table,filesystem_consolidated_table$disk_usage_result,workloads,scenarios)
  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
  dev.off()

  