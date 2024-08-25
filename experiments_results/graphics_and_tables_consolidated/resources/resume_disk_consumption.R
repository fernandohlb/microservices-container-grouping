setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results/graphics_and_tables_consolidated/resources")
# Carregar pacotes necessários
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggrepel)

# Criar o dataframe com os dados fornecidos
data_disk <- data.frame(
  workload = c(300, 300, 300, 300, 2400, 2400, 2400, 2400, 4500, 4500, 4500, 4500),
  workload_desc = c("Low (300 users)", "Low (300 users)", "Low (300 users)", "Low (300 users)",
                    "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)",
                    "High (4500 users)", "High (4500 users)", "High (4500 users)", "High (4500 users)"),
  scenario = c("benchmark", "all-in-one", "by-stack", "by-dependencies",
               "benchmark", "all-in-one", "by-stack", "by-dependencies",
               "benchmark", "all-in-one", "by-stack", "by-dependencies"),
  Microservices_per_Container_Average = c(1.00, 8.00, 2.67, 1.33, 1.00, 8.00, 2.67, 1.33, 1.00, 8.00, 2.67, 1.33),
  Disk_without_HPA = c(164, 99, 133, 142, 180, 114, 140, 183, 100, 124, 122, 121),
  Disk_with_HPA = c(178, 186, 177, 201, 193, 201, 204, 216, 170, 203, 191, 214)
)

# Transformar os dados em formato longo para ggplot
data_long_disk <- data_disk %>%
  pivot_longer(cols = c(Disk_without_HPA, Disk_with_HPA), 
               names_to = "HPA", 
               values_to = "Disk_Mb") %>%
  mutate(HPA = recode(HPA, "Disk_without_HPA" = "without HPA", "Disk_with_HPA" = "with HPA"))

# Criar uma nova coluna combinando cenário e média de microservices por container
data_long_disk <- data_long_disk %>%
  mutate(Scenario_Microservices = paste(scenario, "(", Microservices_per_Container_Average, ")", sep = ""),
         Scenario_Microservices = factor(Scenario_Microservices, levels = unique(Scenario_Microservices[order(Microservices_per_Container_Average)])))


# Gerar o gráfico
fig<-ggplot(data_long_disk, aes(x = Scenario_Microservices, y = Disk_Mb, color = factor(workload), shape = HPA)) +
  geom_point(size = 3) +
  geom_line(aes(linetype = HPA, group = interaction(workload, HPA))) +
  geom_text_repel(aes(label = round(Disk_Mb, 2)), vjust = -1, size = 5, show_guide  = FALSE) +  # Adicionar os valores dos pontos com repel para evitar sobreposição
  labs(
    #title = "Disk Usage with and without HPA vs Scenario with Microservices per Container Average",
       x = "Scenario with Microservices per Container Average",
       y = "Disk Usage (Mb)",
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
pdf_file = paste("resume_disk_consumption.pdf",sep = "")
pdf(pdf_file, width = 16, height = 9)
print(fig)
dev.off()


