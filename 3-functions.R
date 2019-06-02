####  create function for counting unique values in a column #### 
show_unique_count <- function(df, ...){
  # load packages
  library(dplyr)
  
  # define function
  df %>%
    group_by(...) %>%
    summarise(Count = n()) %>%
    ungroup() %>%
    arrange(desc(Count)) %>%
    mutate(Frequency = round(Count/sum(Count), digits=2)) %>%
    print()
}


####  plot function with only one independent variable #### 
plot_unique_count_xy <- function(df, title){
  library(ggplot2)
  library(dplyr)
  
  # ensure xlab is variable name rather than "reorder(df[x])"
  xlab <- colnames(df)[1]
  title <- title
  
  ggplot(df, aes_string(x=paste0(x="reorder(", colnames(df)[1], ", ", colnames(df)[2], ")"),
                        y=colnames(df)[2])) +
    geom_bar(stat="identity") + 
    coord_flip() +
    scale_y_continuous(labels = scales::comma) +
    labs(x = xlab, title=title) +
    theme(plot.title = element_text(hjust = 0.5)) # center the title
}


####  same function as above but for two independent variables #### 
plot_unique_count_xyfill <- function(df, title){
  library(ggplot2)
  library(dplyr)
  
  # ensure xlab is variable name rather than "reorder(df[x])"
  xlab <- colnames(df)[1]
  fill_lab <- colnames(df)[2]
  title <- title
  
  ggplot(df, aes_string(x=paste0(x="reorder(", colnames(df)[1], ", ", colnames(df)[3], ")"),
                        y=colnames(df)[3],
                        fill=colnames(df)[2])) +
    geom_bar(stat="identity") + 
    coord_flip() +
    scale_y_continuous(labels = scales::comma) +
    labs(x = xlab, fill=fill_lab, title=title) +
    theme(plot.title = element_text(hjust = 0.5)) # center the title
}



#### calculate change over time #### 
show_plot_overtime <- function(df, title){
  
  library(ggplot2)
  library(dplyr)
  
  # ensure xlab is variable name rather than "reorder(df[x])"
  xlab <- colnames(df)[1]
  color_lab <- colnames(df)[2]
  title <- title
  df <- df %>% filter(Count > mean(Count), Year < 2018)
  
    ggplot(df, aes_string(x=colnames(df)[1],
                          y=colnames(df)[3],
                          color=paste0(x="reorder(", colnames(df)[2], ", desc(", colnames(df)[3], "))"))) +
    geom_line(stat="identity") +
    scale_y_continuous(labels = scales::comma) +
    labs(x = xlab, color=color_lab, title=title) +
    theme(plot.title = element_text(hjust = 0.5)) # center the title
}


