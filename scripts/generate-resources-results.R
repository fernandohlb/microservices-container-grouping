setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results")
library("ggplot2")
library(dplyr)

  dates <- c("raw_results")
  workloads <- c("300", "2400","4500")
  scenarios <- c("benchmark","all-in-one","by-stack","by-dependencies")
  samples <- 1:6
  consolidated_table = data.frame()
  
  for (date in dates) {
    for(sample in samples) {
      for(workload in workloads) {
        for(scenario in scenarios) {
          file <- paste(date,"/",sample,"/", workload,"/", scenario, "/results_stats.csv",sep = "")
          file_table = read.table(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)
          file_table <- file_table[17, ]
          file_table$workload <- strtoi(workload)
          file_table$scenario <- scenario
          
          consolidated_table = rbind(consolidated_table,file_table)
        }
      }
    }
  }
  
  
  consolidated_table <- consolidated_table[,c(-1,-2)]
  summarized_table <- consolidated_table %>% group_by(workload,scenario) %>%
    summarize(Min=min(Requests.s),
              FQ=quantile(Requests.s,probs=0.25),
              MD=median(Requests.s),
              TQ=quantile(Requests.s,probs=0.75),
              Max=max(Requests.s))
 
  write.table(summarized_table, "graphics_and_tables/summarized_requests_s.csv", sep=",",row.names=FALSE)
  
  figRequests.s.scenario <- ggplot(consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=Requests.s)) +
                      geom_boxplot() +
                      facet_wrap(~workload, scales = "free") +
                      ggtitle("Requests/s x Scenario") + 
                      xlab("Grouping Scenarios") +
                      ylab("Requests/s")+
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
  #png("graphics_and_tables/requests_s_scenario.png",width = 1366, height = 704)
  pdf("graphics_and_tables/requests_s_scenario.pdf", width = 16, height = 9)
  print(figRequests.s.scenario)
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
  #png("graphics_and_tables/requests_s_workload.png",width = 1366, height = 704)
  pdf("graphics_and_tables/requests_s_workload.pdf", width = 16, height = 9)
  print(figRequests.s.workload)
  dev.off()
  
  #### Generate the Response Time graphic metric ####
  summarized_table <- consolidated_table %>% group_by(workload,scenario) %>%
    summarize(Min=min(Average.Response.Time),
              FQ=quantile(Average.Response.Time,probs=0.25),
              MD=median(Average.Response.Time),
              TQ=quantile(Average.Response.Time,probs=0.75),
              Max=max(Average.Response.Time))
  
  write.table(summarized_table, "graphics_and_tables/summarized_response_time.csv", sep=",", row.names=FALSE)
  
  figResponseTimeScenario <- ggplot(consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=Average.Response.Time)) +
    geom_boxplot() +
    facet_wrap(~workload, scales = "free") +
    ggtitle("Response Time x Scenarios") + 
    xlab("Grouping Scenarios") +
    ylab("Response Time ms")+
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
  
  #png("graphics_and_tables/response_time.png",width = 1366, height = 704)
  pdf("graphics_and_tables/response_time_scenarios.pdf", width = 16, height = 9)
  print(figResponseTimeScenario)
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
  
  write.table(summarized_table, "graphics_and_tables/response_time_median_percentile.csv", sep=",", row.names=FALSE)
  
  # #### Generate the Response Time (80th Percentile) graphic metric ####
  # summarized_table <- consolidated_table %>% group_by(workload,scenario) %>%
  #   summarize(Min=min(X80.),
  #             FQ=quantile(X80.,probs=0.25),
  #             MD=median(X80.),
  #             TQ=quantile(X80.,probs=0.75),
  #             Max=max(X80.))
  # 
  # write.table(summarized_table, "graphics_and_tables/summarized_response_time_percentile80.csv", sep=",", row.names=FALSE)
  # 
  # figResponseTimePercentileScenario <- ggplot(consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=X80.)) +
  #   geom_boxplot() +
  #   facet_wrap(~workload, scales = "free") +
  #   ggtitle("Response Time (80th percentile) x Scenarios") + 
  #   xlab("Grouping Scenarios") +
  #   ylab("Response Time (80th Percentile) ms")+
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
  # #png("graphics_and_tables/response_time_80_percentile.png",width = 1366, height = 704)
  # pdf("graphics_and_tables/response_time_80_percentile_scenarios.pdf", width = 16, height = 9)
  # print(figResponseTimePercentileScenario)
  # dev.off()
  # 
  #### Generate the Failures/s graphic metric ####
  summarized_table <- consolidated_table %>% group_by(workload,scenario) %>%
    summarize(Min=min(Failures.s),
              FQ=quantile(Failures.s,probs=0.25),
              MD=median(Failures.s),
              TQ=quantile(Failures.s,probs=0.75),
              Max=max(Failures.s))

  write.table(summarized_table, "graphics_and_tables/summarized_failures_s_scenario.csv", sep=",", row.names=FALSE)

  figFailures.s.scenario <- ggplot(consolidated_table, aes(x=factor(scenario, level=c('benchmark', 'all-in-one', 'by-stack','by-dependencies')), y=Failures.s)) +
    geom_boxplot() +
    facet_wrap(~workload, scales = "free") +
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
  
    pdf("graphics_and_tables/failures_s_scenarios.pdf", width = 16, height = 9)
    print(figFailures.s.scenario)
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
    #png("graphics_and_tables/requests_s_workload.png",width = 1366, height = 704)
    pdf("graphics_and_tables/failures_s_workload.pdf", width = 16, height = 9)
    print(figFailures.s.workload)
    dev.off()
  
  
  