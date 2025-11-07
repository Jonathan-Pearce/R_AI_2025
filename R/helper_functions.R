library(data.table)
library(dplyr)

subsetEvents <- function(dt, event_date_var, start_date_var, end_date_var) {
  
  dt_time_period <- dt[(get(event_date_var) >= get(start_date_var)) &
                         (get(event_date_var) <= get(end_date_var))]
  
  return(dt_time_period)
  
}

getDataTimePeriod <- function(dt, dt_date_var, time_period){
  
  dt_time_period <- subsetEvents(
    dt = dt, 
    event_date_var = dt_date_var,
    start_date_var = (get(time_period)[1]),
    end_date_var = (get(time_period)[2]))
  
}

isLengthNonZero <- function(x) {
  return(ifelse(length(x) > 0, 1, 0))
}

getFlags <- function(dt, dt_flag_var, data_type, time_period){
  
  dt_flag <- dcast(dt,
                   formula = paste0("ptid ~ ", dt_flag_var),
                   fun.aggregate = isLengthNonZero,
                   value.var = dt_flag_var)
  
  dt_flag <- formatVariableNames(dt_flag, data_type, time_period, "flag")
  
  return(dt_flag)
  
}


getCounts <- function(dt, dt_count_var, data_type, time_period, fill_value = NA){
  
  dt_count <- dcast(dt,
                    formula = paste0("ptid ~ ", dt_count_var),
                    fun.aggregate = length,
                    value.var = dt_count_var,
                    fill = fill_value)
  
  dt_count <- formatVariableNames(dt_count, data_type, time_period, "count") 
  
  return(dt_count)
  
}

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

ImputeMissingPatients <- function(dt, dt_sample, var_to_impute, impute_value){
  merged <- merge(dt_sample[, .(ptid)], dt, by = "ptid", all.x = TRUE)
  merged[, (var_to_impute) := lapply(.SD, function(x) {ifelse(is.na(x), impute_value, x)}), .SDcols = var_to_impute]
  
  return(merged)
}

addPrefix <- function(dt, prefix){
  colnames(dt)[-1] <- paste(prefix, colnames(dt)[-1], sep="_")
  return(dt)
}

addSuffix <- function(dt, suffix){
  colnames(dt)[-1] <- paste(colnames(dt)[-1], suffix, sep="_")
  return(dt)
}

formatVariableNames <- function(dt, data_type, time_period, value_type){
  dt <- addPrefix(dt, data_type)
  dt <- addSuffix(dt, sub("time_period_","",time_period))
  dt <- addSuffix(dt, value_type)
  return(dt)
}

cleanVarNames <- function(dt){
  dt <- dt %>% rename_all(~ gsub(" ", "_", .))
  dt <- dt %>% rename_all(~ gsub("[.-]", "_", .))
  dt <- dt %>% rename_all(~ gsub("[()]", "", .))
  dt <- dt %>% rename_all(~ gsub("/", "_", .))
  return(dt)
}
