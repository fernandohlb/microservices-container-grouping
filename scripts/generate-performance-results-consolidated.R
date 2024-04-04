setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results")
library("ggplot2")
library(dplyr)
source("results_functions.R")

  with_hpa = TRUE
  
  if (with_hpa) {
    origem_folder = "raw_results_distributed"
    destination_folder = "graphics_and_tables_consolidated/performance/with_hpa"
  } else {
    origem_folder = "raw_results"
    destination_folder = "graphics_and_tables_consolidated/performance/not_hpa"
  }


  workloads <- c("300", "2400","4500")
  scenarios <- c("benchmark","all-in-one","by-stack","by-dependencies")
  samples <- 1:6
  consolidated_table = data.frame()
  
    for(sample in samples) {
      for(workload in workloads) {
        for(scenario in scenarios) {
          file <- paste(origem_folder,"/",sample,"/", workload,"/", scenario, "/results_stats.csv",sep = "")
          file_table = read.table(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)
          file_table <- file_table[17, ]
          file_table$workload <- strtoi(workload)
          file_table$scenario <- scenario
          
          consolidated_table = rbind(consolidated_table,file_table)
        }
      }
    }

  consolidated_table <- consolidated_table[,c(-1,-2)]

  ######################### REQUESTS PER SECOND RESULTS #########################
  figRequests.s.scenario <- ggplot(consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=Requests.s)) +
                      geom_boxplot() +
                      facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
                      #ggtitle("Requests/s x Scenario") + 
                      xlab("Grouping Scenarios") +
                      ylab("Requests/s")+
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

  pdf_file = paste(destination_folder,"/requests_s_scenario.pdf",sep = "")
  table_file = paste(destination_folder,"/summarized_requests_s.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder,"/requests_s_scenario_hpa.pdf",sep = "")
    table_file = paste(destination_folder,"/summarized_requests_s_hpa.csv",sep = "")
  }
  
    
  pdf(pdf_file, width = 16, height = 9)
  print(figRequests.s.scenario)
  requests_s_summarized_table = consolidate_summary(consolidated_table,consolidated_table$Requests.s,workloads,scenarios)
  write.table(requests_s_summarized_table, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  
  
  figRequests.s.workload <- ggplot(consolidated_table, aes(x=factor(workload, level=c('300', '2400', '4500')), y=Requests.s)) +
    geom_boxplot() +
    facet_wrap(~scenario, scales = "free") +
    ggtitle("Requests/s x Workload") + 
    xlab("Workload (Users)") +
    ylab("Requests/s")+
    guides(color = guide_legend(title="Scenario")) + 
    theme(plot.title = element_text(hjust = 0.5, vjust = 5, size = 20),
          strip.text = element_text(size= 16),
          plot.margin = unit(c(1,1,1,1), "cm"),
          axis.text = element_text(size = 14),
          legend.title = element_text(size = 12),
          legend.text = element_text(size = 12),
          axis.title = element_text(size = 16),
          axis.title.y=element_text(vjust=5),
          axis.title.x=element_text(vjust=-5))
  
  pdf_file = paste(destination_folder,"/requests_s_workload.pdf",sep = "")
  
  
  if (with_hpa) {
    pdf_file = paste(destination_folder,"/requests_s_workload_hpa.pdf",sep = "")
  }
  
  
  pdf(pdf_file, width = 16, height = 9)
  print(figRequests.s.workload)
  dev.off()
  
  ######################### REPONSE TIME RESULTS #########################

  figResponseTimeScenario <- ggplot(consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=Average.Response.Time)) +
    geom_boxplot() +
    facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    #ggtitle("Response Time x Scenarios") + 
    xlab("Grouping Scenarios") +
    ylab("Response Time ms")+
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
  
  pdf_file = paste(destination_folder,"/response_time_scenarios.pdf",sep = "")
  table_file = paste(destination_folder,"/summarized_response_time.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder,"/response_time_scenarios_hpa.pdf",sep = "")
    table_file = paste(destination_folder,"/summarized_response_time_hpa.csv",sep = "")
  }
  
  pdf(pdf_file, width = 16, height = 9)
  print(figResponseTimeScenario)
  response_time_summarized_table = consolidate_summary(consolidated_table,consolidated_table$Average.Response.Time,workloads,scenarios)
  write.table(response_time_summarized_table, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  #### Generate the Response Time median percentiles graphic metric ####
  summarized_table <- consolidated_table %>% group_by(workload,scenario) %>%
    summarize("50%ile(ms)"=median(X50.),
              "66%ile(ms)"=median(X66.),
              "75%ile(ms)"=median(X75.),
              "80%ile(ms)"=median(X80.),
              "90%ile(ms)"=median(X90.),
              "95%ile(ms)"=median(X95.),
              "99%ile(ms)"=median(X99.))
  
  table_file = paste(destination_folder,"/response_time_median_percentile.csv",sep = "")
  write.table(summarized_table, table_file, sep=",", row.names=FALSE)
  
  
  ######################### FAILURES PER SECOND RESULTS #########################
  figFailures.s.scenario <- ggplot(consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=Failures.s)) +
    geom_boxplot() +
    facet_wrap(~workload, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
    ggtitle("Failures/s x Scenarios") + 
    xlab("Grouping Scenarios") +
    ylab("Failures/s")+
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
  
  pdf_file = paste(destination_folder,"/failures_s_scenarios.pdf",sep = "")
  table_file = paste(destination_folder,"/summarized_failures_s_scenario.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder,"/failures_s_scenarios_hpa.pdf",sep = "")
    table_file = paste(destination_folder,"/summarized_failures_s_scenarios_hpa.csv",sep = "")
  }
  
    pdf(pdf_file, width = 16, height = 9)
    print(figFailures.s.scenario)
    failures_per_second_summarized_table = consolidate_summary(consolidated_table,consolidated_table$Failures.s,workloads,scenarios)
    write.table(failures_per_second_summarized_table, table_file, sep=",",row.names=FALSE)
    dev.off()
  
  
    figFailures.s.workload <- ggplot(consolidated_table, aes(x=factor(workload, level=c('300', '2400', '4500')), y=Failures.s)) +
      geom_boxplot() +
      facet_wrap(~scenario, scales = "free") +
      ggtitle("Failures/s x Workload") + 
      xlab("Workload (Users)") +
      ylab("Failures/s")+
      guides(color = guide_legend(title="Scenario")) + 
      theme(plot.title = element_text(hjust = 0.5, vjust = 5, size = 20),
            strip.text = element_text(size= 16),
            plot.margin = unit(c(1,1,1,1), "cm"),
            axis.text = element_text(size = 14),
            legend.title = element_text(size = 12),
            legend.text = element_text(size = 12),
            axis.title = element_text(size = 16),
            axis.title.y=element_text(vjust=5),
            axis.title.x=element_text(vjust=-5))

    pdf_file = paste(destination_folder,"/failures_s_workload.pdf",sep = "")

    if (with_hpa) {
      pdf_file = paste(destination_folder,"/failures_s_workload_hpa.pdf",sep = "")
    }
    
    pdf(pdf_file, width = 16, height = 9)
    print(figFailures.s.workload)
    dev.off()
  
  
  