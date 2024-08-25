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
  Requests_per_s = c(444.1, 476.6, 455, 510, 322.65, 335.25, 354, 382.05, 245.85, 299.05, 305.6, 320.35)
)

# Criar uma nova coluna combinando cenário e média de microservices por container
data <- data %>%
  mutate(Scenario_Microservices = paste(Microservices_per_Container_Average, "\n(", scenario, ")", sep = ""),
         Scenario_Microservices = factor(Scenario_Microservices, levels = unique(Scenario_Microservices[order(Microservices_per_Container_Average)])))

# Gerar o gráfico
fig <- ggplot(data, aes(x = Scenario_Microservices, y = Requests_per_s, color = factor(workload_desc, levels = unique(workload_desc[order(workload)])))) +
  geom_point(size = 3) +
  geom_line(aes(group = workload)) +
  geom_text(aes(label = Requests_per_s), vjust = -1, size = 5, show_guide  = FALSE) +  # Adiciona os valores dos pontos
  labs(
    #title = "Median Requests/s vs Microservices per Container",
       x = "Microservices per Container (Average)",
       y = "Requests/s",
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

pdf_file = paste("resume_requests_s_not_hpa.pdf",sep = "")
pdf(pdf_file, width = 16, height = 9)
print(fig)
dev.off()
