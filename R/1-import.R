# import
url <- "https://data.sfgov.org/api/views/tmnf-yvry/rows.csv"
raw_incidents <- readr::read_csv(url)

# save csv
write.csv(raw_incidents, file="Police_Department_Incident_Reports__Historical_2003_to_May_2018.csv")