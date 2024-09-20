# TITLE: How to access FRED data without an API
# DATE:  2024-09-19

# Install packages
# install.packages("tidyverse")

# Load libraries
library(tidyverse)

# Example: Read in Texas data with copied URL
texas <- read.csv("https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23e1e9f0&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=on&txtcolor=%23444444&ts=12&tts=12&width=1140&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=TXRPIPC&scale=left&cosd=2008-01-01&coed=2022-01-01&line_color=%234572a7&link_values=false&line_style=solid&mark_type=none&mw=3&lw=2&ost=-99999&oet=99999&mma=0&fml=a&fq=Annual&fam=avg&fgst=lin&fgsnd=2020-02-01&line_index=1&transformation=lin&vintage_date=2024-09-18&revision_date=2024-09-18&nd=2008-01-01")

# Building all state URLs
urls <- paste0("https://fred.stlouisfed.org/graph/fredgraph.csv?id=", state.abb, "RPIPC")

# Grabbing all state real per capita personal income data
all_states <- do.call(bind_rows, lapply(urls, function(x) {
  # Print stage
  print(which(urls == x))
  # Read in data
  read.csv(x) %>% 
    pivot_longer(cols = 2,
                 names_to = "SERIES_ID",
                 values_to = "VALUE")
}))

# Clean up results
clean <- all_states %>% 
  mutate(STATE_ABB = substr(SERIES_ID, 1, 2),
         STATE_NAME = state.name[match(STATE_ABB, state.abb)]) %>% 
  select(DATE, SERIES_ID, STATE_ABB, STATE_NAME, VALUE)

# See top states in latest year of data
clean %>% 
  filter(DATE == max(DATE)) %>% 
  arrange(-VALUE) %>% 
  View()
