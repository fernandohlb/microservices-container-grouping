setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results/graphics_and_tables_consolidated/resources")
# Carregar pacotes necessários
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggrepel)

# Criar o dataframe com os dados fornecidos
data_cpu <- data.frame(
  workload_desc = c("Low (300 users)", "Low (300 users)", "Low (300 users)", "Low (300 users)",
                    "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)",
                    "High (4500 users)", "High (4500 users)", "High (4500 users)", "High (4500 users)"),
  workload = c(300, 300, 300, 300, 2400, 2400, 2400, 2400, 4500, 4500, 4500, 4500),
  scenario = c("benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one"),
  Microservices_per_Container_Average = c(1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00),
  CPU_Without_HPA = c(2.97, 3.02, 2.92, 3.14, 3.25, 3.30, 3.41, 3.35, 2.41, 2.46, 2.82, 3.61),
  CPU_With_HPA = c(3.71, 4.74, 5.04, 5.735, 4.47, 4.635, 4.98, 5.38, 3.56, 4.81, 4.91, 5.365)
)

# Transformar os dados em formato longo para ggplot
data_long_cpu <- data_cpu %>%
  pivot_longer(cols = c(CPU_Without_HPA, CPU_With_HPA), 
               names_to = "HPA", 
               values_to = "CPU") %>%
  mutate(HPA = recode(HPA, "CPU_Without_HPA" = "without HPA", "CPU_With_HPA" = "with HPA"))

# Criar uma nova coluna combinando cenário e média de microservices por container
data_long_cpu <- data_long_cpu %>%
  mutate(Scenario_Microservices = paste(scenario, "(", Microservices_per_Container_Average, ")", sep = ""),
         Scenario_Microservices = factor(Scenario_Microservices, levels = unique(Scenario_Microservices[order(Microservices_per_Container_Average)])))

# Gerar o gráfico
fig<-ggplot(data_long_cpu, aes(x = Scenario_Microservices, y = CPU, color = factor(workload_desc), shape = HPA)) +
  geom_point(size = 3) +
  geom_line(aes(linetype = HPA, group = interaction(workload_desc, HPA))) +
  geom_text_repel(aes(label = round(CPU, 2)), vjust = -1, size = 5, show_guide  = FALSE) +  # Adicionar os valores dos pontos com repel para evitar sobreposição
  labs(
    #title = "CPU Usage with and without HPA vs Scenario with Microservices per Container Average",
       x = "Scenario with Microservices per Container Average",
       y = "CPU Usage (cores)",
       color = "Workload Description",
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
pdf_file = paste("resume_cpu_consumption.pdf",sep = "")
pdf(pdf_file, width = 16, height = 9)
print(fig)
dev.off()

