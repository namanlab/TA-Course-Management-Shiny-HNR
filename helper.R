card <- function(.icon_class, .course_name, .course_slot, .course_type, .course_day, 
                 .course_st_time, .course_en_time) {
  HTML(
    paste0(
      '<div class="card" style="box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); border-radius: 8px; overflow: hidden;">
      <table><tr>
      <td> <i class="', .icon_class, '" style="font-size: 64px; margin-right: 16px; margin-left: 8px;"></i><td>',
      '<div class="container" style="padding: 12px;">
        <h4 style="margin-bottom: 8px; margin-right: 16px;"> Course: ', .course_name, '</h4>
        <hr style="margin: 8px 0;">
        <p style="margin: 8px 0;">', .course_type , ' ', .course_slot, '</p>
        <hr style="margin: 8px 0;">
        <p style="margin: 8px 0;">', .course_day , ': ', .course_st_time, ' - ', .course_en_time, '</p>
        </div>',
      '</tr></table>
      </div>',
      '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">'
    )
  )
}

edit_course_modal <- modalDialog(
  textInput("edit_course_name_course", "Course Name"),
  textInput("edit_slot_course", "Slot"),
  selectInput("edit_type_course", "Type", choices = c("Tut", "Lab", "Lec", "Workshop")),
  selectInput("edit_day_course", "Day", choices = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")),
  fluidRow(
    column(6, timeInput("edit_st_time_course", "Start Time:", value = "10:00:00", seconds = FALSE, minute.steps = 15)),
    column(6, timeInput("edit_en_time_course", "End Time:", value = "11:00:00", seconds = FALSE, minute.steps = 15))
  ),
  textInput("edit_tele_link_course", "Telegram Link"),
  textInput("edit_gdrive_link_course", "Google Drive Link"),
  actionButton("save_changes_course", "Save Changes"),
  width = 4
)

edit_task_modal <- modalDialog(
  textInput("edit_task_description", "Task Description"),
  selectInput("edit_task_course", "Course Name", choices = unique(courses_df$course)),
  dateInput("edit_task_due_date", "Due Date", value = Sys.Date()),
  actionButton("save_changes_task", "Save Changes"),
  width = 4
)

edit_student_modal <- modalDialog(
  textInput("edit_student_name", "Student Name"),
  textInput("edit_student_no", "Student No"),
  textInput("edit_student_email", "Student Email"),
  textInput("edit_student_netid", "Student NUSNET ID"),
  actionButton("save_changes_student", "Save Changes"),
  width = 4
)

edit_claim_modal <- modalDialog(
  dateInput("edit_claim_date", "Date", value = Sys.Date()),
  fluidRow(
    column(6, timeInput("edit_claim_time_in", "Time In:", value = "10:00:00", seconds = FALSE, minute.steps = 15)),
    column(6, timeInput("edit_claim_time_out", "Time Out:", value = "11:00:00", seconds = FALSE, minute.steps = 15))
  ),
  textInput("edit_claim_task", "Task"),
  textInput("edit_claim_rate_ph", "Rate per Hour", value = "40"),
  actionButton("save_changes_claim", "Save Changes"),
  width = 4
)



tags_head <- tags$head(
  tags$style(".card {
                 display: flex;
                 flex-wrap: wrap;
                 box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
                 transition: 0.3s;
                 width: 250px;
                 margin: 10px;
               }
               .card:hover {
                 box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
               }
               .container {
                 padding: 16px;
               }
               .navbar {
                 padding: 15px;
               }
               .navbar-brand {
                 font-size: 32px;
               }
               #navbar li[data-value='Course Details'] {
                 display: none;
               }"
  )
  
)
