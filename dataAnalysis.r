# Read the CSV file
# Check if the file exists
if (file.exists("data.csv")) {
  # File exists, load it into df
  df <- read.csv("data.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)
  print("File opened successfully.")
  
  # Print the column names properly
  print("Column names:")
  print(colnames(df))
  
  #---------------------------------------PARSING DATA---------------------------------------
  
  #=======================================FREQUENCY========================================
  # Parse frequency columns to integers
  # "Daily" -> 1, "Weekly" -> 2, "Monthly" -> 3, "Rarely" -> 4
  
  # Access and parse the F.Google column
  if ("F.Google" %in% colnames(df)) {
    f_google_data <- df$F.Google
    df$F.Google <- as.integer(factor(df$F.Google, 
                                     levels = c("Daily", "Weekly", "Monthly", "Rarely"), 
                                     labels = 1:4))
  }

  # Access and parse the F.Chat column
  if ("F.Chat" %in% colnames(df)) {
    f_chat_data <- df$F.Chat
    df$F.Chat <- as.integer(factor(df$F.Chat, 
                                   levels = c("Daily", "Weekly", "Monthly", "Rarely"), 
                                   labels = 1:4))
  }
  
  #=======================================EDUCATION========================================
  # Access and parse the Education column
  # "High school" -> 1, "Bachelor's degree" -> 2, "Master's degree" -> 3, "PhD" -> 4
  education_data <- df$Education
  df$Education <- as.integer(factor(df$Education, 
                                   levels = c("High school", "Bachelor's degree", "Master's degree", "PhD"), 
                                   labels = 1:4))
  
  #=======================================EMPLOYMENT========================================
  # Access and parse the Employment column
  # "Unemployed" -> 1, "Student" -> 2, "Employed" -> 3
  employment_data <- df$Employment
  df$Employment <- as.integer(factor(df$Employment, 
                                    levels = c("Unemployed", "Student", "Employed"), 
                                    labels = 1:3))  

  #=======================================GENDER========================================
  # Parse the gender column
  gender_data <- df$Gender
  df$Gender <- as.integer(factor(df$Gender, 
                               levels = c("Male", "Female", "Non-binary / Third gender"), 
                               labels = 1:3))

  # Extract demographic data (first 8 columns)
  demographic_data <- df[, 1:8]

  # Define and extract Google-related columns
  g_columns <- c("F.Google", "Purp.Google", "AVG.MGT", "AVG.MGP", "AVG.TGT", "AVG.TGP")
  print("Google columns:")
  print(g_columns)
  google_data <- df[, g_columns]

  # Define and extract ChatGPT-related columns
  c_columns <- c("F.Chat", "Purp.Chat", "AVG.MCT", "AVG.MCP", "AVG.TCT", "AVG.TCP")
  print("ChatGPT columns:")
  print(c_columns)
  chat_data <- df[, c_columns]
  print(head(chat_data))

  # Combine demographics and parsed data and export to CSV
  df_clean <- cbind(demographic_data, google_data, chat_data)
  print("Cleaned data:")
  print(head(df_clean))
  write.csv(df_clean, "cleaned_data.csv", row.names = FALSE)

  # Column descriptions for reference:
  # Age,Gender,Education,employment,F-Chat,Purp-Chat,F-Google,Purp-Google,AVG-MGT,AVG-MGP,AVG-MCT,AVG-MCP,AVG-MTG,AVG-TGP,AVG-TCT,AVG-TCP
  # F-Chat: frequency of using ChatGPT
  # Purp-Chat: purpose of using ChatGPT
  # F-Google: frequency of using Google
  # Purp-Google: purpose of using Google
  # AVG-MGT: Average-MedicalGoogleTrust, trust in Google for medical purposes
  # AVG-MGP: Average-MedicalGooglePreference. Preference of Google for medical purposes
  # AVG-MCT: Average-MedicalChatGPTTrust, trust in ChatGPT for medical purposes
  # AVG-MCP: Average-MedicalChatGPTPreference, preference of ChatGPT for medical purposes
  # AVG-TGT: Average-TripGoogleTrust, trust in Google for trip planning purposes
  # AVG-TGP: Average-TripGooglePreference, preference of Google for trip planning purposes
  # AVG-TCT: Average-TripChatGPTTrust, trust in ChatGPT for trip planning purposes
  # AVG-TCP: Average-TripChatGPTPreference, preference of ChatGPT for trip planning purposes

} else {
  # File does not exist, log an error
  print("File not found.")
}