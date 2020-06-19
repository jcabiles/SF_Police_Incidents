library(tidyverse)

# define vector for later use
dayofweek <- c("Monday", 
               "Tuesday",
               "Wednesday",
               "Thursday",
               "Friday",
               "Saturday",
               "Sunday")

# set to correct datatypes
sfpd_incidents <- raw_incidents %>%
  
  rename(Description = Descript) %>%
  
  # convert Date and Time to correct datatype
  mutate(Date = lubridate::mdy(Date),
         
         Time = hms::as.hms(Time, as.difftime(secs, units = "secs")),
         
         # show days of week in correct order
         DayOfWeek = factor(DayOfWeek, levels= dayofweek),
         
         # lowercase to make string-matching easier
         Category = tolower(Category),
         Description = tolower(Description),
         Resolution = tolower(Resolution),
         
         # add month and year
         Month = lubridate::month(Date, label=TRUE),
         Year = lubridate::year(Date),
         
         # ensure that time is given as hh:ss instead of just seconds
         Time = hms::as.hms(Time, as.difftime(secs, units = "secs")))



# add major categories of crimes
# https://www.legalmatch.com/law-library/article/what-are-the-different-types-of-crimes.html

crimes_personal <- c("assault", "battery", "false imprisonment", "kidnapping",
                    "homicide", "manslaughter", "rape", "sexual")
crimes_property <- c("larceny", "theft", "robbery", "burglary", "arson",
                     "embezzlement", "forgery", "forge", "stolen")
crimes_inchoate <- c("attempted", "solicitation", "solicit", "conspiracy")
crimes_statutory <- c("alcohol", "drunk", "influence", "minor")



sfpd_incidents <- sfpd_incidents %>%
  mutate(PersonalCrime = ifelse(grepl(paste(crimes_personal, collapse = "|"),
                                      Description,
                                      ignore.case = TRUE),
                                "Yes","No"),
         
         PropertyCrime = ifelse(grepl(paste(crimes_property, collapse = "|"),
                                      Description,
                                      ignore.case = TRUE),
                                "Yes","No"),
         
         InchoateCrime = ifelse(grepl(paste(crimes_inchoate, collapse = "|"),
                                      Description,
                                      ignore.case = TRUE),
                                "Yes","No"),
         
         StatutoryCrime = ifelse(grepl(paste(crimes_statutory, collapse = "|"),
                                      Description,
                                      ignore.case = TRUE),
                                "Yes","No"))



# add category for most common crimes
autocrimes <- c("auto", "truck", "car")
theftcrimes <- c("theft", "stolen", "robbery", "burglary")
drugcrimes <- c("drug", "narcotic")

sfpd_incidents <- sfpd_incidents %>%
  mutate(AutoCrime = ifelse(grepl(paste(autocrimes, collapse = "|"),
                                  Description,
                                  ignore.case = TRUE),
                            "Yes","No"),
         
         TheftCrime = ifelse(grepl(paste(theftcrimes, collapse = "|"),
                                   Description,
                                   ignore.case = TRUE),
                             "Yes","No"),
         
         DrugCrime = ifelse(grepl(paste(drugcrimes, collapse = "|"),
                                  Description,
                                  ignore.case = TRUE),
                            "Yes","No"))



save(sfpd_incidents, file = "sfpd_incidents_cleaned.csv")
