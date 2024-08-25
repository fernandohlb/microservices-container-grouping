setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results/graphics_and_tables_consolidated/performance")
# Carregar pacotes necessários
library(ggplot2)
library(dplyr)
library(ggrepel)
library(tidyr)

# Criar o dataframe com os dados fornecidos
data_failures <- data.frame(
  workload_desc = c("Low (300 users)", "Low (300 users)", "Low (300 users)", "Low (300 users)",
                    "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)",
                    "High (4500 users)", "High (4500 users)", "High (4500 users)", "High (4500 users)"),
  workload = c(300, 300, 300, 300, 2400, 2400, 2400, 2400, 4500, 4500, 4500, 4500),
  scenario = c("benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one"),
  Microservices_per_Container_Average = c(1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00),
  Failures_per_s_without_HPA = c(0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 4.45, 5.00, 2.10, 18.15),
  Failures_per_s_with_HPA = c(0.00, 0.00, 0.00, 0.00, 0.10, 0.10, 0.10, 0.10, 2.10, 9.15, 3.80, 0.20)
)

# Transformar os dados em formato longo para ggplot
data_long_failures <- data_failures %>%
  gather(key = "HPA", value = "Failures_per_s", Failures_per_s_without_HPA, Failures_per_s_with_HPA) %>%
  mutate(HPA = recode(HPA, "Failures_per_s_without_HPA" = "without HPA", "Failures_per_s_with_HPA" = "with HPA"))

# Criar uma nova coluna combinando cenário e média de microservices por container
data_long_failures <- data_long_failures %>%
  mutate(Scenario_Microservices = paste(scenario, "(", Microservices_per_Container_Average, ")", sep = ""),
         Scenario_Microservices = factor(Scenario_Microservices, levels = unique(Scenario_Microservices[order(Microservices_per_Container_Average)])))

# Gerar o gráfico
fig<-ggplot(data_long_failures, aes(x = Scenario_Microservices, y = Failures_per_s, color = factor(workload_desc), shape = HPA)) +
  geom_point(size = 3) +
  geom_line(aes(linetype = HPA, group = interaction(workload_desc, HPA))) +
  geom_text_repel(aes(label = round(Failures_per_s, 2)), size = 5, show_guide  = FALSE) +  # Adicionar os valores dos pontos com repel para evitar sobreposição
  labs(
    #title = "Failures per Second with and without HPA vs Scenario with Microservices per Container Average",
       x = "Scenario with Microservices per Container Average",
       y = "Failures per Second",
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

pdf_file = paste("resume_failures_s.pdf",sep = "")
pdf(pdf_file, width = 16, height = 9)
print(fig)
dev.off()
