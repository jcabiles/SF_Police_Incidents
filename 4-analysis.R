#### Overview Stats ####

table_preview <- head(sfpd_incidents, n=10)

# table and plot for unique count of each Category
table_unique_categ <- show_unique_count(sfpd_incidents, Category)
plot_unique_categ <- plot_unique_count_xy(table_unique_categ, "Most Common SFPD Incidents between \n 2003 to 2018")


# table and plot for unique count of each Description
# show Top 40 on plot since there are too many
table_unique_descrip <- show_unique_count(sfpd_incidents, Description)
# plot only Top 20 of Description
plot_unique_descrip <- plot_unique_count_xy((table_unique_descrip %>% top_n(40)),
                                              "Most Common SFPD Incident Descriptions between \n 2003 to 2018")


# table and plot for unique count of each Resolution
table_unique_res <- show_unique_count(sfpd_incidents, Resolution)
plot_unique_res <- plot_unique_count_xy(table_unique_res, 
                                              "Most Common Resolutions to SFPD Incidents between \n 2003 to 2018")




#### Resolutions ####

# subset data
sfpd_top3_resolutions <- sfpd_incidents %>%
  filter(Resolution %in% c("none", "arrest, booked", "arrest, cited"))


# table count of unique Category for Top 3 Resolutions + plot
table_top3_res_categ <- show_unique_count(sfpd_top3_resolutions, Category, Resolution)


# plot categories that led to arrest
plot_top3_res_categ_arrest <- plot_unique_count_xyfill(table_top3_res_categ %>% filter(Resolution != "none"),
                                                "SFPD Incidents That Led to Arrests")



# table of descriptions of incidents that led to arrest
top5_arrest_categ <- c("other offenses", "drug/narcotic", "warrants", "assault", "larceny/theft")
table_top3_res_categ_arrest_desc <- sfpd_top3_resolutions %>%
  filter(Resolution != "none",
         Category %in% top5_arrest_categ) %>%
  show_unique_count(Category, Description, Resolution)

# plot
plot_top3_res_categ_arrest_desc_cited <- plot_unique_count_xyfill(table_top3_res_categ_arrest_desc %>%
                                                              filter(Count > mean(.$Count), Resolution=="arrest, cited") %>% select(-1),
                                                            "Descriptions of Top 5 SFPD Incident Categories That Led to Arrest") +
  scale_fill_manual(values=c("#4699dd"))

# plot
plot_top3_res_categ_arrest_desc_booked <- plot_unique_count_xyfill(table_top3_res_categ_arrest_desc %>% top_n(20) %>%
                                                                     filter(Resolution=="arrest, booked") %>% select(-1),
                                                                   "Descriptions of Top 5 SFPD Incident Categories That Led to Arrest") +
  scale_fill_manual(values=c("#56ddc5"))



# plot categories that led to no resolution
plot_top3_res_categ_nores <- plot_unique_count_xyfill(table_top3_res_categ %>% filter(Resolution == "none"),
                                                       "SFPD Incidents That Had No Resolution")



# table of descriptions of incidents that had NO RESOLUTION
top10_nores <- c("larceny/theft", "non-criminal", "vehicle theft", "assault", "vandalism", "other offenses",
                 "burglary", "suspicious occ", "robbery", "fraud")
table_top10_nores <- sfpd_top3_resolutions %>%
  filter(Resolution == "none",
         Category %in% top10_nores) %>%
  show_unique_count(Category, Description, Resolution)


# plot descriptions
plot_top10_nores_desc <- plot_unique_count_xyfill(table_top10_nores %>% top_n(20) %>% select(-1),
                                                  "Descriptions of Top 10 SFPD Incident Categories That Were Not Resolved")



#### Change Over the Years ####

# change in Category over time
yr_cat <- show_unique_count(sfpd_incidents, Year, Category)
p_yr_cat <- show_plot_overtime(yr_cat, "Title")



# change in Description over time for Top Category (larceny/theft) only
yr_desc <- show_unique_count(sfpd_incidents %>% filter(Category == "larceny/theft"), Year, Description)
p_yr_desc_larceny <- show_plot_overtime(yr_desc %>% filter(Count > mean(Count)), "Title")



# save entire workspace to load into RMarkdown
save.image(file = "SF_Crimes_workspace.RData")