setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results/graphics_and_tables_consolidated/costs")
# Carregar pacotes necessários
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggrepel)

# Criar o dataframe com os dados fornecidos
data_cost <- data.frame(
  workload = c(300, 300, 300, 300, 2400, 2400, 2400, 2400, 4500, 4500, 4500, 4500),
  workload_desc = c("Low (300 users)", "Low (300 users)", "Low (300 users)", "Low (300 users)",
                    "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)",
                    "High (4500 users)", "High (4500 users)", "High (4500 users)", "High (4500 users)"),
  scenario = c("benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one"),
  Microservices_per_Container_Average = c(1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00),
  Cost_without_HPA = c(108.335, 114.18, 111.65, 110.875, 122.36, 118.385, 129.015, 121.395, 95.15, 70.79, 119.19, 126.875),
  Cost_with_HPA = c(171.005, 186.95, 190.535, 201.37, 216.455, 223.445, 200.68, 201.46, 208.41, 239.215, 223.12, 191.94)
)

# Transformar os dados em formato longo para ggplot
data_long_cost <- data_cost %>%
  pivot_longer(cols = c(Cost_without_HPA, Cost_with_HPA), 
               names_to = "HPA", 
               values_to = "Cost_USD") %>%
  mutate(HPA = recode(HPA, "Cost_without_HPA" = "without HPA", "Cost_with_HPA" = "with HPA"))

# Criar uma nova coluna combinando cenário e média de microservices por container
data_long_cost <- data_long_cost %>%
  mutate(Scenario_Microservices = paste(scenario, "(", Microservices_per_Container_Average, ")", sep = ""),
         Scenario_Microservices = factor(Scenario_Microservices, levels = unique(Scenario_Microservices[order(Microservices_per_Container_Average)])))

# Gerar o gráfico
fig<-ggplot(data_long_cost, aes(x = Scenario_Microservices, y = Cost_USD, color = factor(workload_desc), shape = HPA)) +
  geom_point(size = 3) +
  geom_line(aes(linetype = HPA, group = interaction(workload_desc, HPA))) +
  geom_text_repel(aes(label = round(Cost_USD, 2)), vjust = -1, size = 5, show.legend =  FALSE) +  # Adicionar os valores dos pontos com repel para evitar sobreposição
  labs(
    #title = "Monthly Cost (U$) with and without HPA vs Scenario with Microservices per Container Average",
       x = "Scenario with Microservices per Container Average",
       y = "Monthly Cost (U$)",
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
pdf_file = paste("resume_costs_consumption.pdf",sep = "")
pdf(pdf_file, width = 16, height = 9)
print(fig)
dev.off()

