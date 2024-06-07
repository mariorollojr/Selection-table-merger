# Load necessary libraries
library(dplyr)
library(readr)
library(stringr)

# Function to merge all text files in a folder into a single data frame
merge_text_files <- function(folder_path) {
  # List all text files in the folder
  file_list <- list.files(path = folder_path, pattern = "\\.txt$", full.names = TRUE)
  
  # Read all text files and add a column with the file name
  data_list <- lapply(file_list, function(file) {
    data <- read_tsv(file, col_names = TRUE)
    data <- data %>% mutate(source_file = basename(file))
    return(data)
  })
  
  # Combine all data frames into one
  combined_data <- bind_rows(data_list)
  
  # Extract timestamp from the source file names and add it as a column
  combined_data <- combined_data %>%
    mutate(timestamp = str_extract(source_file, "\\d{8}_\\d{6}")) %>%
    arrange(timestamp) %>%
    select(source_file, everything()) # Move source_file column to the front
  
  return(combined_data)
}

# Example usage
folder_path <- "path/to/your/folder"  # Replace with the path to your folder
merged_data <- merge_text_files(folder_path)

# Print the merged data
print(merged_data)
