library(data.table)
library(dplyr)

#' Subset events by a date window
#'
#' Filter a data.table of events to the rows where an event date falls within
#' a specified start and end date (inclusive).
#'
#' @param dt A data.table containing event records.
#' @param event_date_var A string naming the column in \code{dt} that holds the event date.
#' @param start_date_var A string naming the variable or column that holds the start date.
#' @param end_date_var A string naming the variable or column that holds the end date.
#'
#' @return A data.table containing only rows where the event date is between start and end.
#' @examples
#' \dontrun{
#' subsetEvents(dt = events_dt, event_date_var = "event_date",
#'              start_date_var = "start_date", end_date_var = "end_date")
#' }
#' @export
subsetEvents <- function(dt, event_date_var, start_date_var, end_date_var) {
  
  dt_time_period <- dt[(get(event_date_var) >= get(start_date_var)) &
                         (get(event_date_var) <= get(end_date_var))]
  
  return(dt_time_period)
  
}

#' Wrapper to subset by a two-element time period
#'
#' Calls \code{subsetEvents} using a named time period (vector of length 2).
#'
#' @param dt A data.table containing event records.
#' @param dt_date_var A string naming the date column in \code{dt} to filter on.
#' @param time_period A string naming an object (vector of length 2) containing start and end dates.
#'
#' @return A data.table filtered to the specified time period.
#' @examples
#' \dontrun{
#' getDataTimePeriod(events_dt, "event_date", "time_period_q1")
#' }
#' @export
getDataTimePeriod <- function(dt, dt_date_var, time_period){
  
  dt_time_period <- subsetEvents(
    dt = dt, 
    event_date_var = dt_date_var,
    start_date_var = (get(time_period)[1]),
    end_date_var = (get(time_period)[2]))
  
}

#' Binary indicator aggregator for dcast
#'
#' Returns 1 when the length of x is greater than zero, otherwise 0. Intended
#' for use as \code{fun.aggregate} in \code{data.table::dcast} to create flags.
#'
#' @param x A vector passed by the aggregator.
#' @return Integer 1 or 0.
#' @examples
#' isLengthNonZero(1:3)
#' @export
isLengthNonZero <- function(x) {
  return(ifelse(length(x) > 0, 1, 0))
}

#' Create patient-level flag (binary) wide table
#'
#' Cast an event-level table to a wide patient-level table of flags (0/1)
#' indicating presence of each value of \code{dt_flag_var} per patient.
#'
#' @param dt A data.table of events containing a \code{ptid} column.
#' @param dt_flag_var A string naming the column to pivot into flag columns.
#' @param data_type A string prefix to add to output variable names (e.g., event type).
#' @param time_period A string describing the time period to include in output names.
#'
#' @return A data.table with \code{ptid} and one column per unique value of \code{dt_flag_var},
#'   formatted with prefixes/suffixes via \code{formatVariableNames}.
#' @examples
#' \dontrun{
#' getFlags(events_dt, "condition", "diagnosis", "time_period_90d")
#' }
#' @export
getFlags <- function(dt, dt_flag_var, data_type, time_period){
  
  dt_flag <- dcast(dt,
                   formula = paste0("ptid ~ ", dt_flag_var),
                   fun.aggregate = isLengthNonZero,
                   value.var = dt_flag_var)
  
  dt_flag <- formatVariableNames(dt_flag, data_type, time_period, "flag")
  
  return(dt_flag)
  
}


#' Create patient-level counts wide table
#'
#' Cast an event-level table to a wide patient-level table of counts of each
#' value of \code{dt_count_var}.
#'
#' @param dt A data.table of events containing a \code{ptid} column.
#' @param dt_count_var A string naming the column to pivot into count columns.
#' @param data_type A string prefix to add to output variable names.
#' @param time_period A string describing the time period to include in output names.
#' @param fill_value Value used to fill missing combinations (default NA).
#'
#' @return A data.table with \code{ptid} and count columns formatted via \code{formatVariableNames}.
#' @examples
#' \dontrun{
#' getCounts(events_dt, "medication", "rx", "time_period_365d", fill_value = 0)
#' }
#' @export
getCounts <- function(dt, dt_count_var, data_type, time_period, fill_value = NA){
  
  dt_count <- dcast(dt,
                    formula = paste0("ptid ~ ", dt_count_var),
                    fun.aggregate = length,
                    value.var = dt_count_var,
                    fill = fill_value)
  
  dt_count <- formatVariableNames(dt_count, data_type, time_period, "count") 
  
  return(dt_count)
  
}

#' Create patient-level aggregated values wide table
#'
#' Cast an event-level table to a wide patient-level table of aggregated values
#' (e.g., mean, median) of \code{dt_value_var} by \code{dt_name_var}.
#'
#' @param dt A data.table of events containing a \code{ptid} column.
#' @param dt_value_var A string naming the numeric/value column to aggregate.
#' @param dt_name_var A string naming the column whose unique values become columns.
#' @param data_type A string prefix to add to output variable names.
#' @param time_period A string describing the time period to include in output names.
#' @param date_description Optional string to prepend to the aggregation name (e.g., "first_date").
#' @param FUN_value A string naming the aggregation function to apply (e.g., "mean", "median").
#' @param fill_value Value used to fill missing combinations (default NA).
#'
#' @return A data.table with \code{ptid} and aggregated value columns formatted via \code{formatVariableNames}.
#' @examples
#' \dontrun{
#' getValues(labs_dt, "value", "lab_name", "labs", "time_period_30d", FUN_value = "mean")
#' }
#' @export
getValues <- function(dt, dt_value_var, dt_name_var, data_type, time_period, date_description = NA ,FUN_value = "mean", fill_value = NA){
  
  dt_value <- dcast(dt,
                    formula = paste0("ptid ~ ",dt_name_var),
                    fun.aggregate = get(FUN_value),
                    value.var = dt_value_var,
                    fill = fill_value)
  
  if(!is.na(date_description)){
    value_type <- paste0(date_description, "_", FUN_value)
  }else{
    value_type <- FUN_value
  }
  
  dt_value <- formatVariableNames(dt_value, data_type, time_period, value_type)
  
  return(dt_value)
  
}

#' Ensure all sample patients are present and impute missing values
#'
#' Merge \code{dt} with a sample of patient IDs and replace NA values in the
#' specified columns with a provided imputation value.
#'
#' @param dt A data.table with patient-level variables including \code{ptid}.
#' @param dt_sample A data.table (or data.frame) containing the set of patient IDs to keep.
#' @param var_to_impute Character vector of column names in \code{dt} to impute.
#' @param impute_value A scalar value used to replace NA in \code{var_to_impute}.
#'
#' @return A data.table containing all patient IDs from \code{dt_sample} and
#'   columns from \code{dt} with missing values imputed.
#' @examples
#' \dontrun{
#' ImputeMissingPatients(patient_vals_dt, sample_dt, "age", impute_value = -1)
#' }
#' @export
ImputeMissingPatients <- function(dt, dt_sample, var_to_impute, impute_value){
  merged <- merge(dt_sample[, .(ptid)], dt, by = "ptid", all.x = TRUE)
  merged[, (var_to_impute) := lapply(.SD, function(x) {ifelse(is.na(x), impute_value, x)}), .SDcols = var_to_impute]
  
  return(merged)
}

#' Add a prefix to variable names (except the first column)
#'
#' Prepend a prefix and an underscore to every column name except the first
#' (commonly the \code{ptid} column).
#'
#' @param dt A data.table or data.frame.
#' @param prefix A string prefix to add.
#' @return The modified \code{dt} with updated column names.
#' @examples
#' addPrefix(dt, "labs")
#' @export
addPrefix <- function(dt, prefix){
  colnames(dt)[-1] <- paste(prefix, colnames(dt)[-1], sep="_")
  return(dt)
}

#' Add a suffix to variable names (except the first column)
#'
#' Append an underscore and suffix to every column name except the first.
#'
#' @param dt A data.table or data.frame.
#' @param suffix A string suffix to add.
#' @return The modified \code{dt} with updated column names.
#' @examples
#' addSuffix(dt, "30d")
#' @export
addSuffix <- function(dt, suffix){
  colnames(dt)[-1] <- paste(colnames(dt)[-1], suffix, sep="_")
  return(dt)
}

#' Format variable names by adding data type, time period, and value type
#'
#' Convenience function that applies \code{addPrefix} and \code{addSuffix} in sequence
#' to create consistent variable naming: prefix (data_type), suffix (time_period),
#' suffix (value_type).
#'
#' @param dt A data.table or data.frame.
#' @param data_type A string prefix to add.
#' @param time_period A string describing the time period; the function will remove
#'   any leading "time_period_" before using it as a suffix.
#' @param value_type A string describing the value type (e.g., "count", "flag", "mean").
#'
#' @return The modified \code{dt} with formatted column names.
#' @examples
#' formatVariableNames(dt, "labs", "time_period_30d", "mean")
#' @export
formatVariableNames <- function(dt, data_type, time_period, value_type){
  dt <- addPrefix(dt, data_type)
  dt <- addSuffix(dt, sub("time_period_","",time_period))
  dt <- addSuffix(dt, value_type)
  return(dt)
}

#' Clean variable names to a consistent format
#'
#' Replace spaces, slashes and punctuation commonly found in column names with
#' underscores and remove parentheses.
#'
#' @param dt A data.frame or data.table.
#' @return The modified \code{dt} with cleaned column names.
#' @examples
#' cleanVarNames(df)
#' @export
cleanVarNames <- function(dt){
  dt <- dt %>% rename_all(~ gsub(" ", "_", .))
  dt <- dt %>% rename_all(~ gsub("[.-]", "_", .))
  dt <- dt %>% rename_all(~ gsub("[()]", "", .))
  dt <- dt %>% rename_all(~ gsub("/", "_", .))
  return(dt)
}
