setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results/graphics_and_tables_consolidated/performance/not_hpa")
# Carregar pacotes necessários
library(ggplot2)
library(dplyr)

# Criar o dataframe
data <- data.frame(
  workload = c(300, 300, 300, 300, 2400, 2400, 2400, 2400, 4500, 4500, 4500, 4500),
  workload_desc = c("Low (300 users)", "Low (300 users)", "Low (300 users)", "Low (300 users)", "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)", "High (4500 users)", "High (4500 users)", "High (4500 users)", "High (4500 users)"),
  scenario = c("benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one"),
  Microservices_per_Container_Average = c(1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00),
  Response_Time = c(420, 397, 382, 349, 3602, 3103, 2919, 2754, 6594, 6197, 5838, 5314)
)

# Criar uma nova coluna combinando cenário e média de microservices por container
data <- data %>%
  mutate(Scenario_Microservices = paste(Microservices_per_Container_Average, "\n(", scenario, ")", sep = ""),
         Scenario_Microservices = factor(Scenario_Microservices, levels = unique(Scenario_Microservices[order(Microservices_per_Container_Average)])))

# Gerar o gráfico
fig <- ggplot(data, aes(x = Scenario_Microservices, y = Response_Time, color = factor(workload_desc, levels = unique(workload_desc[order(workload)])))) +
  geom_point(size = 3) +
  geom_line(aes(group = workload)) +
  geom_text(aes(label = Response_Time), vjust = -1, size = 5, show_guide  = FALSE) +  # Adiciona os valores dos pontos
  labs(
    #title = "Median Response Time (ms) vs Microservices per Container",
       x = "Microservices per Container (Average)",
       y = "Response Time (ms)",
       color = "Workload") +
  theme(plot.title = element_text(hjust = 0.5, vjust = 5, size = 20),
        strip.text = element_text(size= 16),
        plot.margin = unit(c(1,1,1,1), "cm"),
        axis.text = element_text(size = 16),
        #axis.text.x = element_text(angle = -45),
        legend.title = element_text(size = 15),
        legend.text = element_text(size = 12),
        axis.title = element_text(size = 16),
        axis.title.y=element_text(vjust=5),
        axis.title.x=element_text(vjust=-5))

pdf_file = paste("resume_response_time_not_hpa.pdf",sep = "")
pdf(pdf_file, width = 16, height = 9)
print(fig)
dev.off()
