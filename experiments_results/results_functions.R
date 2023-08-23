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

consolidate_table <- function(samples, workloads, scenarios,file.name,metrics) {
  df = data.frame()
  for(sample in samples) {
    for(workload in workloads) {
      for(scenario in scenarios) {
        #consolidate data table
        file <- paste("raw_results/",sample,"/", workload,"/", scenario, "/",file.name,".csv",sep = "")
        file_table = read.table(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)
        #f1 <- function(dat, n) if(n <= 0) dat else tail(dat, -n)
        
        #file_table <- f1(file_table,10)
        
        file_table <- file_table %>% select(-Time)
        columnames_vector<-vector()
        for (metric in metrics){
          columnames_vector <- c(columnames_vector, paste(metric,"_result",sep = ""))
        }
        colnames(file_table) <- columnames_vector
        #colnames(file_table) <- c(paste(metric,"_usage",sep = ""))
        file_table$workload <- strtoi(workload)
        file_table$scenario <- scenario
        df = rbind(df,file_table)
        print(sample)
        print(workload)
        print(scenario)
      }
    }
  }
  return(df)
}
