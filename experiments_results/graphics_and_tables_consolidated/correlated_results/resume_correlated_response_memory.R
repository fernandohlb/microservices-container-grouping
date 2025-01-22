setwd("~/Documentos/Mestrado/microservices-container-grouping/experiments_results/graphics_and_tables_consolidated/correlated_results")
# Carregar pacotes necessários
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggrepel)
library(reshape2)


# Criando o dataframe
data <- data.frame(
  workload_desc = c("Low (300 users)", "Low (300 users)", "Low (300 users)", "Low (300 users)",
                    "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)",
                    "High (4500 users)", "High (4500 users)", "High (4500 users)", "High (4500 users)"),
  workload = c(300, 300, 300, 300, 2400, 2400, 2400, 2400, 4500, 4500, 4500, 4500),
  scenario = c("benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one",
               "benchmark", "by-dependencies", "by-stack", "all-in-one"),
  Microservices_per_Container = c(1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00),
  Requests_HPA = c(472, 612.2, 698.15, 897.6, 344.6, 389.85, 457.8, 573.8, 242.3, 333.65, 351.85, 484.7),
  CPU_HPA = c(3.71, 4.74, 5.04, 5.74, 4.47, 4.64, 4.98, 5.38, 3.56, 4.81, 4.91, 5.37)
)

# Filtrando os dados para workload médio (2400 usuários)
data <- data %>%
  filter(workload == 2400)

# Criando uma nova coluna que combina o nome do cenário com o valor de Microservices per Container
data <- data %>%
  mutate(scenario_combined = paste0(scenario, "(", Microservices_per_Container, ")"))

# Ordenar o dataframe pelos valores de Microservices per Container Average
data <- data %>%
  arrange(Microservices_per_Container)

# Reformatando o dataframe para a forma longa
data_long <- melt(data, id.vars = c("workload", "scenario_combined", "Microservices_per_Container"))

# Convertendo a coluna 'value' para numérico
data_long$value <- as.numeric(data_long$value)

# Criando o gráfico com ggplot2
fig<-ggplot() +
  geom_line(data = subset(data_long, variable == "Requests_HPA"), aes(x = reorder(scenario_combined, Microservices_per_Container), y = value, color = as.factor(workload), linetype = "Requests/s", group = workload), size = 1.2) +
  geom_point(data = subset(data_long, variable == "Requests_HPA"), aes(x = reorder(scenario_combined, Microservices_per_Container), y = value, color = as.factor(workload), group = workload), size = 3) +
  geom_line(data = subset(data_long, variable == "CPU_HPA"), aes(x = reorder(scenario_combined, Microservices_per_Container), y = value * 100, color = as.factor(workload), linetype = "CPU Usage", group = workload), size = 1.2) +
  geom_point(data = subset(data_long, variable == "CPU_HPA"), aes(x = reorder(scenario_combined, Microservices_per_Container), y = value * 100, color = as.factor(workload), group = workload), shape = 4, size = 3) +
  
  #   geom_text_repel(aes(label = round(Median_Scalability_Rate, 2)), vjust = -1, size = 5, , show_guide  = FALSE) +  # Adiciona os valores dos pontos
  # Adicionando etiquetas aos pontos para Requests/s com a mesma cor do workload
  geom_text_repel(data = subset(data_long, variable == "Requests_HPA"), aes(x = reorder(scenario_combined, Microservices_per_Container), y = value, label = round(value, 2), color = as.factor(workload)), vjust = -1, size = 5, , show_guide  = FALSE) +
  
  # Adicionando etiquetas aos pontos para CPU Usage com a mesma cor do workload
  geom_text_repel(data = subset(data_long, variable == "CPU_HPA"), aes(x = reorder(scenario_combined, Microservices_per_Container), y = value * 100, label = round(value, 2), color = as.factor(workload)), vjust = -1, size = 5, , show_guide  = FALSE) +
  
  scale_y_continuous(name = "Requests/s with HPA", sec.axis = sec_axis(~./100, name = "CPU With HPA")) +
  labs(x = "Scenario (Microservices per Container)", color = "Workload", linetype = "Metric", title = "Requests/s and CPU Usage with HPA by Scenario and Workload (Ordered by Microservices/Container)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
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
pdf_file = paste("correlation_request_s_cpu.pdf",sep = "")
pdf(pdf_file, width = 16, height = 9)
print(fig)
dev.off()




# # Criar o dataframe com os novos dados
# data_scalability <- data.frame(
#   workload = c(300, 300, 300, 300, 2400, 2400, 2400, 2400, 4500, 4500, 4500, 4500),
#   workload_desc = c("Low (300 users)", "Low (300 users)", "Low (300 users)", "Low (300 users)",
#                     "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)", "Medium (2400 users)",
#                     "High (4500 users)", "High (4500 users)", "High (4500 users)", "High (4500 users)"),
#   scenario = c("benchmark", "by-dependencies", "by-stack", "all-in-one",
#                "benchmark", "by-dependencies", "by-stack", "all-in-one",
#                "benchmark", "by-dependencies", "by-stack", "all-in-one"),
#   Microservices_per_Container_Average = c(1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00, 1.00, 1.33, 2.67, 8.00),
#   Median_Scalability_Rate = c(75.00, 100.00, 150.00, 100.00, 100.00, 133.33, 100.00, 100.00, 
#                               106.25, 133.33, 133.33, 100.00)
# )
# 
# # Criar uma nova coluna combinando cenário e média de microservices por container
# data_scalability <- data_scalability %>%
#   mutate(Scenario_Microservices = paste(scenario, "(", Microservices_per_Container_Average, ")", sep = ""),
#          Scenario_Microservices = factor(Scenario_Microservices, levels = unique(Scenario_Microservices[order(Microservices_per_Container_Average)])))
# 
# # Gerar o gráfico de escalabilidade
# fig<-ggplot(data_scalability, aes(x = Scenario_Microservices, y = Median_Scalability_Rate, color = factor(workload))) +
#   geom_point(size = 3) +
#   geom_line(aes(group = workload)) +
#   geom_text_repel(aes(label = round(Median_Scalability_Rate, 2)), vjust = -1, size = 5, , show_guide  = FALSE) +  # Adiciona os valores dos pontos
#   labs(
#     #title = "Median Scalability Rate vs Scenario with Microservices per Container Average",
#        x = "Scenario with Microservices per Container Average",
#        y = "Median Scalability Rate (%)",
#        color = "Workload") +
#   theme(plot.title = element_text(hjust = 0.5, vjust = 5, size = 20),
#         strip.text = element_text(size= 16),
#         plot.margin = unit(c(1,1,1,1), "cm"),
#         axis.text = element_text(size = 16),
#         #axis.text.x = element_text(angle = -45),
#         legend.title = element_text(size = 15),
#         legend.text = element_text(size = 12),
#         axis.title = element_text(size = 16),
#         axis.title.y=element_text(vjust=5),
#         axis.title.x=element_text(vjust=-5))
# 
# pdf_file = paste("resume_hpa.pdf",sep = "")
# pdf(pdf_file, width = 16, height = 9)
# print(fig)
# dev.off()



