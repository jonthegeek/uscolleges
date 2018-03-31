library(dplyr)
library(DT)
library(purrr)
library(readr)
library(readxl)
library(rlang)
library(stringr)
library(tidyr)

college_scorecard_2015_2016 <- readr::read_csv(
  "data-raw/MERGED2015_16_PP.csv",
  na = c("", "NA", "NULL")
)

data_dictionary <- readxl::read_xlsx(
  "data-raw/CollegeScorecardDataDictionary.xlsx", 
  sheet = "data_dictionary"
)

column_definitions <- data_dictionary %>% 
  dplyr::select(
    ugly_column_name = `VARIABLE NAME`, 
    better_column_name = `developer-friendly name`, 
    data_type = `API data type`
  ) %>% 
  dplyr::filter(ugly_column_name != "")

column_definitions <- column_definitions %>%
  dplyr::mutate(ugly_column_name = stringr::str_to_upper(ugly_column_name)) %>% 
  dplyr::filter(ugly_column_name %in% colnames(college_scorecard_2015_2016)) %>% 
  dplyr::mutate(data_type = dplyr::recode(
    data_type, 
    integer = "integer",
    autocomplete = "character", 
    string = "character", 
    float = "double"
  ))
defined_columns <- dplyr::intersect(
  colnames(college_scorecard_2015_2016), 
  column_definitions$ugly_column_name
)

latest_college_scorecard <- purrr::map_dfc(defined_columns, function(this_column) {
  this_column_contents <- college_scorecard_2015_2016[[this_column]]
  # If this column has no variability, let's get rid of it.
  this_column_variability <- unique(this_column_contents)
  if(length(this_column_variability) == 1) {
    NULL
  } else {
    definition <- column_definitions %>% 
      dplyr::filter(ugly_column_name == this_column)
    data_type <- definition$data_type[[1]]
    suppressWarnings(class(this_column_contents) <- data_type)
    better_name <- definition$better_column_name[[1]]
    dplyr::tibble(
      !! better_name := this_column_contents
    )
  }
})

sub_dictionaries <- data_dictionary %>% 
  dplyr::filter(!is.na(VALUE)) %>% 
  dplyr::select(better_column_name = `developer-friendly name`, current_value = VALUE, target_value = LABEL) %>% 
  tidyr::fill(better_column_name, .direction = "down")

factor_columns <- unique(sub_dictionaries$better_column_name)
latest_college_scorecard_factored <- purrr::map_dfc(colnames(latest_college_scorecard), function(this_column) {
  if(this_column %in% factor_columns) {
    # Translate this to a factor.
    this_dictionary <- sub_dictionaries %>%
      dplyr::filter(better_column_name == this_column) %>%
      dplyr::rename(!! this_column := current_value) %>% 
      dplyr::select(-better_column_name)
    new_column <- latest_college_scorecard[this_column] %>%
      dplyr::left_join(this_dictionary) %>%
      dplyr::select(target_value) %>% 
      dplyr::mutate(target_value = as.factor(target_value))
    names(new_column) <- this_column
    new_column
  } else {
    latest_college_scorecard[this_column]
  }
})

uscolleges <- latest_college_scorecard_factored
devtools::use_data(uscolleges, overwrite = TRUE)

uscolleges_data_dictionary <- data_dictionary %>% 
  dplyr::select(
    field = `developer-friendly name`, 
    API_field = `VARIABLE NAME`, 
    description = `NAME OF DATA ELEMENT`, 
    category = `dev-category`
  ) %>% 
  dplyr::filter(field %in% colnames(uscolleges)) %>% 
  dplyr::mutate(category = as.factor(category))

devtools::use_data(uscolleges_data_dictionary, overwrite = TRUE)
