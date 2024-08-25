setwd("~/Documentos/Dev/microservices-container-grouping/experiments_results/graphics_and_tables_consolidated/performance")
# Carregar pacotes necessários
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggrepel)

# Criar o dataframe com os dados fornecidos
data <- data.frame(
  workload_desc = c("Low (300 users)", "Low (300 users)", "Low (300 users)", "Low (300 users)",
                    "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)",
                    "High (4500 users)", "High (4500 users)", "High (4500 users)", "High (4500 users)"),
  workload = c(300, 300, 300, 300, 2400, 2400, 2400, 2400, 4500, 4500, 4500, 4500),
  scenario = c("benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one"),
  Microservices_per_Container_Average = c(1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00),
  Requests_per_s_with_HPA = c(472, 612.2, 698.15, 897.6, 344.6, 389.85, 457.8, 573.8, 242.3, 333.65, 351.85, 484.7),
  Requests_per_s_without_HPA = c(444.1, 476.6, 455, 510, 322.65, 335.25, 354, 382.05, 245.85, 299.05, 305.6, 320.35)
)

# Transformar os dados em formato longo para ggplot
data_long <- data %>%
  pivot_longer(cols = starts_with("Requests_per_s_"), names_to = "HPA", values_to = "Requests_per_s") %>%
  mutate(HPA = recode(HPA, "Requests_per_s_with_HPA" = "with HPA", "Requests_per_s_without_HPA" = "without HPA"))

# Criar uma nova coluna combinando cenário e média de microservices por container
data_long <- data_long %>%
  mutate(Scenario_Microservices = paste(scenario, "(", Microservices_per_Container_Average, ")", sep = ""),
         Scenario_Microservices = factor(Scenario_Microservices, levels = unique(Scenario_Microservices[order(Microservices_per_Container_Average)])))

# Ordenar workload_desc
data_long$workload_desc <- factor(data_long$workload_desc, levels = c("Low (300 users)", "Medium (2400 users)", "High (4500 users)"))

# Definir estilos de linha para HPA e sem HPA
line_styles <- c("with HPA" = "solid", "without HPA" = "dashed")

# Gerar o gráfico
fig<-ggplot(data_long, aes(x = Scenario_Microservices, y = Requests_per_s,color = factor(workload_desc, levels = unique(workload_desc[order(workload)])), linetype = HPA, shape = HPA)) +
  geom_point(size = 3) +
  geom_line(aes(group = interaction(workload_desc, HPA))) +
  geom_text_repel(aes(label = round(Requests_per_s, 2)), vjust = -1, size = 5, show_guide  = FALSE) +  # Adiciona os valores dos pontos
  # scale_color_manual(values = workload_colors) +
  scale_linetype_manual(values = line_styles) +
  labs(
    #title = "Requests per Second with and without HPA vs Scenario with Microservices per Container Average",
       x = "Scenario with Microservices per Container Average",
       y = "Requests per Second",
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
pdf_file = paste("resume_requests_s.pdf",sep = "")
pdf(pdf_file, width = 16, height = 9)
print(fig)
dev.off()

