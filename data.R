courses_df <- data.frame(course = c("CS2040", "IT1244", "DSA2101", "DSA2101", "NM2207"), 
                         slot = c("1D", "05", "05", "06", "01"), 
                         type = c("Lab", "Tut", "Tut", "Tut", "Lec"), 
                         day = c("Friday", "Tuesday", "Friday", "Friday", "Tuesday"),
                         st_time  = c("16:00", "09:00", "10:00", "11:00", "18:00"),
                         en_time  = c("18:00", "10:00", "11:00", "12:00", "21:00"),
                         id = 1:5,
                         tele_link = c("https://web.telegram.org/", "https://web.telegram.org/",
                                       "https://web.telegram.org/", "https://web.telegram.org/",
                                       "https://web.telegram.org/"),
                         gdrive_link = c("https://drive.google.com/drive/my-drive", "https://drive.google.com/drive/my-drive",
                                         "https://drive.google.com/drive/my-drive", "https://drive.google.com/drive/my-drive",
                                         "https://drive.google.com/drive/my-drive"))

todo_df <- data.frame(
  course_name = c("CS2040", "DSA2101", "CS2040", "IT1244"),
  task_description = c("Prepare lecture slides", "Grade assignments", "Hold office hours", "Prepare lab materials"),
  due_date = as.Date(c("2024-01-15", "2024-03-20", "2024-01-18", "2024-02-22")),
  row_num = 1:4
)


columns_attendance <- c("course_id", "stu_name", "stu_no", "stu_nusnet_id", "stu_email", 
                        "week_no", "res", "stu_internal_id")
attendance_df = data.frame(matrix(nrow = 0, ncol = length(columns_attendance)))
colnames(attendance_df) <- columns_attendance

columns_claims <- c("course_id", "date", "time_in", "time_out", "task", 
                        "rate_ph")
claims_df = data.frame(matrix(nrow = 0, ncol = length(columns_claims)))
colnames(claims_df) <- columns_claims


# Function to generate unique student data
generate_student_data <- function(course, num_students) {
  data.frame(
    course_id = rep(course, each = 13 * num_students),
    stu_name = paste0("Student", rep(1:num_students, each = 13)),
    stu_no = rep(paste0("A", sample(1000000:9999999, num_students)), each = 13),
    stu_nusnet_id = rep(paste0("nusnet", sample(100:999, num_students)), each = 13),
    stu_email = paste0("student", rep(1:num_students, each = 13), "@example.com"),
    week_no = rep(1:13, times = num_students),
    res = sample(c(0, 1), num_students * 13, replace = T),
    stu_internal_id = rep(1:num_students, each = 13)
  )
}

# Generate data for each course
attendance_df <- rbind(
  generate_student_data(1, 25),
  generate_student_data(2, 20),
  generate_student_data(3, 40),
  generate_student_data(4, 40),
  generate_student_data(5, 30)
)

# Dummy data for claims_df with variation
claims_df <- data.frame(
  course_id = rep(1:5, each = 9),
  date = sample(seq(as.Date('2024/01/01'), as.Date('2024/05/01'), by="day"), 45),
  time_in = rep(format(as.POSIXct(c("10:00:00", "09:30:00", "11:15:00"), format = "%T"), format = "%H:%M"), 15),
  time_out = rep(format(as.POSIXct(c("11:00:00", "10:45:00", "12:30:00"), format = "%T"), format = "%H:%M"), 15),
  task = rep(c("Teaching", "Meeting", "Grading"), each = 15),
  rate_ph = rep(40, each = 45)
)
