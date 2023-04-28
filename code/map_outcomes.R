##########################
#################  library
##########################

## clear workspace
rm(list = ls())
gc()

## this function will check if a package is installed, and if not, install it
list.of.packages <- c('tidyverse','magrittr',
                      'sf',
                      'ggplot2','ggthemes','ggspatial','ggpubr','showtext',
                      'RColorBrewer')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.rstudio.com/")
lapply(list.of.packages, library, character.only = TRUE)

##########################
###################  parts
##########################

## add fonts
font_add_google("Quattrocento Sans", "sans-serif")
showtext_auto()

##########################
####################  data
##########################

## city polygon
city = 
  st_read('data/city_boundary/city_boundary.shp')
  
## block group level data
data =  
  st_read('data/census_block_group_data/census_block_group_data.shp') %>% 
  rename(geoid_bg = geod_bg, shr_college = shr_cll, owner_occup = ownr_c_, net_val_pct = nt_vl_p,  ## home characteristics
         registered_2022_07 = r_2022_, inspection_contractor_2022_07 = i__2022)                    ## outcomes

##########################
####################  maps
##########################

registered = 
  ggplot() +
  geom_sf(data = data, 
          aes(color = registered_2022_07,
              fill  = registered_2022_07)) +
  geom_sf(data      = city, 
          color     = 'grey30',
          fill      = NA,
          linewidth = 1) +
  scale_color_stepsn(colors   = RColorBrewer::brewer.pal(8, "Spectral"),
                     breaks   = c(seq(0.1, 0.8, 0.1)),
                     limits   = c(0, 0.8),
                     guide    = 'legend',
                     labels   = scales::percent,
                     na.value = 'grey90') +
  scale_fill_stepsn(colors   = RColorBrewer::brewer.pal(8, "Spectral"),
                    breaks   = c(seq(0.1, 0.8, 0.1)),
                    limits   = c(0, 0.8),
                    guide    = 'legend',            
                    labels   = scales::percent,
                    na.value = 'grey90') +
  labs(x     = '',
       y     = '',
       color = '',
       fill  = '') + 
  theme_map() +
  theme(
    legend.position  = 'right',
    legend.direction = "horizontal",
    legend.box       = "horizontal",
    legend.key.size  = unit(1, 'cm'),
    legend.spacing.x = unit(0.5, 'cm'),
    legend.title     = element_text(size = 14, color = 'grey20', hjust = 0.5),
    legend.text      = element_text(size = 14, color = 'grey20',
                                    margin = margin(l = -10)),
    text             = element_text(family="sans-serif", color='grey20')
  ) +
  guides(color = guide_legend(nrows = 2),
         fill  = guide_legend(nrows = 2))

inspected = 
  ggplot() +
  geom_sf(data = data, 
          aes(color = inspection_contractor_2022_07,
              fill  = inspection_contractor_2022_07)) +
  geom_sf(data      = city, 
          color     = 'grey30',
          fill      = NA,
          linewidth = 1) +
  scale_color_stepsn(colors   = RColorBrewer::brewer.pal(8, "Spectral"),
                     breaks   = c(seq(0.1, 0.8, 0.1)),
                     limits   = c(0, 0.8),
                     guide    = 'legend',
                     labels   = scales::percent,
                     na.value = 'grey90') +
  scale_fill_stepsn(colors   = RColorBrewer::brewer.pal(8, "Spectral"),
                    breaks   = c(seq(0.1, 0.8, 0.1)),
                    limits   = c(0, 0.8),
                    guide    = 'legend',            
                    labels   = scales::percent,
                    na.value = 'grey90') +
  labs(x     = '',
       y     = '',
       color = '',
       fill  = '') + 
  theme_map() +
  theme(
    legend.position  = 'right',
    legend.direction = "horizontal",
    legend.box       = "horizontal",
    legend.key.size  = unit(1, 'cm'),
    legend.spacing.x = unit(0.5, 'cm'),
    legend.title     = element_text(size = 14, color = 'grey20', hjust = 0.5),
    legend.text      = element_text(size = 14, color = 'grey20',
                                    margin = margin(l = -10)),
    text             = element_text(family="sans-serif", color='grey20')
  ) +
  guides(color = guide_legend(nrows = 2),
         fill  = guide_legend(nrows = 2))

replaced = 
  ggplot() +
  geom_sf(data = data, 
          aes(color = LSLR,
              fill  = LSLR)) +
  geom_sf(data      = city, 
          color     = 'grey30',
          fill      = NA,
          linewidth = 1) +
  scale_color_stepsn(colors   = RColorBrewer::brewer.pal(8, "Spectral"),
                     breaks   = c(seq(0.1, 0.8, 0.1)),
                     limits   = c(0, 0.8),
                     guide    = 'legend',
                     labels   = scales::percent,
                     na.value = 'grey90') +
  scale_fill_stepsn(colors   = RColorBrewer::brewer.pal(8, "Spectral"),
                    breaks   = c(seq(0.1, 0.8, 0.1)),
                    limits   = c(0, 0.8),
                    guide    = 'legend',            
                    labels   = scales::percent,
                    na.value = 'grey90') +
  labs(x     = '',
       y     = '',
       color = '',
       fill  = '') + 
  theme_map() +
  theme(
    legend.position  = 'right',
    legend.direction = "horizontal",
    legend.box       = "horizontal",
    legend.key.size  = unit(1, 'cm'),
    legend.spacing.x = unit(0.5, 'cm'),
    legend.title     = element_text(size = 14, color = 'grey20', hjust = 0.5),
    legend.text      = element_text(size = 14, color = 'grey20',
                                    margin = margin(l = -10)),
    text             = element_text(family = 'sans-serif', color = 'grey20')
  ) +
  guides(color = guide_legend(nrows = 2),
         fill  = guide_legend(nrows = 2))

## arrange in grid
legend = get_legend(registered + 
                      theme(legend.margin = margin(l = 2, r = 0, b = 2, t = 0, unit = 'cm')))

registered %<>% + theme(legend.position = "none")
inspected  %<>% + theme(legend.position = "none")
replaced   %<>% + theme(legend.position = "none")

ggarrange(registered, 
          inspected,
          replaced,
          legend,
          nrow = 2,
          ncol = 2,
          common.legend = F,
          labels = c('Share of Homes Registered for the Program',
                     'Share of Homes with Interior Contractor Inspection',
                     'Share of Confirmed Homeowner-Side LSL Replaced'),
          font.label = list(family="sans-serif", color = 'grey20'),
          hjust = 0)

## export
ggsave('figures/map_outcomes.svg', width = 10, height = 10)

## end of script. have a great day!