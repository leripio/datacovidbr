#' @name CSSEGISandData
#' @title Data from the `CSSEGISandData/COVID-19` repository
#' 
#' @description Extracts updated data from the repository by Johns Hopkins CSSE
#' (https://github.com/CSSEGISandData/COVID-19)
#' by download the file in `.csv` format available and loading it into a comprehensive
#' `tibble` object.
#' 
#' @inheritParams brMinisterioSaude
#' @param by_country If `TRUE` the values are summed over the `Province.State` variable
#' for each `data` and `Country.Region`. In this case, `Lat` and `Long` are reported as the 
#' mean value of all rows for that `Country.Region` value.
#' 
#' @return A `tibble` object.
#' 
#' @importFrom dplyr summarise group_by left_join ungroup
#' @importFrom magrittr %>%
#' @importFrom tidyselect starts_with
#' @export
CSSEGISandData <- function(by_country = TRUE, silent = !interactive()){
  df_cases <- read.csv("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv",
                       stringsAsFactors = FALSE, encoding = "UTF-8")
  df_cases <- tidyr::pivot_longer(df_cases, cols = starts_with("X"),
                                  names_to = "data", values_to = "casosAcumulados")
  df_cases$data <- gsub("X", df_cases$data, replacement = "")
  df_cases$data <- lubridate::as_date(as.character(df_cases$data),
                                      format = "%m.%d.%y")
  if(by_country){
    df_cases <- df_cases %>% group_by(Country.Region, data) %>%
      summarise(Lat = mean(Lat, na.rm = TRUE), Long = mean(Long, na.rm = TRUE),
                casosAcumulados = sum(casosAcumulados, na.rm = TRUE))
  }
  
  df_deaths <- read.csv("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv",
                        stringsAsFactors = FALSE, encoding = "UTF-8")
  df_deaths <- tidyr::pivot_longer(df_deaths, cols = starts_with("X"),
                                   names_to = "data", values_to = "obitosAcumulado")
  df_deaths$data <- gsub("X", df_deaths$data, replacement = "")
  df_deaths$data <- lubridate::as_date(as.character(df_deaths$data),
                                       format = "%m.%d.%y")
  if(by_country){
    df_deaths <- df_deaths %>% group_by(Country.Region, data) %>%
      summarise(obitosAcumulado = sum(obitosAcumulado, na.rm = TRUE),
                Lat = mean(Lat, na.rm = TRUE), Long = mean(Long, na.rm = TRUE))
  }
  
  df_recovered <- read.csv("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv",
                           stringsAsFactors = FALSE, encoding = "UTF-8")
  df_recovered <- tidyr::pivot_longer(df_recovered, cols = starts_with("X"),
                                      names_to = "data", values_to = "recuperadosAcumulado")
  df_recovered$data <- gsub("X", df_recovered$data, replacement = "")
  df_recovered$data <- lubridate::as_date(as.character(df_recovered$data),
                                          format = "%m.%d.%y")
  if(by_country){
    df_recovered <- df_recovered %>% group_by(Country.Region, data) %>%
      summarise(recuperadosAcumulado = sum(recuperadosAcumulado, na.rm = TRUE),
                Lat = mean(Lat, na.rm = TRUE), Long = mean(Long, na.rm = TRUE))
  }
  
  if(!silent) cat("Latest Update: ", as.character(max(df_recovered$data)), "\n")
  
  if(by_country){
    return(df_cases %>%
             left_join(df_deaths, by = c("Country.Region", "data", "Lat", "Long")) %>%
             left_join(df_recovered, by = c("Country.Region", "data", "Lat", "Long")) %>%
             ungroup())
  }
  else {
    return(df_cases %>%
             left_join(df_deaths, by = c("Province.State", "Country.Region", "data", "Lat", "Long")) %>%
             left_join(df_recovered, by = c("Province.State","Country.Region", "data", "Lat", "Long")) %>%
             ungroup())
  }
}

#' @rdname CSSEGISandData
#' @export
CSSEGISandData_us <- function(silent = !interactive()){
  df_cases <- read.csv("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv",
                       stringsAsFactors = FALSE, encoding = "UTF-8")
  df_cases <- tidyr::pivot_longer(df_cases, cols = starts_with("X"),
                                  names_to = "date", values_to = "casosAcumulados")
  df_cases$date <- gsub("X", df_cases$date, replacement = "")
  df_cases$date <- lubridate::as_date(as.character(df_cases$date),
                                      format = "%m.%d.%y")
  
  df_deaths <- read.csv("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv",
                        stringsAsFactors = FALSE, encoding = "UTF-8")
  df_deaths <- tidyr::pivot_longer(df_deaths, cols = starts_with("X"),
                                   names_to = "date", values_to = "obitosAcumulado")
  df_deaths$date <- gsub("X", df_deaths$date, replacement = "")
  df_deaths$date <- lubridate::as_date(as.character(df_deaths$date),
                                       format = "%m.%d.%y")
  
  if(!silent) cat("Latest Update: ", as.character(max(df_cases$date)), "\n")
  
  
  return(df_cases %>%
           left_join(df_deaths, by = c("UID", "iso2", "iso3", "code3", "FIPS", "Admin2", "Province_State",
                                       "Country_Region", "Lat", "Long_", "date", "Combined_Key")) %>%
           ungroup())
}
