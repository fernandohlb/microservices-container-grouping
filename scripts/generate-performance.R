setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results")
library("ggplot2")
library("dplyr")
library("anytime")
library("readr")
source("results_functions.R")

      with_hpa = FALSE
      
      if (with_hpa) {
        origem_folder = "raw_results_distributed"
        destination_folder_consolidated = "graphics_and_tables_consolidated/performance/with_hpa"
        destination_folder_by_time = "graphics_and_tables_by_time/performance/with_hpa"
      } else {
        origem_folder = "raw_results"
        destination_folder_consolidated = "graphics_and_tables_consolidated/performance/not_hpa"
        destination_folder_by_time = "graphics_and_tables_by_time/performance/not_hpa"
      }

      workloads <- c("300","2400","4500")
      scenarios <- c("benchmark","all-in-one","by-stack","by-dependencies")
      samples <- 1:6
      consolidated_table_by_time = data.frame()
      consolidated_table = data.frame()
      
      for(sample in samples) {
        for(workload in workloads) {
          for(scenario in scenarios) {
            
            #Leitura das informações distribuidas no tempo:
            file2 <- paste(origem_folder,"/",sample,"/", workload,"/", scenario, "/results_stats_history_v2.csv",sep = "")
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
            # Cria a coluna segundos
            file_table <- file_table %>%
              arrange(Timestamp) %>%
              mutate(seconds = as.numeric(Timestamp - first(Timestamp)))
            
            consolidated_table = rbind(consolidated_table,file_table)
            
 
            
            # Ordenar o dataset pelo timestamp
            file_table <- file_table[order(file_table$Timestamp),]
            
            # Encontrar o tempo da primeira linha
            first_timestamp <- file_table$Timestamp[1]
            
            # Calcular o intervalo de 30 segundos
            interval <- 60
            
            # Calcular os tempos de início dos intervalos
            end_time <- max(file_table$Timestamp)
            start_times <- seq(from = first_timestamp, to = end_time, by = interval)
            
            # Adicionar o tempo máximo, caso não esteja já incluso
            if (!(end_time %in% start_times)) {
              if(length(start_times)==10) {
                start_times <- c(start_times, end_time)
              }
            }
            
            # Filtrar as linhas com base nos tempos de início dos intervalos
            file_table <- file_table %>%
              filter(Timestamp %in% start_times)
            
            # # Arredonda os segundos do ultimo valor caso não esteja correto
            # if (as.numeric(end_time - first_timestamp) != 10){
            #   end_time <- end_time + 01
            #   file_table$Timestamp[11] <- end_time
            # }
            
            # Cria a coluna segundos
            file_table <- file_table %>%
              arrange(Timestamp) %>%
              mutate(seconds = as.numeric(Timestamp - first(Timestamp)), seconds = if_else(seconds %% 60 != 0, (seconds - seconds %% 60)+60 , (seconds - seconds %% 60)))
                     
            consolidated_table_by_time = rbind(consolidated_table_by_time,file_table)
            
            #Leitura das informações consolidadas
            # file <- paste(origem_folder,"/",sample,"/", workload,"/", scenario, "/results_stats.csv",sep = "")
            # file_table = read.table(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)
            # file_table$workload <- strtoi(workload)
            # file_table$scenario <- scenario
            # file_table$sample <- sample
            # file_table = file_table %>% filter(Name == 'Aggregated')
            # consolidated_table = rbind(consolidated_table,file_table)
          }
        }
      }
      
      #Exclude warmup time
      #filtered_consolidated_table <- consolidated_table[consolidated_table$seconds >= 300,]
      filtered_consolidated_table <- consolidated_table_by_time
      # summarized_consolidated_table<- filtered_consolidated_table %>%
      #   group_by(workload,scenario,sample) %>%
      #   summarise(Requests.s.Median = median(Requests.s),
      #             Failures.s.Median = median(Failures.s),
      #             Percentil_50 = quantile(X100., 0.5),
      #             Percentil_66 = quantile(X100., 0.66),
      #             Percentil_75 = quantile(X100., 0.75),
      #             Percentil_80 = quantile(X100., 0.80),
      #             Percentil_90 = quantile(X100., 0.90),
      #             Percentil_95 = quantile(X100., 0.95),
      #             Percentil_98 = quantile(X100., 0.98),
      #             Percentil_99 = quantile(X100., 0.99),
      #             Percentil_9999 = quantile(X100., 0.9999),
      #             Percentil_100 = quantile(X100., 1))
      # 
      # max_average_respone_time <- filtered_consolidated_table %>%
      #   group_by(workload,scenario,sample) %>%
      #   filter(seconds == max(seconds)) %>%
      #   select(workload, scenario,sample,Total.Median.Response.Time)
      # 
      # filtered_consolidated_table <- summarized_consolidated_table %>%
      #   left_join(max_average_respone_time, join_by ("workload", "scenario", "sample"))
      
  ######################### REPONSE TIME RESULTS #########################
  
    ######################### GENERATE CONSOLIDATED RESULTS#######################
  
  figResponseTimeScenario <- ggplot(filtered_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=Total.Average.Response.Time)) +
    geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
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
  
  pdf_file = paste(destination_folder_consolidated,"/response_time_scenarios.pdf",sep = "")
  table_file = paste(destination_folder_consolidated,"/summarized_response_time.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_consolidated,"/response_time_scenarios_hpa.pdf",sep = "")
    table_file = paste(destination_folder_consolidated,"/summarized_response_time_hpa.csv",sep = "")
  }
  
  
  pdf(pdf_file, width = 16, height = 9)
  print(figResponseTimeScenario)
  response_time_summarized_table = consolidate_summary(filtered_consolidated_table,filtered_consolidated_table$Total.Average.Response.Time,workloads,scenarios)
  write.table(response_time_summarized_table, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  ######################## GENERATE RESULTS BY TIME ############################
  #Generate graphic with boxplots
  figResponseTimeScenario <- ggplot(consolidated_table_by_time, aes(x=factor(seconds), y=Total.Average.Response.Time, color = factor(scenario))) +
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
    ylab("Response Time(ms)")+
    guides(color = guide_legend(title="Workload")) + 
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
  pdf_file = paste(destination_folder_by_time,"/response_time_scenarios.pdf",sep = "")
  table_file = paste(destination_folder_by_time,"/summarized_response_time.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_by_time,"/response_time_scenarios_hpa.pdf",sep = "")
    table_file = paste(destination_folder_by_time,"/summarized_response_time_hpa.csv",sep = "")
  }
  pdf(pdf_file, width = 16, height = 9)
  print(figResponseTimeScenario)
  response_time_summarized_table = consolidate_summary_v2(consolidated_table_by_time,consolidated_table_by_time$Total.Average.Response.Time,workloads,scenarios)
  write.table(response_time_summarized_table, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  #### Generate Consolidated Response Time median percentiles graphic metric ####
  summarized_table <- filtered_consolidated_table %>% group_by(workload,scenario) %>%
    summarize("50%ile(ms)"=quantile(Total.Average.Response.Time, 0.5),
              "66%ile(ms)"=quantile(Total.Average.Response.Time, 0.66),
              "75%ile(ms)"=quantile(Total.Average.Response.Time, 0.75),
              "80%ile(ms)"=quantile(Total.Average.Response.Time, 0.80),
              "90%ile(ms)"=quantile(Total.Average.Response.Time, 0.90),
              "95%ile(ms)"=quantile(Total.Average.Response.Time, 0.95),
              "99%ile(ms)"=quantile(Total.Average.Response.Time, 0.99))
  
  table_file = paste(destination_folder_consolidated,"/response_time_median_percentile.csv",sep = "")
  write.table(summarized_table, table_file, sep=",", row.names=FALSE)

  #### Generate by time Response Time median percentiles graphic metric ####
  summarized_table <- consolidated_table_by_time %>% group_by(workload,scenario,seconds)%>%
    summarize("50%ile(ms)"=quantile(Total.Average.Response.Time, 0.5),
              "66%ile(ms)"=quantile(Total.Average.Response.Time, 0.66),
              "75%ile(ms)"=quantile(Total.Average.Response.Time, 0.75),
              "80%ile(ms)"=quantile(Total.Average.Response.Time, 0.80),
              "90%ile(ms)"=quantile(Total.Average.Response.Time, 0.90),
              "95%ile(ms)"=quantile(Total.Average.Response.Time, 0.95),
              "99%ile(ms)"=quantile(Total.Average.Response.Time, 0.99))
  
  table_file = paste(destination_folder_by_time,"/response_time_median_percentile.csv",sep = "")
  write.table(summarized_table, table_file, sep=",", row.names=FALSE)
  
  #filtered_consolidated_table <- consolidated_table[consolidated_table$seconds >= 300,]  
  
  ######################### REQUESTS PER SECOND RESULTS #########################
  
  ######################### GENERATE CONSOLIDATED RESULTS#######################
  
  #Generate graphic with boxplot
  figRequests.s.scenario <- ggplot(filtered_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=Requests.s)) +
    geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
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
  pdf_file = paste(destination_folder_consolidated,"/requests_s_scenario.pdf",sep = "")
  table_file = paste(destination_folder_consolidated,"/summarized_requests_s.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_consolidated,"/requests_s_scenario_hpa.pdf",sep = "")
    table_file = paste(destination_folder_consolidated,"/summarized_requests_s_hpa.csv",sep = "")
  }
  
  
  pdf(pdf_file, width = 16, height = 9)
  print(figRequests.s.scenario)
  requests_s_summarized_table = consolidate_summary(filtered_consolidated_table,filtered_consolidated_table$Requests.s,workloads,scenarios)
  write.table(requests_s_summarized_table, table_file, sep=",",row.names=FALSE)
  dev.off()
  
  ######################## GENERATE RESULTS BY TIME ############################
  #Generate graphic with boxplots
  figRequests.s.scenario <- ggplot(consolidated_table_by_time, aes(x=factor(seconds), y=Requests.s, color = factor(scenario))) +
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
  
  pdf_file = paste(destination_folder_by_time,"/requests_s_scenario.pdf",sep = "")
  table_file = paste(destination_folder_by_time,"/summarized_requests_s.csv",sep = "")
  
  if (with_hpa) {
    pdf_file = paste(destination_folder_by_time,"/requests_s_scenario_hpa.pdf",sep = "")
    table_file = paste(destination_folder_by_time,"/summarized_requests_s_hpa.csv",sep = "")
  }
  pdf(pdf_file, width = 16, height = 9)
  print(figRequests.s.scenario)
  requests_s_summarized_table = consolidate_summary_v2(consolidated_table_by_time,consolidated_table_by_time$Requests.s,workloads,scenarios)
  write.table(requests_s_summarized_table, table_file, sep=",",row.names=FALSE)
  dev.off()  
  
  ######################### FAILURES PER SECOND RESULTS #########################
  
    ######################### GENERATE CONSOLIDATED RESULTS#######################
    figFailures.s.scenario <- ggplot(filtered_consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=Failures.s)) +
      geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
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
    
    pdf_file = paste(destination_folder_consolidated,"/failures_s_scenarios.pdf",sep = "")
    table_file = paste(destination_folder_consolidated,"/summarized_failures_s_scenario.csv",sep = "")
    
    if (with_hpa) {
      pdf_file = paste(destination_folder_consolidated,"/failures_s_scenarios_hpa.pdf",sep = "")
      table_file = paste(destination_folder_consolidated,"/summarized_failures_s_scenarios_hpa.csv",sep = "")
    }
    
    pdf(pdf_file, width = 16, height = 9)
    print(figFailures.s.scenario)
    failures_per_second_summarized_table = consolidate_summary(filtered_consolidated_table,filtered_consolidated_table$Failures.s,workloads,scenarios)
    write.table(failures_per_second_summarized_table, table_file, sep=",",row.names=FALSE)
    dev.off()
  
    #filtered_consolidated_table <- consolidated_table[consolidated_table$seconds >= 300,]
    ######################## GENERATE RESULTS BY TIME ############################    
    figFailures.s.scenario <- ggplot(consolidated_table_by_time, aes(x=factor(seconds), y=Failures.s, color = factor(scenario))) +
      geom_boxplot(position = position_dodge(width = 0.9), outliers = FALSE) +
      stat_summary(
        fun = median,
        geom = 'line',
        aes(group = scenario, colour = factor(scenario)),
        position = position_dodge(width = 0.9) #this has to be added
      ) +    
      facet_wrap(~workload,ncol=1, scales = "free", labeller = as_labeller(c('300'='Low', '2400'='Medium', '4500'='High'))) +
      #ggtitle("Failures/s x Scenario") + 
      xlab("Seconds") +
      ylab("Failures per second")+
      guides(color = guide_legend(title="Workload")) + 
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
    
      pdf_file = paste(destination_folder_by_time,"/failures_s_scenarios.pdf",sep = "")
      table_file = paste(destination_folder_by_time,"/summarized_failures_s_scenario.csv",sep = "")
      
      if (with_hpa) {
        pdf_file = paste(destination_folder_by_time,"/failures_s_scenarios_hpa.pdf",sep = "")
        table_file = paste(destination_folder_by_time,"/summarized_failures_s_scenarios_hpa.csv",sep = "")
      }
    
    
      pdf(pdf_file, width = 16, height = 9)
      print(figFailures.s.scenario)
      failures_per_second_summarized_table = consolidate_summary_v2(consolidated_table_by_time,consolidated_table_by_time$Failures.s,workloads,scenarios)
      write.table(failures_per_second_summarized_table, table_file, sep=",",row.names=FALSE)
      dev.off()
  
  