setwd("~/Documentos/Mestrado/microservices-container-grouping/experiments_results")
library("ggplot2")
library(dplyr)
source("results_functions.R")

with_hpa = TRUE
workloads <- c("300", "2400","4500")
scenarios <- c("benchmark","all-in-one","by-stack","by-dependencies")
samples <- 1:6

if (with_hpa) {
  origem_folder = "raw_results_distributed"
  destination_folder_consolidated = "graphics_and_tables_consolidated/availability/with_hpa"
} else {
  origem_folder = "raw_results"
  destination_folder_consolidated = "graphics_and_tables_consolidated/availability/not_hpa"
}

availability_table = data.frame()

for(sample in samples) {
  for(workload in workloads) {
    for(scenario in scenarios) {
      colunas<- c("workload","scenario", "sample", "total_requests","total_errors","total_time","total_inactive_duration","total_pod_restarts")
      tdf = data.frame(matrix(ncol = length(colunas)))
      colnames(tdf) <- colunas
      
      file <- paste(origem_folder,"/",sample,"/", workload,"/", scenario, "/results_stats.csv",sep = "")
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
        file <- paste(origem_folder,"/",sample,"/", workload,"/", scenario, "/","availability-time",".csv",sep = "")
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
availability_table$availability_total_percentage = round(((availability_table$availability_error_percentage + availability_table$availability_time_percentage)/2),2)


#Error
 figAvailabilityByError.scenario <- ggplot(availability_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=availability_error_percentage)) +
                       geom_boxplot() +
                       scale_y_continuous(labels = function(y) round(y, 2)) +
                       facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
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
 
   pdf_file = paste(destination_folder_consolidated,"/availability_error_scenario.pdf",sep = "")
   table_file = paste(destination_folder_consolidated,"/summarized_availability_error.csv",sep = "")
   
   if (with_hpa) {
     pdf_file = paste(destination_folder_consolidated,"/availability_error_scenario_hpa.pdf",sep = "")
     table_file = paste(destination_folder_consolidated,"/summarized_availability_error_hpa.csv",sep = "")
   }
 

   pdf(pdf_file, width = 16, height = 9)
   print(figAvailabilityByError.scenario)
   consolidated_table_summary <- consolidate_summary(availability_table, availability_table$availability_error_percentage, workloads, scenarios)
   write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
   dev.off()
   
   #Time   
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
   
   pdf_file = paste(destination_folder_consolidated,"/availability_time_scenario.pdf",sep = "")
   table_file = paste(destination_folder_consolidated,"/summarized_availability_time.csv",sep = "")
   
   if (with_hpa) {
     pdf_file = paste(destination_folder_consolidated,"/availability_time_scenario_hpa.pdf",sep = "")
     table_file = paste(destination_folder_consolidated,"/summarized_availability_time_hpa.csv",sep = "")
   }
   
   
   pdf(pdf_file, width = 16, height = 9)
   print(figAvailabilityByTime.scenario)
   consolidated_table_summary <- consolidate_summary(availability_table, availability_table$availability_time_percentage, workloads, scenarios)
   write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
   dev.off()
   
   #Total Average
   figAvailabilityTotal.scenario <- ggplot(availability_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=availability_total_percentage)) +
     geom_boxplot() +
     facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +     
     scale_y_continuous(labels = function(y) round(y, 2)) +
     # ylim(50.00,100.10) + 
     # facet_wrap(~workload, scales = "free") +
     # ggtitle("Availability By Time Percenatage x Scenario") +
     xlab("Grouping Scenarios") +
     ylab("Availability Total (%)")+
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
   
   pdf_file = paste(destination_folder_consolidated,"/availability_total_scenario.pdf",sep = "")
   table_file = paste(destination_folder_consolidated,"/summarized_availability_total.csv",sep = "")
   
   if (with_hpa) {
     pdf_file = paste(destination_folder_consolidated,"/availability_total_scenario_hpa.pdf",sep = "")
     table_file = paste(destination_folder_consolidated,"/summarized_availability_total_hpa.csv",sep = "")
   }
   
   
   pdf(pdf_file, width = 16, height = 9)
   print(figAvailabilityTotal.scenario)
   consolidated_table_summary <- consolidate_summary(availability_table, availability_table$availability_total_percentage, workloads, scenarios)
   write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
   dev.off()   
   
 