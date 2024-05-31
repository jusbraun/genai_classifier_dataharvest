library(dplyr)
library(openxlsx)
library(tidyr)
library(stringr)


setwd("/Users/justin-casimirbraun/GitHub/genai_classifier_dataharvest")


test_set <- read.xlsx('data/hidden/test_set_combined.xlsx') %>%
  mutate(id = row_number()) %>%
  dplyr::select(id, mitigating1_en, mitigating1_desc,
                mitigating2_en, mitigating2_desc,
                mitigating3_en, mitigating3_desc,
                mitigating4_en, mitigating4_desc,
                mitigating5_en, mitigating5_desc,
                mitigating6_en, mitigating6_desc,
                mitigating7_en, mitigating7_desc,
                aggravating1_en, aggravating1_desc,
                aggravating2_en, aggravating2_desc,
                aggravating3_en, aggravating3_desc,
                aggravating4_en, aggravating4_desc) %>%
  pivot_longer(cols = starts_with(c('aggravating', 'mitigating')), names_to = 'circ', values_to = 'text') %>%
  filter(!is.na(text), text != '#VALUE!') %>%
  separate(circ, into = c('type', 'class'), sep = '_', remove = T) %>%
  pivot_wider(id_cols = c('id', 'type'), names_from = 'class', values_from = 'text') %>%
  mutate(type = str_replace_all(type, "[:digit:]", "")) %>%
  rename('text' = 'en', 
         'hand_coded' = 'desc')

write.csv(test_set, 'data/test_set.csv')
