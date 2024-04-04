setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results")
library("ggplot2")
library(dplyr)
source("results_functions.R")

workloads <- c("300", "2400","4500")
scenarios <- c("benchmark","all-in-one","by-stack","by-dependencies")
samples <- 1:6
availability_table = data.frame()

for(sample in samples) {
  for(workload in workloads) {
    for(scenario in scenarios) {
      colunas<- c("workload","scenario", "sample", "total_requests","total_errors","total_time","total_inactive_duration","total_pod_restarts")
      tdf = data.frame(matrix(ncol = length(colunas)))
      colnames(tdf) <- colunas
      
      file <- paste("raw_results/",sample,"/", workload,"/", scenario, "/results_stats.csv",sep = "")
      file_table = read.table(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)
      file_table <- file_table[17, ]
      tdf$workload<-strtoi(workload)
      tdf$scenario<-scenario
      tdf$sample<-sample
      tdf$total_requests<-file_table$Request.Count
      tdf$total_errors<-file_table$Failure.Count
      tdf$total_time = 10*60
      if (workload != "4500") {
        tdf$total_inactive_duration = 0
        tdf$total_pod_restarts = 0
      } else {
        file <- paste("raw_results/",sample,"/", workload,"/", scenario, "/","availability-time",".csv",sep = "")
        file_table = read.table(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)
        total_inactive_duration = calculate_inactive_duration(file_table)
        tdf$total_inactive_duration = total_inactive_duration
        
        file <- paste("raw_results/",sample,"/", workload,"/", scenario, "/","pod-restarts",".csv",sep = "")
        file_table = read.table(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)
        restart_columns <- colnames(file_table)[-1] 
        restarts_by_pod <- sapply(file_table[, restart_columns], max)
        restart_totals <- sum (restarts_by_pod)
        tdf$total_pod_restarts = restart_totals
      }
      availability_table = rbind(availability_table,tdf)
    }
  }
}
availability_table$availability_error_percentage = round(((availability_table$total_requests - availability_table$total_errors)/availability_table$total_requests)*100,2)
availability_table$availability_time_percentage = round(((availability_table$total_time - availability_table$total_inactive_duration)/availability_table$total_time)*100,2)




 figAvailabilityByError.scenario <- ggplot(availability_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=availability_error_percentage)) +
                       geom_boxplot() +
                       scale_y_continuous(labels = function(y) round(y, 2)) +
                       facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
                      # ylim(50.00,100.10) + 
                       # facet_wrap(~workload, scales = "free") +
                       # ggtitle("Availability By Error Percenatage x Scenario") +
                       xlab("Grouping Scenarios") +
                       ylab("Availability By Error (%)")+
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

   pdf("graphics_and_tables/availability_error_scenario.pdf", width = 16, height = 9)
   print(figAvailabilityByError.scenario)
   consolidated_table_summary <- consolidate_summary(availability_table, availability_table$availability_error_percentage, workloads, scenarios)
   
   write.table(consolidated_table_summary, "graphics_and_tables/summarized_availability_error.csv", sep=",",row.names=FALSE)
   dev.off()
   
   figAvailabilityByTime.scenario <- ggplot(availability_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=availability_time_percentage)) +
     geom_boxplot() +
     facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +     
     scale_y_continuous(labels = function(y) round(y, 2)) +
     # ylim(50.00,100.10) + 
     # facet_wrap(~workload, scales = "free") +
     # ggtitle("Availability By Time Percenatage x Scenario") +
     xlab("Grouping Scenarios") +
     ylab("Availability By Time (%)")+
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
   
   pdf("graphics_and_tables/availability_time_scenario.pdf", width = 16, height = 9)
   print(figAvailabilityByTime.scenario)
   consolidated_table_summary <- consolidate_summary(availability_table, availability_table$availability_time_percentage, workloads, scenarios)
   
   write.table(consolidated_table_summary, "graphics_and_tables/summarized_availability_time.csv", sep=",",row.names=FALSE)
   dev.off()   
   
   # figPodRestarts.scenario <- ggplot(df, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=restart_totals)) +
   #   geom_boxplot() +
   #   facet_wrap(~workload, scales = "free") +
   #   ggtitle("Pods Restarts x Scenario") +
   #   xlab("Grouping Scenarios") +
   #   ylab("Pods Restarts")+
   #   guides(color = guide_legend(title="Scenario")) +
   #   theme(plot.title = element_text(hjust = 0.5, vjust = 5, size = 20),
   #         strip.text = element_text(size= 16),
   #         plot.margin = unit(c(1,1,1,1), "cm"),
   #         axis.text = element_text(size = 16),
   #         axis.text.x = element_text(angle = -45),
   #         legend.title = element_text(size = 12),
   #         legend.text = element_text(size = 12),
   #         axis.title = element_text(size = 16),
   #         axis.title.y=element_text(vjust=5),
   #         axis.title.x=element_text(vjust=-5))
   # 
   # pdf("graphics_and_tables/pod_restarts_scenario.pdf", width = 16, height = 9)
   # print(figPodRestarts.scenario)
   # consolidated_table_summary <- consolidate_summary(df, df$restart_totals, workloads, scenarios)
   # 
   # write.table(consolidated_table_summary, "graphics_and_tables/summarized_pod_restarts.csv", sep=",",row.names=FALSE)
   # dev.off()
   

   
# 
# 
#   ######################### COSTS RESULTS #########################
#   metrics <- c("costs")
#   costs_consolidated_table = consolidate_table(samples, workloads, scenarios,"costs",metrics)
# 
#   figCostsResult.scenario <- ggplot(costs_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=costs_result)) +
#                       geom_boxplot() +
#                       facet_wrap(~workload, scales = "free") +
#                       ggtitle("Monthly Cost (U$) x Scenario") + 
#                       xlab("Grouping Scenarios") +
#                       ylab("Monthly Cost (U$)")+
#                       guides(color = guide_legend(title="Scenario")) + 
#                       theme(plot.title = element_text(hjust = 0.5, vjust = 5, size = 20),
#                             strip.text = element_text(size= 16),
#                             plot.margin = unit(c(1,1,1,1), "cm"),
#                             axis.text = element_text(size = 16),
#                             axis.text.x = element_text(angle = -45), 
#                             legend.title = element_text(size = 12),
#                             legend.text = element_text(size = 12),
#                             axis.title = element_text(size = 16),
#                             axis.title.y=element_text(vjust=5),
#                             axis.title.x=element_text(vjust=-5))
#   
#   pdf("graphics_and_tables/costs_result_scenario.pdf", width = 16, height = 9)
#   print(figCostsResult.scenario)
#   consolidated_table_summary <- consolidate_summary(costs_consolidated_table, costs_consolidated_table$costs_result, workloads, scenarios)
#   write.table(consolidated_table_summary, "graphics_and_tables/summarized_costs_result.csv", sep=",",row.names=FALSE)
#   dev.off()
#   