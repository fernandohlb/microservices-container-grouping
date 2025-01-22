setwd("~/Documentos/Mestrado/microservices-container-grouping/experiments_results/graphics_and_tables_consolidated/hpa")
# Carregar pacotes necessários
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggrepel)

# Criar o dataframe com os novos dados
data_scalability <- data.frame(
  workload = c(300, 300, 300, 300, 2400, 2400, 2400, 2400, 4500, 4500, 4500, 4500),
  workload_desc = c("Low (300 users)", "Low (300 users)", "Low (300 users)", "Low (300 users)",
                    "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)",
                    "High (4500 users)", "High (4500 users)", "High (4500 users)", "High (4500 users)"),
  scenario = c("benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one"),
  Microservices_per_Container_Average = c(1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00),
  Median_Scalability_Rate = c(75.00, 100.00, 150.00, 100.00, 100.00, 133.33, 100.00, 100.00, 
                              106.25, 133.33, 133.33, 100.00)
)

# Criar uma nova coluna combinando cenário e média de microservices por container
data_scalability <- data_scalability %>%
  mutate(Scenario_Microservices = paste(scenario, "(", Microservices_per_Container_Average, ")", sep = ""),
         Scenario_Microservices = factor(Scenario_Microservices, levels = unique(Scenario_Microservices[order(Microservices_per_Container_Average)])))

# Gerar o gráfico de escalabilidade
fig<-ggplot(data_scalability, aes(x = Scenario_Microservices, y = Median_Scalability_Rate, color = factor(workload))) +
  geom_point(size = 3) +
  geom_line(aes(group = workload)) +
  geom_text_repel(aes(label = round(Median_Scalability_Rate, 2)), vjust = -1, size = 5, , show_guide  = FALSE) +  # Adiciona os valores dos pontos
  labs(
    #title = "Median Scalability Rate vs Scenario with Microservices per Container Average",
       x = "Scenario with Microservices per Container Average",
       y = "Median Scalability Rate (%)",
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

pdf_file = paste("resume_hpa.pdf",sep = "")
pdf(pdf_file, width = 16, height = 9)
print(fig)
dev.off()



