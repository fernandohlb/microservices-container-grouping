setwd("~/Documentos/Mestrado/microservices-container-grouping/experiments_results")
library("ggplot2")
library(dplyr)
library(rlang)
source("results_functions.R")
library(scales)

with_hpa = TRUE
workloads <- c("300", "2400","4500")
scenarios <- c("benchmark","all-in-one","by-stack","by-dependencies")
samples <- 1:6

if (with_hpa) {
  origem_folder = "raw_results_distributed"
  destination_folder_consolidated = "graphics_and_tables_consolidated/availability/with_hpa"
  destination_folder_by_time = "graphics_and_tables_by_time/availability/with_hpa"
} else {
  origem_folder = "raw_results"
  destination_folder_consolidated = "graphics_and_tables_consolidated/availability/not_hpa"
  destination_folder_by_time = "graphics_and_tables_by_time/availability/not_hpa"
  
}

availability_error_consolidated_table = data.frame()

availability_time_consolidated_table = data_frame()
# colunas<- c("Time", "workload", "scenario", "sample", "total_inactive_duration", "seconds", "availability_time_percentage")
# availability_time_consolidated_table = data.frame(matrix(ncol = length(colunas)))
# colnames(availability_time_consolidated_table) <- colunas

# sample = 2
# workload = "4500"
# scenario = "benchmark"
for(sample in samples) {
  for(workload in workloads) {
    for(scenario in scenarios) {
      file2 <- paste(origem_folder,"/",sample,"/", workload,"/", scenario, "/results_stats_history.csv_v2",sep = "")
      if (!file.exists(file2)) {
        file <- paste(origem_folder,"/",sample,"/", workload,"/", scenario, "/results_stats_history.csv",sep = "")
        file_table = read.table(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)
        file_table <- file_table %>%mutate_all(~ifelse(. == "N/A", 0, .))
        write.table(file_table, file2, sep=",",row.names=FALSE)
      }
      file_table = read.table(file2, header = TRUE, sep = ",", stringsAsFactors = FALSE)
      file_table$workload <- strtoi(workload)
      file_table$scenario <- scenario
      file_table$sample <- sample
      file_table = file_table %>% filter(Name == 'Aggregated')
      file_table$Timestamp <- as.POSIXct(file_table$Timestamp)
      
      file_table <- convert_timestamp_seconds(file_table, "Timestamp",15)
      
      #Calculate Availability by Error
      file_table$availability_error_percentage = ifelse(file_table$Total.Failure.Count!=0,round(((file_table$Total.Request.Count - file_table$Total.Failure.Count)/file_table$Total.Request.Count)*100,2),100)
      availability_error_consolidated_table = rbind(availability_error_consolidated_table,file_table)
      
      print(sample)
      print(workload)
      print(scenario)
      
      if (workload == "300") {
        next
      }
      
      if (workload == "2400" && !with_hpa) {
        next
      }
      print("###################################################################################################################################################################################################")
      print(sample)
      print(workload)
      print(scenario)
        
      file <- paste(origem_folder,"/",sample,"/", workload,"/", scenario, "/","availability-time",".csv",sep = "")
      file_table = read.table(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)
      file_table$workload <- strtoi(workload)
      file_table$scenario <- scenario
      file_table$sample <- sample
      file_table$Time <- as.POSIXct(file_table$Time)
      file_table$total_inactive_duration = 0
      
      inactive_duration = 0
      for (i in 1:nrow(file_table)) {
        current_timestamp <- file_table$Time[i]
        if (i != nrow(file_table)) {
          next_timestamp <- file_table$Time[i+1] 
        } else {
          next_timestamp <- current_timestamp + 15
        }
        component_states <- file_table[i, -1] # Exclude the Timestamp column
        component_states <- component_states[, -ncol(component_states)] # Exclude the inactive duration column
        if (any(component_states == 0)) {
          inactive_duration = inactive_duration + as.numeric(difftime(next_timestamp, current_timestamp, units = "secs"))
          file_table[i, "total_inactive_duration"] = inactive_duration
        } else {
          inactive_duration = 0
        }
      }
      
      
      file_table <- convert_timestamp_seconds(file_table, "Time",15)
      
      #Calculate Availability by Time
      file_table$availability_time_percentage = ifelse(file_table$total_inactive_duration!=0,round(((file_table$seconds - file_table$total_inactive_duration)/file_table$seconds)*100,2),100)
      columns_needed <- c("Time", "workload", "scenario", "sample", "total_inactive_duration", "seconds", "availability_time_percentage")
      file_table <- file_table[, columns_needed]
      
      availability_time_consolidated_table = rbind(availability_time_consolidated_table,file_table)
    
   
  }
 }
}

merged_availability_tables <- merge(availability_error_consolidated_table,availability_time_consolidated_table, by=c("workload","scenario","sample","seconds"), all=TRUE)
merged_availability_tables$availability_error_percentage[is.na(merged_availability_tables$availability_error_percentage)] <- 100
merged_availability_tables$availability_time_percentage[is.na(merged_availability_tables$availability_time_percentage)] <- 100
merged_availability_tables$total_availability <- with(merged_availability_tables, (availability_error_percentage + availability_time_percentage)/2)


#Exclude warmup time
filtered_merged_availability_tables <- merged_availability_tables


######################## GENERATE RESULTS BY TIME ############################
#Total
figAvailabilityTotal <- ggplot(merged_availability_tables, aes(x=factor(seconds), y=total_availability, color = factor(scenario))) +
  geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
  coord_cartesian(ylim = c(0, 100)) +
  stat_summary(
    fun = median,
    geom = 'line',
    aes(group = scenario, colour = factor(scenario)),
    position = position_dodge(width = 0.9) #this has to be added
  ) +    
  facet_wrap(~workload,ncol=1, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
  #ggtitle("Requests/s x Scenario") + 
  xlab("Seconds") +
  ylab("Availability Error (%)")+
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

pdf_file = paste(destination_folder_by_time,"/availability_total_scenario.pdf",sep = "")
table_file = paste(destination_folder_by_time,"/summarized_availability_total.csv",sep = "")

if (with_hpa) {
  pdf_file = paste(destination_folder_by_time,"/availability_total_scenario_hpa.pdf",sep = "")
  table_file = paste(destination_folder_by_time,"/summarized_availability_total_hpa.csv",sep = "")
}
pdf(pdf_file, width = 16, height = 9)
print(figAvailabilityTotal)
consolidated_table_summary = consolidate_summary_v2(merged_availability_tables,merged_availability_tables$total_availability,workloads,scenarios)
write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
dev.off()

#Error
figAvailabilityTotal <- ggplot(merged_availability_tables, aes(x=factor(seconds), y=availability_error_percentage, color = factor(scenario))) +
  geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
  coord_cartesian(ylim = c(0, 100)) +
  stat_summary(
    fun = median,
    geom = 'line',
    aes(group = scenario, colour = factor(scenario)),
    position = position_dodge(width = 0.9) #this has to be added
  ) +    
  facet_wrap(~workload,ncol=1, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
  #ggtitle("Requests/s x Scenario") + 
  xlab("Seconds") +
  ylab("Availability Error (%)")+
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

pdf_file = paste(destination_folder_by_time,"/availability_error_scenario.pdf",sep = "")
table_file = paste(destination_folder_by_time,"/summarized_availability_error.csv",sep = "")

if (with_hpa) {
  pdf_file = paste(destination_folder_by_time,"/availability_error_scenario_hpa.pdf",sep = "")
  table_file = paste(destination_folder_by_time,"/summarized_availability_error_hpa.csv",sep = "")
}
pdf(pdf_file, width = 16, height = 9)
print(figAvailabilityTotal)
consolidated_table_summary = consolidate_summary_v2(merged_availability_tables,merged_availability_tables$availability_error_percentage,workloads,scenarios)
write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
dev.off()

#Time
figAvailabilityTotal <- ggplot(merged_availability_tables, aes(x=factor(seconds), y=availability_time_percentage, color = factor(scenario))) +
  geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
  coord_cartesian(ylim = c(0, 100)) +
  stat_summary(
    fun = median,
    geom = 'line',
    aes(group = scenario, colour = factor(scenario)),
    position = position_dodge(width = 0.9) #this has to be added
  ) +    
  facet_wrap(~workload,ncol=1, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
  #ggtitle("Requests/s x Scenario") + 
  xlab("Seconds") +
  ylab("Availability Error (%)")+
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

pdf_file = paste(destination_folder_by_time,"/availability_time_scenario.pdf",sep = "")
table_file = paste(destination_folder_by_time,"/summarized_availability_time.csv",sep = "")

if (with_hpa) {
  pdf_file = paste(destination_folder_by_time,"/availability_time_scenario_hpa.pdf",sep = "")
  table_file = paste(destination_folder_by_time,"/summarized_availability_time_hpa.csv",sep = "")
}
pdf(pdf_file, width = 16, height = 9)
print(figAvailabilityTotal)
consolidated_table_summary = consolidate_summary_v2(merged_availability_tables,merged_availability_tables$availability_time_percentage,workloads,scenarios)
write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
dev.off()

# 
# 
# #Exclude warmup time
# filtered_availability_error_consolidated_table <- availability_error_consolidated_table[availability_error_consolidated_table$seconds >= 300,]
# filtered_availability_time_consolidated_table <- availability_time_consolidated_table[availability_time_consolidated_table$seconds >= 300,]
# 
# 
# ######################### GENERATE CONSOLIDATED RESULTS#######################
# 
#  figAvailabilityByError.scenario <- ggplot(filtered_availability_error_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=availability_error_percentage)) +
#                        geom_boxplot() +
#                        scale_y_continuous(labels = function(y) round(y, 2)) +
#                        facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
#                       # ylim(50.00,100.10) + 
#                        # facet_wrap(~workload, scales = "free") +
#                        # ggtitle("Availability By Error Percenatage x Scenario") +
#                        xlab("Grouping Scenarios") +
#                        ylab("Availability By Error (%)")+
#                        guides(color = guide_legend(title="Scenario")) +
#                        theme(plot.title = element_text(hjust = 0.5, vjust = 5, size = 20),
#                              strip.text = element_text(size= 16),
#                              plot.margin = unit(c(1,1,1,1), "cm"),
#                              axis.text = element_text(size = 16),
#                              axis.text.x = element_text(angle = -45),
#                              legend.title = element_text(size = 12),
#                              legend.text = element_text(size = 12),
#                              axis.title = element_text(size = 16),
#                              axis.title.y=element_text(vjust=5),
#                              axis.title.x=element_text(vjust=-5))
#  
#  pdf_file = paste(destination_folder_consolidated,"/availability_error_scenario.pdf",sep = "")
#  table_file = paste(destination_folder_consolidated,"/summarized_availability_error.csv",sep = "")
#  
#  if (with_hpa) {
#    pdf_file = paste(destination_folder_consolidated,"/availability_error_scenario_hpa.pdf",sep = "")
#    table_file = paste(destination_folder_consolidated,"/summarized_availability_error_hpa.csv",sep = "")
#  }
#  
#  
#  pdf(pdf_file, width = 16, height = 9)
#  print(figAvailabilityByError.scenario)
#  consolidated_table_summary = consolidate_summary(filtered_availability_error_consolidated_table,filtered_availability_error_consolidated_table$availability_error_percentage,workloads,scenarios)
#  write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
#  dev.off()
#  
# 
# figAvailabilityByTime.scenario <- ggplot(filtered_availability_time_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=availability_time_percentage)) +
#      geom_boxplot() +
#      facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +     
#      scale_y_continuous(labels = function(y) round(y, 2)) +
#      xlab("Grouping Scenarios") +
#      ylab("Availability By Time (%)")+
#      guides(color = guide_legend(title="Scenario")) +
#      theme(plot.title = element_text(hjust = 0.5, vjust = 5, size = 20),
#            strip.text = element_text(size= 16),
#            plot.margin = unit(c(1,1,1,1), "cm"),
#            axis.text = element_text(size = 16),
#            axis.text.x = element_text(angle = -45),
#            legend.title = element_text(size = 12),
#            legend.text = element_text(size = 12),
#            axis.title = element_text(size = 16),
#            axis.title.y=element_text(vjust=5),
#            axis.title.x=element_text(vjust=-5))
#    
#     pdf_file = paste(destination_folder_consolidated,"/availability_time_scenario.pdf",sep = "")
#     table_file = paste(destination_folder_consolidated,"/summarized_availability_time.csv",sep = "")
#     
#     if (with_hpa) {
#       pdf_file = paste(destination_folder_consolidated,"/availability_time_scenario_hpa.pdf",sep = "")
#       table_file = paste(destination_folder_consolidated,"/summarized_availability_time_hpa.csv",sep = "")
#     }
#     
#     
#     pdf(pdf_file, width = 16, height = 9)
#     print(figAvailabilityByTime.scenario)
#     if (with_hpa) {
#       workloads <- c("2400","4500")
#     } else {
#       workloads <- c("4500")
#     }
#     consolidated_table_summary = consolidate_summary(filtered_availability_time_consolidated_table,filtered_availability_time_consolidated_table$availability_time_percentage,workloads,scenarios)
#     write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
#     dev.off()
#     
#     ######################## GENERATE RESULTS BY TIME ############################
#     #Generate graphic with boxplots
#     figAvailabilityByError.scenario <- ggplot(availability_error_consolidated_table, aes(x=factor(seconds), y=availability_error_percentage, color = factor(scenario))) +
#       geom_boxplot(position = position_dodge(width = 0.9)) +
#       stat_summary(
#         fun = median,
#         geom = 'line',
#         aes(group = scenario, colour = factor(scenario)),
#         position = position_dodge(width = 0.9) #this has to be added
#       ) +    
#       facet_wrap(~workload,ncol=1, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
#       #ggtitle("Requests/s x Scenario") + 
#       xlab("Seconds") +
#       ylab("Availability Error (%)")+
#       guides(color = guide_legend(title="Scenario")) + 
#       theme(plot.title = element_text(hjust = 0.5, vjust = 5, size = 20),
#             strip.text = element_text(size= 20),
#             plot.margin = unit(c(1,1,1,1), "cm"),
#             axis.text = element_text(size = 16),
#             axis.text.x = element_text(angle = -45), 
#             legend.title = element_text(size = 14),
#             legend.text = element_text(size = 12),
#             axis.title = element_text(size = 16),
#             axis.title.y=element_text(vjust=5),
#             axis.title.x=element_text(vjust=-5))    
#     
#     pdf_file = paste(destination_folder_by_time,"/availability_error_scenario.pdf",sep = "")
#     table_file = paste(destination_folder_by_time,"/summarized_availability_error.csv",sep = "")
#     
#     if (with_hpa) {
#       pdf_file = paste(destination_folder_by_time,"/availability_error_scenario_hpa.pdf",sep = "")
#       table_file = paste(destination_folder_by_time,"/summarized_availability_error_hpa.csv",sep = "")
#     }
#     pdf(pdf_file, width = 16, height = 9)
#     print(figAvailabilityByError.scenario)
#     consolidated_table_summary = consolidate_summary_v2(availability_error_consolidated_table,availability_error_consolidated_table$availability_error_percentage,workloads,scenarios)
#     write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
#     dev.off()
#     
#     figAvailabilityByTime.scenario <- ggplot(availability_time_consolidated_table, aes(x=factor(seconds), y=availability_time_percentage, color = factor(scenario))) +
#       geom_boxplot(position = position_dodge(width = 0.9)) +
#       stat_summary(
#         fun = median,
#         geom = 'line',
#         aes(group = scenario, colour = factor(scenario)),
#         position = position_dodge(width = 0.9) #this has to be added
#       ) +    
#       facet_wrap(~workload,ncol=1, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
#       #ggtitle("Requests/s x Scenario") + 
#       xlab("Seconds") +
#       ylab("Availability Time (%)")+
#       guides(color = guide_legend(title="Scenario")) + 
#       theme(plot.title = element_text(hjust = 0.5, vjust = 5, size = 20),
#             strip.text = element_text(size= 20),
#             plot.margin = unit(c(1,1,1,1), "cm"),
#             axis.text = element_text(size = 16),
#             axis.text.x = element_text(angle = -45), 
#             legend.title = element_text(size = 14),
#             legend.text = element_text(size = 12),
#             axis.title = element_text(size = 16),
#             axis.title.y=element_text(vjust=5),
#             axis.title.x=element_text(vjust=-5))    
#     
#     pdf_file = paste(destination_folder_by_time,"/availability_time_scenario.pdf",sep = "")
#     table_file = paste(destination_folder_by_time,"/summarized_availability_time.csv",sep = "")
#     
#     if (with_hpa) {
#       pdf_file = paste(destination_folder_by_time,"/availability_time_scenario_hpa.pdf",sep = "")
#       table_file = paste(destination_folder_by_time,"/summarized_availability_time_hpa.csv",sep = "")
#     }
#     pdf(pdf_file, width = 16, height = 9)
#     print(figAvailabilityByTime.scenario)
#     consolidated_table_summary = consolidate_summary_v2(availability_time_consolidated_table,availability_time_consolidated_table$availability_time_percentage,workloads,scenarios)
#     write.table(consolidated_table_summary, table_file, sep=",",row.names=FALSE)
#     dev.off()
#     

