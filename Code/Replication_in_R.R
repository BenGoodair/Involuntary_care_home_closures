# Load necessary libraries
library(tidyverse)
library(curl)

# Load data
data_replication_1 <- read.csv(curl("https://raw.githubusercontent.com/BenGoodair/Involuntary_care_home_closures/main/Data/involuntary%20closures_replicationdata_1.csv"))
data_replication_2 <- read.csv(curl("https://raw.githubusercontent.com/BenGoodair/Involuntary_care_home_closures/main/Data/involuntary%20closures_replicationdata_2.csv"))

#----------------------------------------------------
# Table 1 
#----------------------------------------------------
# Forced closures
forced_closures <- data_replication_1 %>%
  filter(forced_closure == 1)

forced_closures_summary <- forced_closures %>%
  summarise(across(c(company, individual_partnership, disabled, mental_health, detained, dementia, nurse, age, carehomesbeds, inadequate, requiresimprovement, good, outstanding, missing_quality), list(mean = ~mean(., na.rm = TRUE), sd = ~sd(., na.rm = TRUE), sum = ~sum(., na.rm = TRUE), count = ~sum(!is.na(.)))))

# Complete closures
complete_closures <- data_replication_1 %>%
  filter(closed_complete == 1)

complete_closures_summary <- complete_closures %>%
  summarise(across(c(company, individual_partnership, disabled, mental_health, detained, dementia, nurse, age, carehomesbeds, inadequate, requiresimprovement, good, outstanding, missing_quality), list(mean = ~mean(., na.rm = TRUE), sd = ~sd(., na.rm = TRUE), sum = ~sum(., na.rm = TRUE), count = ~sum(!is.na(.)))))

# Active homes
active_homes <- data_replication_1 %>%
  filter(is.na(year_location_end))

active_homes_summary <- active_homes %>%
  summarise(across(c(company, individual_partnership, disabled, mental_health, detained, dementia, nurse, age, carehomesbeds, inadequate, requiresimprovement, good, outstanding, missing_quality), list(mean = ~mean(., na.rm = TRUE), sd = ~sd(., na.rm = TRUE), sum = ~sum(., na.rm = TRUE), count = ~sum(!is.na(.)))))

#----------------------------------------------------
# Figure 2
#----------------------------------------------------
# Bar graph for percent of homes rated inadequate
inadequate_plot <- ggplot(data_replication_1, aes(x = ownership, y = inadequate)) +
  geom_bar(stat = "summary", fun = "mean") +
  ylab("Percent of homes rated inadequate (%, all inspected homes, 2011-2023)")

# Bar graph for percent of homes involuntarily closed
forced_closure_plot <- ggplot(data_replication_1, aes(x = ownership, y = forced_closure)) +
  geom_bar(stat = "summary", fun = "mean") +
  ylab("Percent of homes involuntarily closed (% of all homes, 2011-2023)")

# Bar graph for percent of homes involuntarily closed
involuntary_closure_status_plot <- ggplot(data_replication_1%>%
                                            tidyr::pivot_longer(cols = c(inadequate, requiresimprovement, good, outstanding), names_to = "rating", values_to = "ratingvalue") %>%
                                            dplyr::filter(ratingvalue==1, forced_closure==1)%>%
                                            dplyr::group_by(rating)%>%
                                            dplyr::summarise(ratingvalue = sum(ratingvalue, na.rn=T))%>%
                                            dplyr::ungroup(),
                                          aes(x = rating, y = ratingvalue)) +
  geom_bar(stat = "summary", fun = "stat") +
  ylab("Percent of homes involuntarily closed (%)")



#----------------------------------------------------
# Figure 1
#----------------------------------------------------
# Bar graph for closed beds count
closed_beds_count_plot <- ggplot(data_replication_2 %>% 
                                   dplyr::filter(year_location_start != 2010) %>%
                                   tidyr::pivot_longer(cols=c(closedbeds_adjusted,  force_closed_beds), names_to = "close_reason", values_to = "beds"),
                                 aes(x = factor(year_location_end), y = beds)) +
  geom_bar(stat = "identity", aes(fill = factor(close_reason))) +
  labs(title = "C) Closed beds (count)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Bar graph for closed beds percentage
closed_beds_percentage_plot <- ggplot(data_replication_2 %>% 
                                        dplyr::filter(year_location_start != 2010)%>%
                                        dplyr::mutate(proportion_voluntary_beds = 1-proportion_forced_beds)%>%
                                        tidyr::pivot_longer(cols=c(proportion_voluntary_beds,  proportion_forced_beds), names_to = "close_reason", values_to = "beds"),
                                        aes(x = factor(year_location_end), y = beds)) +
  geom_bar(stat = "identity", aes(fill = factor(close_reason))) +
  labs(title = "D) Closed beds (%)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Bar graph for closed homes count
closed_homes_count_plot <- ggplot(data_replication_2 %>% 
                                    dplyr::filter(year_location_start != 2010)%>%
                                    tidyr::pivot_longer(cols=c(forced_closures_england,  total_closures_adjusted), names_to = "close_reason", values_to = "homes"),
                                    aes(x = factor(year_location_end), y = homes)) +
  geom_bar(stat = "identity", aes(fill = factor(close_reason))) +
  labs(title = "A) Closed homes (count)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Bar graph for closed homes percentage
closed_homes_percentage_plot <- ggplot(data_replication_2 %>% 
                                         dplyr::filter(year_location_start != 2010)%>%
                                         dplyr::mutate(proportion_voluntary_closures = 1-proportion_forced_closures)%>%
                                         tidyr::pivot_longer(cols=c(proportion_voluntary_closures,  proportion_forced_closures), names_to = "close_reason", values_to = "homes"),
                                         aes(x = factor(year_location_end), y = homes)) +
  geom_bar(stat = "identity", aes(fill = factor(close_reason))) +
  labs(title = "B) Closed homes (%)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Combine plots
cowplot::plot_grid(closed_homes_count_plot, closed_homes_percentage_plot, closed_beds_count_plot, closed_beds_percentage_plot, ncol = 2)
