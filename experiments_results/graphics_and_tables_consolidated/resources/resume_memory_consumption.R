setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results/graphics_and_tables_consolidated/resources")
# Carregar pacotes necessários
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggrepel)

# Criar o dataframe com os dados fornecidos
data_memory <- data.frame(
  workload_desc = c("Low (300 users)", "Low (300 users)", "Low (300 users)", "Low (300 users)",
                    "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)",
                    "High (4500 users)", "High (4500 users)", "High (4500 users)", "High (4500 users)"),
  workload = c(300, 300, 300, 300, 2400, 2400, 2400, 2400, 4500, 4500, 4500, 4500),
  scenario = c("benchmark", "all-in-one", "by-stack", "by-dependencies",
               "benchmark", "all-in-one", "by-stack", "by-dependencies",
               "benchmark", "all-in-one", "by-stack", "by-dependencies"),
  Microservices_per_Container_Average = c(1.00, 8.00, 2.67, 1.33, 1.00, 8.00, 2.67, 1.33, 1.00, 8.00, 2.67, 1.33),
  Memory_without_HPA = c(2.42, 2.25, 2.38, 2.41, 2.74, 2.65, 2.71, 2.74, 3.04, 2.86, 2.84, 2.88),
  Memory_with_HPA = c(4.47, 3.85, 4.17, 4.07, 5.44, 4.36, 4.62, 5.53, 6.35, 4.65, 5.13, 5.98)
)

# Transformar os dados em formato longo para ggplot
data_long_memory <- data_memory %>%
  pivot_longer(cols = c(Memory_without_HPA, Memory_with_HPA), 
               names_to = "HPA", 
               values_to = "Memory_Gb") %>%
  mutate(HPA = recode(HPA, "Memory_without_HPA" = "without HPA", "Memory_with_HPA" = "with HPA"))

# Criar uma nova coluna combinando cenário e média de microservices por container
data_long_memory <- data_long_memory %>%
  mutate(Scenario_Microservices = paste(scenario, "(", Microservices_per_Container_Average, ")", sep = ""),
         Scenario_Microservices = factor(Scenario_Microservices, levels = unique(Scenario_Microservices[order(Microservices_per_Container_Average)])))


# Gerar o gráfico
fig<-ggplot(data_long_memory, aes(x = Scenario_Microservices, y = Memory_Gb, color = factor(workload), shape = HPA)) +
  geom_point(size = 3) +
  geom_line(aes(linetype = HPA, group = interaction(workload, HPA))) +
  geom_text_repel(aes(label = round(Memory_Gb, 2)), vjust = -1, size = 5, show_guide  = FALSE) +  # Adicionar os valores dos pontos com repel para evitar sobreposição
  labs(
    #title = "Memory Usage with and without HPA vs Scenario with Microservices per Container Average",
       x = "Scenario with Microservices per Container Average",
       y = "Memory Usage (GB)",
       color = "Workload",
       shape = "HPA",
       linetype = "HPA") +
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
fig
pdf_file = paste("resume_memory_consumption.pdf",sep = "")
pdf(pdf_file, width = 16, height = 9)
print(fig)
dev.off()


