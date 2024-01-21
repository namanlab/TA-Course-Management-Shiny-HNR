# Create empty data frames with 0 rows and specified column names
courses_df <- data.frame(matrix(ncol = 9, nrow = 0))
colnames(courses_df) <- c("course", "slot", "type", "day", "st_time", "en_time", "id", "tele_link", "gdrive_link")

todo_df <- data.frame(matrix(ncol = 4, nrow = 0))
colnames(todo_df) <- c("course_name", "task_description", "due_date", "row_num")

columns_attendance <- c("course_id", "stu_name", "stu_no", "stu_nusnet_id", "stu_email", "week_no", "res", "stu_internal_id")
attendance_df <- data.frame(matrix(ncol = length(columns_attendance), nrow = 0))
colnames(attendance_df) <- columns_attendance

columns_claims <- c("course_id", "date", "time_in", "time_out", "task", "rate_ph")
claims_df <- data.frame(matrix(ncol = length(columns_claims), nrow = 0))
colnames(claims_df) <- columns_claims

# Create the data folder if it doesn't exist
dir.create("data", showWarnings = FALSE)

# Save datasets to CSV files
write.csv(courses_df, file = "data/courses_df.csv", row.names = FALSE)
write.csv(todo_df, file = "data/todo_df.csv", row.names = FALSE)
write.csv(attendance_df, file = "data/attendance_df.csv", row.names = FALSE)
write.csv(claims_df, file = "data/claims_df.csv", row.names = FALSE)
