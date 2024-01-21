home_page <- fluidPage(sidebarLayout(
  sidebarPanel(
    h3("Task List"),
    br(),
    selectizeInput("selected_courses", "Select Courses: ", 
                   choices = unique(courses_df$course), selected = unique(courses_df$course),
                   multiple = TRUE),
    DTOutput("todo_table"),
    br(),
    textInput("new_task_description", "New Task Description"),
    selectInput("new_course", "Course Name", choices = unique(courses_df$course)),
    dateInput("new_task_due_date", "Due Date", value = Sys.Date()),
    actionButton("add_task", "Add Task"),
    actionButton("delete_selected_tasks", "Delete Selected Tasks"),
    actionButton("edit_selected_task", "Edit Selected Course"),
    width = 6),
  mainPanel(
    uiOutput("cards"),
    width = 6
  )
))

add_class_page <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      h3("Add New Class"),
      br(),
      textInput("new_course_name", "Course Name"),
      textInput("new_slot", "Slot"),
      selectInput("new_type", "Type", choices = c("Tut", "Lab", "Lec", "Workshop")),
      selectInput("new_day", "Day", choices = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
                                                "Saturday", "Sunday")),
      fluidRow(
        column(6, timeInput("new_st_time", "Start Time:", value = "10:00:00", seconds = FALSE, minute.steps = 15)),
        column(6, timeInput("new_en_time", "End Time:", value = "11:00:00", seconds = FALSE, minute.steps = 15))
      ),
      textInput("new_tele_link", "Telegram Link"),
      textInput("new_gdrive_link", "Google Drive Link"),
      actionButton("add_course", "Add Course"),
      width = 4
    ),
    mainPanel(
      DTOutput("courses_table"),
      actionButton("delete_selected_courses", "Delete Selected Courses"),
      actionButton("edit_selected_course", "Edit Selected Course"),
      width = 8
    )
  )
)

course_page <- fluidPage(
  h1(textOutput("course_page_heading")),
  sidebarLayout(
    sidebarPanel(
      actionButton("telegram_button", "Open Telegram"),
      actionButton("gdrive_button", "Open Google Drive"),
      h3("Student List"),
      fileInput('upload_file', 'Upload CSV File',
                accept=c('.csv')),
      hr(),
      DTOutput("student_table"),
      br(),
      textInput("new_student_name", "New Student Name"),
      textInput("new_student_no", "Student No"),
      textInput("new_student_email", "Student Email"),
      textInput("new_student_netid", "Student NUSNET ID"),
      actionButton("add_student", "Add Student"),
      actionButton("delete_student", "Delete Student"),
      actionButton("edit_selected_student", "Edit Student"),
      hr(),
      actionButton("take_attendance", "Take Attendance"),
      actionButton("manage_claims", "Manage Claims"),
      actionButton("analytics_button", "Course Analytics"),
      width = 6),
    mainPanel(uiOutput("course_tab"), width = 6)
  )
)

ui <- fluidPage(
  shinyjs::useShinyjs(),
  theme = shinytheme("simplex"),
  tags_head,
  navbarPage(id = 'navbar',
             "TA Course Managment Platform",
             tabPanel("Home Page" , icon = icon("home"), home_page),
             tabPanel("Modify Classes", icon = icon("pen-to-square"), add_class_page),
             tabPanel("Course Details", icon = icon("info-circle"), course_page),
             tabPanel("Save", icon = icon("download"), actionButton("export_button", "Export to CSV"))
  )
  
)