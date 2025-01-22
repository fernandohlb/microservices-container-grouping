calculate_inactive_duration <- function(file_table) {
  dataset <- file_table
  
  inactive_periods <- c()  # To store the durations of inactive periods
  inactive_start <- NULL
  for (i in 1:nrow(dataset)) {
    timestamp <- as.POSIXct(dataset$Time[i], format = "%Y-%m-%d %H:%M:%S")
    component_states <- dataset[i, -1]  # Exclude the Timestamp column
    
    if (any(component_states == 0)) {
      if (is.null(inactive_start)) {
        inactive_start <- timestamp
      }
      if (i == nrow(dataset)) {
        inactive_end <- timestamp + 15
        inactive_duration <- as.numeric(difftime(inactive_end, inactive_start, units = "secs"))
        inactive_periods <- c(inactive_periods, inactive_duration)
        inactive_start <- NULL
      }
      
    } else if (!is.null(inactive_start)) {
      inactive_end <- timestamp
      #inactive_duration <- inactive_end - inactive_start
      inactive_duration <- as.numeric(difftime(inactive_end, inactive_start, units = "secs"))
      inactive_periods <- c(inactive_periods, inactive_duration)
      inactive_start <- NULL
    }
  } 
  
  # Calculate the total duration of inactive periods
  total_inactive_duration <- sum(inactive_periods)
}

consolidate_summary_v2 <- function(ct, metric, workloads, scenarios) {
  df = data.frame()
  for (w in workloads)
  {
    for(s in scenarios) {
      cat(sprintf("Scenario: %s\n", s))
      cat(sprintf("Workload: %s\n", w))
      summary<-boxplot(metric~seconds, data = ct, subset = scenario == s & workload == w,plot=FALSE)$stats
      rownames(summary)<-c("Min","First Quartile","Median","Third Quartile","Maximum")
      summary.df<- data.frame(summary)
      summary.df<- t(summary.df)
      summary.df<- data.frame(summary.df)
      summary.df<-cbind(seconds = c(0,60,120,180,240,300,360,420,480,540,600),summary.df)
      summary.df<-cbind(scenario = s, summary.df)
      summary.df<-cbind(workload = w, summary.df)
      
      
      df = rbind(df,summary.df)
    }  
  }
  return(df)
}

consolidate_summary <- function(ct, metric, workloads, scenarios) {
  df = data.frame()
  for (w in workloads)
  {
    for(s in scenarios) {
      summary<-boxplot(metric~workload, data = ct, subset = scenario == s & workload == w,plot=FALSE)$stats
      rownames(summary)<-c("Min","First Quartile","Median","Third Quartile","Maximum")
      summary.df<- data.frame(summary)
      summary.df<- t(summary.df)
      summary.df<- data.frame(summary.df)
      summary.df<-cbind(scenario = s, summary.df)
      summary.df<-cbind(workload = w, summary.df)
      
      df = rbind(df,summary.df)
    }  
  }
  return(df)
}

consolidate_table <- function(origem.folder,samples, workloads, scenarios,file.name,metrics,hpa) {
  df = data.frame()
  for(sample in samples) {
    for(workload in workloads) {
      for(scenario in scenarios) {
        #consolidate data table
        file <- paste(origem.folder,"/",sample,"/", workload,"/", scenario, "/",file.name,".csv",sep = "")
        file_table = read.table(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)
        #f1 <- function(dat, n) if(n <= 0) dat else tail(dat, -n)
        
        #file_table <- f1(file_table,10)
        
        #file_table <- file_table %>% select(-Time)
        columnames_vector<-vector()
        for (metric in metrics){
          columnames_vector <- c(columnames_vector, paste(metric,"_result",sep = ""))
        }
        colnames(file_table) <- columnames_vector
        #colnames(file_table) <- c(paste(metric,"_usage",sep = ""))
        file_table$workload <- strtoi(workload)
        file_table$scenario <- scenario
        file_table$hpa <- hpa
        df = rbind(df,file_table)
        print(sample)
        print(workload)
        print(scenario)
      }
    }
  }
  return(df)
}

convert_timestamp_seconds <- function(file_table,timeColumn,interval) {
  # Ordenar o dataset pelo timestamp
  file_table <- file_table[order(file_table[[timeColumn]]),]
  
  # Encontrar o tempo da primeira linha
  first_timestamp <- file_table[[timeColumn]][1]
  
  # Calcular o intervalo de 30 segundos
  #interval <- 60
  
  # Calcular os tempos de início dos intervalos
  end_time <- max(file_table[[timeColumn]])
  start_times <- seq(from = first_timestamp, to = end_time, by = interval)
  
  # Adicionar o tempo máximo, caso não esteja já incluso
  if (!(end_time %in% start_times)) {
    if(length(start_times)==10) {
      start_times <- c(start_times, end_time)
    }
  }
  
  # Filtrar as linhas com base nos tempos de início dos intervalos
  file_table <- file_table %>%
    filter(!!sym(timeColumn) %in% start_times)
  

  # Cria a coluna segundos
  file_table <- file_table %>%
    arrange(!!sym(timeColumn)) %>%
    mutate(seconds = as.numeric(!!sym(timeColumn) - first(!!sym(timeColumn))), seconds = if_else(seconds %% 60 != 0, (seconds - seconds %% 60)+60 , (seconds - seconds %% 60)))
  
  return (file_table)
  
}

consolidate_table_by_time <- function(origem.folder,samples, workloads, scenarios,file.name,metrics,hpa) {
  df = data.frame()
  for(sample in samples) {
    for(workload in workloads) {
      for(scenario in scenarios) {
        #consolidate data table
        file <- paste(origem.folder,"/",sample,"/", workload,"/", scenario, "/",file.name,".csv",sep = "")
        file_table = read.table(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)
        #f1 <- function(dat, n) if(n <= 0) dat else tail(dat, -n)
        
        #file_table <- f1(file_table,10)
        
        #file_table <- file_table %>% select(-Time)
        columnames_vector<-vector()
        columnames_vector <- c(columnames_vector, "Time")
        for (metric in metrics){
          columnames_vector <- c(columnames_vector, paste(metric,"_result",sep = ""))
        }
        colnames(file_table) <- columnames_vector
        #colnames(file_table) <- c(paste(metric,"_usage",sep = ""))
        
        file_table$workload <- strtoi(workload)
        file_table$scenario <- scenario
        file_table$qtd_microservices_pods <- switch(scenario,
                                              "benchmark" = 8,
                                              "all-in-one" = 1,
                                              "by-stack" = 3,
                                              "by-dependencies" = 6,
                                                0)
        file_table$sample <- sample
        file_table$hpa <- hpa
        file_table$Time <- as.POSIXct(file_table$Time)
        
        # Ordenar o dataset pelo timestamp
        file_table <- file_table[order(file_table$Time),]
        
        # Encontrar o tempo da primeira linha
        first_timestamp <- file_table$Time[1]
        
        # Calcular o intervalo de 30 segundos
        interval <- 60
        
        # Calcular os tempos de início dos intervalos
        end_time <- max(file_table$Time)
        start_times <- seq(from = first_timestamp, to = end_time, by = interval)
        
        # Adicionar o tempo máximo, caso não esteja já incluso
        if (!(end_time %in% start_times)) {
          if(length(start_times)==10) {
            start_times <- c(start_times, end_time)
          }
        }
        
        # Filtrar as linhas com base nos tempos de início dos intervalos
        file_table <- file_table %>%
          filter(Time %in% start_times)
        

        # Cria a coluna segundos
        file_table <- file_table %>%
          arrange(Time) %>%
          mutate(seconds = as.numeric(Time - first(Time)), seconds = if_else(seconds %% 60 != 0, (seconds - seconds %% 60)+60 , (seconds - seconds %% 60)))
        
        df = rbind(df,file_table)
        print(sample)
        print(workload)
        print(scenario)
      }
    }
  }
  return(df)
}
