setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results")
library("ggplot2")
library("ggrepel")
library(dplyr)
source("results_functions.R")

  workloads <- c("300", "2400","4500")
  scenarios <- c("benchmark","all-in-one","by-stack","by-dependencies")
  samples <- 1:6
  
  ######################### CPU RESULTS #########################
  metrics <- c("cpu_usage")
  cpu_consolidated_table = consolidate_table(samples, workloads, scenarios,"cpu",metrics)
  
  
  figCpuUsage.scenario <- ggplot(cpu_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=cpu_usage_result)) +
                      geom_boxplot() +
                      facet_wrap(~workload, scales = "free") +
                      ggtitle("CPU Usage x Scenario") + 
                      xlab("Grouping Scenarios") +
                      ylab("CPU Usage (cores)")+
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
  
  pdf("graphics_and_tables/cpu_usage_scenario.pdf", width = 16, height = 9)
  print(figCpuUsage.scenario)
  consolidated_table_summary <- consolidate_summary(cpu_consolidated_table, cpu_consolidated_table$cpu_usage, workloads, scenarios)
  write.table(consolidated_table_summary, "graphics_and_tables/summarized_cpu_usage.csv", sep=",",row.names=FALSE)
  dev.off()

  ######################### MEMORY RESULTS #########################
  metrics <- c("memory")
  memory_consolidated_table = consolidate_table(samples, workloads, scenarios,"memory",metrics)
  
  memory_consolidated_table <- memory_consolidated_table %>% 
    mutate(across(.cols = c(memory_usage), .fns = ~.x /1024/1024/1024))

  figMemoryUsage.scenario <- ggplot(memory_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=memory_usage)) +
    geom_boxplot() +
    facet_wrap(~workload, scales = "free") +
    ggtitle("Memory Usage x Scenario") + 
    xlab("Grouping Scenarios") +
    ylab("Memory Usage(Gbi)")+
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
  
  pdf("graphics_and_tables/memory_usage_scenario.pdf", width = 16, height = 9)
  print(figMemoryUsage.scenario)
  
  consolidated_table_summary <- consolidate_summary(memory_consolidated_table, memory_consolidated_table$memory_usage, workloads, scenarios)
  write.table(consolidated_table_summary, "graphics_and_tables/summarized_memory_usage.csv", sep=",",row.names=FALSE)
  dev.off()
  
  file_table = read.table("graphics_and_tables/memory_optimization.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)

  figMemoryUsage.optimization <-ggplot(file_table, aes(x=factor(workload, level=c('300', '2400', '4500')), y=Optimization, group=scenario)) +
          geom_line(aes(color=scenario))+
          geom_point(aes(color=scenario))+
          geom_text(hjust=0, vjust=1,aes(label = round(Optimization, 2)),
                    size=7)+
          ggtitle("Memory Usage Optimization compared with Benchmark scenario") + 
          xlab("Worloads (Users)") +
          ylab("Optimization percentage")+
          guides(color = guide_legend(title="Scenarios")) + 
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
  pdf("graphics_and_tables/memory_usage_optimization.pdf", width = 16, height = 9)
  print(figMemoryUsage.optimization)
  dev.off()
  
  ######################### NETWORK RESULTS #########################
  metrics <- c("network_receive","network_transmit")
  network_consolidated_table = consolidate_table(samples, workloads, scenarios,"network",metrics)
  network_consolidated_table <- network_consolidated_table %>% 
    mutate(across(.cols = c(network_receive_usage), .fns = ~.x /1024/1024))  
  network_consolidated_table <- network_consolidated_table %>% 
    mutate(across(.cols = c(network_transmit_usage), .fns = ~.x /1024/1024*-1))
  
  network_consolidated_table$network_total_usage <- with(network_consolidated_table, network_receive_usage + network_transmit_usage)

  figNetworkUsage.receive.scenario <- ggplot(network_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=network_receive_usage)) +
    geom_boxplot() +
    facet_wrap(~workload, scales = "free") +
    ggtitle("Network Usage Receive (Mb/s) x Scenario") + 
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
  
  pdf("graphics_and_tables/network_usage_receive_scenario.pdf", width = 16, height = 9)
  print(figNetworkUsage.receive.scenario)
  
  consolidated_table_summary <- consolidate_summary(network_consolidated_table, network_consolidated_table$network_receive_usage, workloads, scenarios)
  write.table(consolidated_table_summary, "graphics_and_tables/summarized_network_receive_usage.csv", sep=",",row.names=FALSE)
  dev.off()
  
  figNetworkUsage.transmit.scenario <- ggplot(network_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=network_transmit_usage)) +
    geom_boxplot() +
    facet_wrap(~workload, scales = "free") +
    ggtitle("Network Usage Transmit (Mb/s) x Scenario") + 
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
  
  pdf("graphics_and_tables/network_usage_transmit_scenario.pdf", width = 16, height = 9)
  print(figNetworkUsage.transmit.scenario)
  
  consolidated_table_summary <- consolidate_summary(network_consolidated_table, network_consolidated_table$network_transmit_usage, workloads, scenarios)
  write.table(consolidated_table_summary, "graphics_and_tables/summarized_network_transmit_usage.csv", sep=",",row.names=FALSE)
  dev.off()
  
  figNetworkUsage.total.scenario <- ggplot(network_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=network_total_usage)) +
    geom_boxplot() +
    facet_wrap(~workload, scales = "free") +
    ggtitle("Network Usage Total (Mb/s) x Scenario") + 
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
  
  pdf("graphics_and_tables/network_usage_total_scenario.pdf", width = 16, height = 9)
  print(figNetworkUsage.total.scenario)
  
  consolidated_table_summary <- consolidate_summary(network_consolidated_table, network_consolidated_table$network_total_usage, workloads, scenarios)
  write.table(consolidated_table_summary, "graphics_and_tables/summarized_network_total_usage.csv", sep=",",row.names=FALSE)
  dev.off()
  
  file_table = read.table("graphics_and_tables/network_optimization.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
  
  figNetworkUsage.optimization.transmit <-ggplot(file_table, aes(x=factor(workload, level=c('300', '2400', '4500')), y=transmit_optimization_percentage, group=scenario)) +
    geom_line(aes(color=scenario))+
    geom_point(aes(color=scenario))+
    geom_text_repel(vjust=1,aes(label = round(transmit_optimization_percentage, 2)),
              size=7)+
    ggtitle("Network Usage Transmission Optimization compared with Benchmark scenario") + 
    xlab("Worloads (Users)") +
    ylab("Optimization percentage")+
    guides(color = guide_legend(title="Scenarios")) + 
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
  pdf("graphics_and_tables/network_usage_transmit_optimization.pdf", width = 16, height = 9)
  print(figNetworkUsage.optimization.transmit)
  dev.off()
  
  figNetworkUsage.optimization.receive <-ggplot(file_table, aes(x=factor(workload, level=c('300', '2400', '4500')), y=receive_optimization_percentage, group=scenario)) +
    geom_line(aes(color=scenario))+
    geom_point(aes(color=scenario))+
    geom_text_repel(vjust=1,aes(label = round(receive_optimization_percentage, 2)),
              size=7)+
    ggtitle("Network Usage Reception Optimization compared with Benchmark scenario") + 
    xlab("Worloads (Users)") +
    ylab("Optimization percentage")+
    guides(color = guide_legend(title="Scenarios")) + 
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
  pdf("graphics_and_tables/network_usage_receive_optimization.pdf", width = 16, height = 9)
  print(figNetworkUsage.optimization.receive)
  dev.off()
  
  ######################### FILESYSTEM RESULTS #########################
  metrics <- c("disk_usage")
  filesystem_consolidated_table = consolidate_table(samples, workloads, scenarios,"filesystem",metrics)
  filesystem_consolidated_table <- filesystem_consolidated_table %>% 
    mutate(across(.cols = c(disk_usage_result), .fns = ~.x /1024/1024))  
  
  figDiskUsage.scenario <- ggplot(filesystem_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=disk_usage_result)) +
    geom_boxplot() +
    facet_wrap(~workload, scales = "free") +
    ggtitle("Disk Usage x Scenario") + 
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
  
  pdf("graphics_and_tables/disk_usage_scenario.pdf", width = 16, height = 9)
  print(figDiskUsage.scenario)  
  consolidated_table_summary <- consolidate_summary(filesystem_consolidated_table, filesystem_consolidated_table$disk_usage_result, workloads, scenarios)
  write.table(consolidated_table_summary, "graphics_and_tables/summarized_disk_usage.csv", sep=",",row.names=FALSE)
  dev.off()
  dev.off()  
  