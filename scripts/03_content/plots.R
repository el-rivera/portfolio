# EVR628tools::create_dirs()
library(EVR628tools)
library(tidyverse)

data("data_lionfish")

plot1 = ggplot(data = data_lionfish,
       mapping = aes(x = total_length_mm, y = depth_m)) +
  geom_point() +
  geom_smooth(method='lm', colour="seashell4") +
  labs(title = "Depth Length Relationship") +
  xlab("Total Length (mm)") +
  ylab("Depth (m)") +
  theme_minimal()

ggsave(plot1, path = "results/img/depth_vs_length.pdf")
