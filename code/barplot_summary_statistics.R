##########################
#################  library
##########################

## clear workspace
rm(list = ls())
gc()

## this function will check if a package is installed and, if not, install it
list.of.packages <- c('magrittr','tidyverse',
                      'readxl',
                      'ggplot2','ggpubr','showtext')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.rstudio.com/")
lapply(list.of.packages, library, character.only = TRUE)

##########################
###################  parts
##########################

## add fonts
font_add_google("Quattrocento Sans", "sans-serif")
showtext_auto()

## colors
colors = c("#CC79A7", "#009E73")

##########################
##################### data
##########################

## import
data = 
  read_xlsx('data/summary_stats.xlsx') %>% 
  group_by(group) %>%
  mutate(label = reorder(label, order),
         facet = case_when(facet == 'LSLR \\nParticipation' ~ 'LSLR \nParticipation',
                           facet == 'Homeowner-Side \\nService Line Material' ~ 'Homeowner-Side \nService Line Material',
                           facet == 'Property and \\nNeighborhood Characteristics' ~ 'Property and \nNeighborhood Characteristics'),
         facet = factor(facet, levels = c('LSLR \nParticipation', 'Homeowner-Side \nService Line Material', 'Property and \nNeighborhood Characteristics')),
         label = case_when(label == 'Property value \\u2265 $100,000†' ~ 'Property value >= $100,000†',
                           label == 'Confirmed homeowner-side \\nLSL replaced' ~ 'Confirmed homeowner-side \nLSL replaced§',
                           T ~ as.character(label)),
         group = case_when(group == 'Suburban \\n(35,388 properties)' ~ '        Suburban \n(35,388 properties)',
                           group == 'Urban \\n(20,529 properties)' ~ '             Urban \n(20,529 properties)'),
         group = factor(group, levels = c('        Suburban \n(35,388 properties)', '             Urban \n(20,529 properties)'))) %>% 
  ungroup

##########################
####################  plot
##########################

data %>%
  ggplot() +
  facet_grid(rows = vars(facet),
             scales = 'free',
             space  = 'free') +
  geom_bar(aes(x     = value,
               y     = reorder(label, -order),
               color = group,
               fill  = group),
           stat     = 'identity', 
           position = 'dodge') +
  geom_text(aes(x     = value, 
                y     = reorder(label, -order),
                group = group,
                label = paste0(round(value*100, 0), '%')),
            family = "sans-serif", 
            color   = 'grey20',
            hjust   = -0.2, 
            position = position_dodge(.9)) +
  scale_color_manual(values = colors,
                     guide  = guide_legend(reverse = T)) +
  scale_fill_manual(values = colors,
                    guide  = guide_legend(reverse = T)) +
  scale_x_continuous(breaks = c(0, 0.25, 0.50, 0.75, 1),
                     limits = c(0,1),
                     labels = scales::percent) +
  labs(title  = '',
       x      = '',
       y      = '',
       color  = '',
       shape  = '',
       group  = '',
       fill   = '') +
  theme_minimal() +
  theme(legend.position  = 'bottom',
        legend.title     = element_text(size = 14, color = 'grey20'),
        legend.text      = element_text(size = 14, color = 'grey20'),
        legend.key.size  = unit(0.75, 'cm'),
        axis.title       = element_text(size = 14),
        axis.text.y      = element_text(size = 14),
        axis.text.x      = element_text(size = 14),
        axis.line.x      = element_line(color = "black"),
        axis.ticks.x     = element_line(color = "black", linewidth = 1),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color='grey70', linetype = 'dotted'),
        panel.grid.minor = element_blank(),
        plot.caption     = element_text(size = 11, hjust = 0.5),
        plot.title       = element_text(size = 14, hjust = 0.5),
        strip.text       = element_text(family = 'sans-serif', color = 'grey20', size = 12),
        strip.background = element_rect(linewidth = 0.5),
        text             = element_text(family = 'sans-serif', color = 'grey20'))

## export
ggsave('figures/bar_summary_statistics.svg', width = 8, height = 9.25)
