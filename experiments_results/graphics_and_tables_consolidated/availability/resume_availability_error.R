setwd("~/Documentos/Mestrado/microservices-container-grouping/experiments_results/graphics_and_tables_consolidated/availability")
# Carregar pacotes necessários
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggrepel)

# Criar o dataframe com os novos dados
data <- data.frame(
  workload = c(300, 300, 300, 300, 2400, 2400, 2400, 2400, 4500, 4500, 4500, 4500),
  workload_desc = c("Low (300 users)", "Low (300 users)", "Low (300 users)", "Low (300 users)",
                    "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)",
                    "High (4500 users)", "High (4500 users)", "High (4500 users)", "High (4500 users)"),
  scenario = c("benchmark", "all-in-one", "by-stack", "by-dependencies",
               "benchmark", "all-in-one", "by-stack", "by-dependencies",
               "benchmark", "all-in-one", "by-stack", "by-dependencies"),
  Microservices_per_Container_Average = c(1.00, 8.00, 2.67, 1.33, 1.00, 8.00, 2.67, 1.33, 1.00, 8.00, 2.67, 1.33),
  Availability_without_HPA = c(100.00, 100.00, 100.00, 100.00, 99.99, 99.99, 99.98, 99.99, 81.35, 89.38, 84.30, 80.30),
  Availability_with_HPA = c(100.00, 100.00, 100.00, 100.00, 99.42, 99.97, 99.97, 99.97, 91.78, 99.48, 94.51, 94.29)
)

# Transformar os dados em formato longo para ggplot
data_long <- data %>%
  pivot_longer(cols = starts_with("Availability_"), names_to = "HPA", values_to = "Availability") %>%
  mutate(HPA = recode(HPA, "Availability_with_HPA" = "with HPA", "Availability_without_HPA" = "without HPA"))

# Criar uma nova coluna combinando cenário e média de microservices por container
data_long <- data_long %>%
  mutate(Scenario_Microservices = paste(scenario, "(", Microservices_per_Container_Average, ")", sep = ""),
         Scenario_Microservices = factor(Scenario_Microservices, levels = unique(Scenario_Microservices[order(Microservices_per_Container_Average)])))

# Ordenar workload_desc
data_long$workload_desc <- factor(data_long$workload_desc, levels = c("Low (300 users)", "Medium (2400 users)", "High (4500 users)"))

# Definir estilos de linha para HPA e sem HPA
line_styles <- c("with HPA" = "solid", "without HPA" = "dashed")

# Gerar o gráfico
fig<-ggplot(data_long, aes(x = Scenario_Microservices, y = Availability,color = factor(workload_desc, levels = unique(workload_desc[order(workload)])), linetype = HPA, shape = HPA)) +
  geom_point(size = 3) +
  geom_line(aes(group = interaction(workload_desc, HPA))) +
  geom_text_repel(aes(label = round(Availability, 2)), vjust = -1, size = 5, show_guide  = FALSE) +  # Adiciona os valores dos pontos
  # scale_color_manual(values = workload_colors) +
  scale_linetype_manual(values = line_styles) +
  labs(
    #title = "Requests per Second with and without HPA vs Scenario with Microservices per Container Average",
    x = "Scenario with Microservices per Container Average",
    y = "Median Availability by Error (%)",
    color = "Workload Description",
    linetype = "HPA",
    shape = "HPA") +
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
pdf_file = paste("resume_availability_error.pdf",sep = "")
pdf(pdf_file, width = 16, height = 9)
print(fig)
dev.off()
