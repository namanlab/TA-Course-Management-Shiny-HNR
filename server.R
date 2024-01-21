server <- function(input, output, session) {
  hideTab(inputId = "navbar", target = "Course Details")
  
  # TASK LIST
  todo_data <- reactiveValues(data = todo_df)
  mod_todo_data <- reactive({
    todo_data$data %>% 
      filter(course_name %in% input$selected_courses) %>%
      arrange(due_date) %>%
      rename("Course" = "course_name", "Task" = "task_description", "Due Date" = "due_date")
  })
  output$todo_table <- renderDT({
    datatable(mod_todo_data() %>% select(-row_num), 
              options = list(pageLength = 10, width = "100%", scrollX = TRUE))
  })   
  observeEvent(input$add_task, {
    new_task <- data.frame(
      course_name = input$new_course,
      task_description = input$new_task_description,
      due_date = input$new_task_due_date,
      row_num = nrow(todo_data$data) + 1
    )
    todo_data$data <- rbind(todo_data$data, new_task)
    # Reset inputs to empty
    updateTextInput(session, "new_task_description", value = "")
    updateSelectInput(session, "new_course", selected = NULL)
    updateDateInput(session, "new_task_due_date", value = Sys.Date())
  })
  observeEvent(input$delete_selected_tasks, {
    selected_rows <- mod_todo_data()[input$todo_table_rows_selected, ]$row_num
    if (!is.null(selected_rows) && length(selected_rows) > 0) {
      todo_data$data <- todo_data$data[-selected_rows, ]
    }
  })
  # Observer for editing a selected course
  # Define a reactive conductor to store the selected row ID
  selected_row_id_task <- reactiveVal(NULL)
  # Observer to handle editing a selected course
  observeEvent(input$edit_selected_task, {
    # Check if a row is selected
    if (!is.null(input$todo_table_rows_selected) && length(input$todo_table_rows_selected) == 1) {
      # Get the selected row ID
      selected_row_id_task(mod_todo_data()[input$todo_table_rows_selected, ]$row_num)
      # Open the modal dialog for editing
      showModal(edit_task_modal)
      # Set the initial values in the modal
      cur_task <- todo_data$data[selected_row_id_task(), ]
      updateTextInput(session, "edit_task_description", value = cur_task$task_description)
      updateSelectInput(session, "edit_task_course", selected = cur_task$course_name)
      updateDateInput(session, "edit_task_due_date", value = cur_task$due_date)
    }
  })
  
  # Observer to handle saving changes in the modal
  observeEvent(input$save_changes_task, {
    # Ensure a row is selected
    if (!is.null(selected_row_id_task()) && length(selected_row_id_task()) == 1) {
      # Get the selected row ID
      current_row_id <- selected_row_id_task()
      # Update the course data with edited values
      todo_data$data[current_row_id, ] <- data.frame(
        course_name = input$edit_task_course,
        task_description = input$edit_task_description,
        due_date = input$edit_task_due_date,
        row_num = todo_data$data$row_num[current_row_id]
      )
      # Close the modal
      removeModal()
      # Reset the selected row ID
      selected_row_id_task(NULL)
    }
  })
  
  
  
  # COURSES_DF
  cur_selected_course <- reactiveVal(NULL)
  cur_selected_course_id <- reactiveVal(NULL)
  courses_data <- reactiveValues(data = courses_df)
  mod_courses_data <- reactive({
    courses_data$data %>% 
      mutate("Section" = str_c(type, " ", slot)) %>%
      rename("Course" = "course", "Day" = "day", "Start Time" = "st_time", "End Time" = "en_time",
             "Telegram" = "tele_link", "Google Drive" = "gdrive_link") %>%
      select(Course, Day, Section, `Start Time`, `End Time`, Telegram, `Google Drive`)
  })
  output$courses_table <- renderDT({
    datatable(mod_courses_data(), options = list(width = "100%", scrollX = TRUE, scrollY = TRUE))
  })
  # clean on add rows
  observeEvent(input$add_course, {
    new_course <- data.frame(
      course = input$new_course_name,
      slot = input$new_slot,
      type = input$new_type,
      day = input$new_day,
      st_time = format(as.POSIXlt(input$new_st_time), format = "%H:%M"),
      en_time = format(as.POSIXlt(input$new_en_time), format = "%H:%M"),
      id = nrow(courses_data$data) + 1,
      tele_link = input$new_tele_link,
      gdrive_link = input$new_gdrive_link
    )
    courses_data$data <- rbind(courses_data$data, new_course)
    # Reset inputs to empty
    updateTextInput(session, "new_course_name", value = "")
    updateTextInput(session, "new_slot", value = "")
    updateSelectInput(session, "new_type", selected = NULL)
    updateSelectInput(session, "new_day", selected = NULL)
    updateTimeInput(session, "new_st_time", value = as.POSIXct("10:00:00", format = "%T"))
    updateTimeInput(session, "new_en_time", value = as.POSIXct("11:00:00", format = "%T"))
    updateTextInput(session, "new_tele_link", value = "")
    updateTextInput(session, "new_gdrive_link", value = "")
  })
  observeEvent(input$delete_selected_courses, {
    selected_rows <- input$courses_table_rows_selected
    if (!is.null(selected_rows) && length(selected_rows) > 0) {
      courses_data$data <- courses_data$data[-selected_rows, ]
    }
  })
  # Observer for editing a selected course
  # Define a reactive conductor to store the selected row ID
  selected_row_id_course <- reactiveVal(NULL)
  # Observer to handle editing a selected course
  observeEvent(input$edit_selected_course, {
    # Check if a row is selected
    if (!is.null(input$courses_table_rows_selected) && length(input$courses_table_rows_selected) == 1) {
      # Get the selected row ID
      selected_row_id_course(input$courses_table_rows_selected)
      
      # Open the modal dialog for editing
      showModal(edit_course_modal)
      
      # Set the initial values in the modal
      cur_course <- courses_data$data[selected_row_id_course(), ]
      updateTextInput(session, "edit_course_name_course", value = cur_course$course)
      updateTextInput(session, "edit_slot_course", value = cur_course$slot)
      updateSelectInput(session, "edit_type_course", selected = cur_course$type)
      updateSelectInput(session, "edit_day_course", selected = cur_course$day)
      updateTimeInput(session, "edit_st_time_course", value = as.POSIXlt(cur_course$st_time, format = "%H:%M"))
      updateTimeInput(session, "edit_en_time_course", value = as.POSIXlt(cur_course$en_time, format = "%H:%M"))
      updateTextInput(session, "edit_tele_link_course", value = cur_course$tele_link)
      updateTextInput(session, "edit_gdrive_link_course", value = cur_course$gdrive_link)
    }
  })
  # Observer to handle saving changes in the modal
  observeEvent(input$save_changes_course, {
    # Ensure a row is selected
    if (!is.null(selected_row_id_course()) && length(selected_row_id_course()) == 1) {
      # Get the selected row ID
      current_row_id <- selected_row_id_course()
      # Update the course data with edited values
      courses_data$data[current_row_id, ] <- data.frame(
        course = input$edit_course_name_course,
        slot = input$edit_slot_course,
        type = input$edit_type_course,
        day = input$edit_day_course,
        st_time = format(input$edit_st_time_course, format = "%H:%M"),
        en_time = format(input$edit_en_time_course, format = "%H:%M"),
        id =  courses_data$data$id[current_row_id],
        tele_link = input$edit_tele_link_course,
        gdrive_link = input$edit_gdrive_link_course
      )
      # Close the modal
      removeModal()
      # Reset the selected row ID
      selected_row_id_course(NULL)
    }
  })
  
  
  
  
  # CARD LAYOUT
  output$cards <- renderUI({
    if (nrow(courses_data$data) > 0) {
      args <- lapply(1:nrow(courses_data$data), function(.x) {
        course_name <- courses_data$data[.x, "course"]
        course_id <- courses_data$data[.x, "id"]
        div(
          card("fa fa-book",
               .course_name = courses_data$data[.x, "course"], 
               .course_slot = courses_data$data[.x, "slot"], 
               .course_type = courses_data$data[.x, "type"], 
               .course_day = courses_data$data[.x, "day"], 
               .course_st_time = courses_data$data[.x, "st_time"], 
               .course_en_time = courses_data$data[.x, "en_time"]),
          href = paste0("#", str_replace_all(course_id, " ", "")),
          style = "cursor:pointer; text-decoration: none; color: inherit;",
          id = paste0("card_", str_replace_all(course_id, " ", ""))
        )
      })
      
      args$cellArgs <- list(
        style = "
        width: auto;
        height: auto;
        margin: 5px;
        ")
      do.call(shiny::flowLayout, args)
    } else {
      # Display a message if there are no courses
      div("No courses available.")
    }
  })
  update_select_card <- function(course_id){
    cur_course_name <- courses_data$data[courses_data$data$id == course_id, "course"]
    cur_selected_course(cur_course_name)
    cur_selected_course_id(course_id)
    showTab(inputId = "navbar", target = "Course Details")
    updateNavbarPage(session, 'navbar', selected = "Course Details")
  }
  
  observe({
    lapply(courses_data$data$id, function(i) {
      cur_cname <- paste0("card_", str_replace_all(i, " ", ""))
      shinyjs::onclick(cur_cname, function() {
        update_select_card(i)
      })
    })
  })
  
  # Observer to hide "Course Details" tab when switching to another tab
  observe({
    selected_tab <- input$navbar
    if (!is.null(selected_tab) && selected_tab != "Course Details") {
      hideTab(inputId = "navbar", target = "Course Details")
    }
  })
  
  
  
  
  # COURSE PAGE: STUDENT DF
  output$course_page_heading <- renderText({
    str_c(c("Course: ", cur_selected_course()))
  })
  
  observeEvent(input$telegram_button, {
    val1 <- courses_data$data %>% 
      filter(id == cur_selected_course_id())
    browseURL(val1[1, "tele_link"])
  })
  
  observeEvent(input$gdrive_button, {
    val1 <- courses_data$data %>% 
      filter(id == cur_selected_course_id())
    browseURL( val1[1, "gdrive_link"])
  })

  student_data <- reactiveValues(data = attendance_df)
  mod_student_data <- reactive({
    student_data$data %>% 
      filter(course_id == cur_selected_course_id()) %>%
      arrange(stu_name) %>%
      select("Student Name" = "stu_name", "Student No." = "stu_no", "Email ID" = "stu_email",
             "NUSNET ID" = "stu_nusnet_id", "stu_internal_id") %>% distinct()
  })
  output$student_table <- renderDT({
    datatable(mod_student_data() %>% select(-stu_internal_id), 
              options = list(pageLength = 10, width = "100%", scrollX = TRUE))
  })
  columns_attendance <- c("course_id", "stu_name", "stu_no", "stu_nusnet_id", "stu_email", 
                          "week_no", "res")
  observeEvent(input$add_student, {
    new_id <- length(unique(student_data$data$stu_internal_id)) + 1
    for (i in 1:13){
      new_stu <- data.frame(
        course_id = cur_selected_course_id(),
        stu_name = input$new_student_name,
        stu_no = input$new_student_no,
        stu_nusnet_id = input$new_student_netid, 
        stu_email = input$new_student_email,
        week_no = i, res = 0,
        stu_internal_id = new_id
      )
      student_data$data <- rbind(student_data$data, new_stu)
    }
    # Reset inputs to empty
    updateTextInput(session, "new_student_name", value = "")
    updateTextInput(session, "new_student_no", value = "")
    updateTextInput(session, "new_student_email", value = "")
    updateTextInput(session, "new_student_netid", value = "")
  })
  observeEvent(input$delete_student, {
    selected_rows <- mod_student_data()[input$student_table_rows_selected, ]$stu_internal_id
    if (!is.null(selected_rows) && length(selected_rows) > 0) {
      student_data$data <- student_data$data %>% filter(!stu_internal_id %in% selected_rows)
    }
  })
  # Observer for editing a selected course
  # Define a reactive conductor to store the selected row ID
  selected_row_id_stu <- reactiveVal(NULL)
  # Observer to handle editing a selected course
  observeEvent(input$edit_selected_student, {
    # Check if a row is selected
    if (!is.null(input$student_table_rows_selected) && length(input$student_table_rows_selected) == 1) {
      # Get the selected row ID
      selected_row_id_stu(input$student_table_rows_selected)
      # Open the modal dialog for editing
      showModal(edit_student_modal)
      # Set the initial values in the modal
      cur_stu <- mod_student_data()[selected_row_id_stu(), ]
      updateTextInput(session, "edit_student_name", value = cur_stu$`Student Name`)
      updateTextInput(session, "edit_student_no", value = cur_stu$`Student No.`)
      updateTextInput(session, "edit_student_email", value = cur_stu$`Email ID`)
      updateTextInput(session, "edit_student_netid", value = cur_stu$`NUSNET ID`)
    }
  })
  # Observer to handle saving changes in the modal
  observeEvent(input$save_changes_student, {
    # Ensure a row is selected
    if (!is.null(selected_row_id_stu()) && length(selected_row_id_stu()) == 1) {
      # Get the selected row ID
      current_row_id <- selected_row_id_stu()
      cur_stu <- mod_student_data()[selected_row_id_stu(), ]$stu_internal_id
      # TO COMPLETE
      student_data$data <- student_data$data %>% mutate(
        stu_name = ifelse(stu_internal_id == cur_stu, input$edit_student_name, stu_name),
        stu_no = ifelse(stu_internal_id == cur_stu, input$edit_student_no, stu_no),
        stu_email = ifelse(stu_internal_id == cur_stu, input$edit_student_email, stu_email),
        stu_nusnet_id = ifelse(stu_internal_id == cur_stu, input$edit_student_netid, stu_nusnet_id)
      )
      # Close the modal
      removeModal()
      # Reset the selected row ID
      selected_row_id_stu(NULL)
    }
  })
  
  
  
  
  # COURSE PAGE: ATTENDACE & CLAIMS
  selected_week <- reactiveVal(1)
  
  observeEvent(input$take_attendance, {
    # Render the UI with the attendance data in a DT table and ability to edit it
    output$course_tab <- renderUI({
      list(
        selectInput("selected_week", "Select Week:", choices = 1:13, selected = selected_week()),
        DTOutput("attendance_table")
      )
    })
    
    observe({
      selected_week(input$selected_week)
    })
    
    # Get the attendance data for the selected course and week
    attendance_data <- reactive({
      student_data$data %>%
        filter(course_id == cur_selected_course_id(), week_no == selected_week()) %>%
        arrange(stu_name) %>%
        select("Student Name" = stu_name, "Student No." = stu_no, "Attendance" = res, stu_internal_id, week_no)
    })
    
    # Render the DT table for attendance
    output$attendance_table <- renderDT({
      datatable(
        attendance_data() %>% select(-stu_internal_id) %>% select(-week_no),
        editable = list(target = "cell", disable = list(columns = c(1, 2, 4, 5, 6))),  # Disable editing for all columns except "Attendance"
        options = list(pageLength = 10, width = "100%", scrollX = TRUE),
        callback = JS('
        table.on("edit", function(e, dt, cell, value) {
          var index = table.cell(cell).index();
          Shiny.setInputValue("attendance_table_cell_edit", {
            stu_internal_id: table.row(index.row).data()[3],  // Assuming stu_internal_id is in the 3rd column
            week_no: table.row(index.row).data()[4],  // Assuming week_no is in the 4th column
            value: value
          });
        });
      ')
      )
    })
    
    # Observe the changes in the attendance table and update the data accordingly
    observeEvent(input$attendance_table_cell_edit, {
      info <- input$attendance_table_cell_edit
      cur_row <- attendance_data()[info$row,]
      student_data$data[student_data$data$stu_internal_id == cur_row$stu_internal_id & as.numeric(student_data$data$week_no) == as.numeric(cur_row$week_no), "res"] <- info$value
    })
  })
  
  
  
  
  claims_data <- reactiveValues(data = claims_df)
  calculated_values <- reactiveValues(
    max_working_hours = 176,  # Replace with your actual value
    current_working_hours_all_courses = 0,
    current_working_hours_selected_course = 0,
    total_earnings_selected_course = 0
  )
  
  
  observeEvent(input$manage_claims, {
    # Render the UI with claims data in a DT table and ability to add rows
    
    output$course_tab <- renderUI({
      list(
        DTOutput("claims_table"),
        dateInput("claim_date", "Date", value = Sys.Date()),
        fluidRow(
          column(3, timeInput("claim_time_in", "Time In:", value = "10:00:00", seconds = FALSE, minute.steps = 15)),
          column(3, timeInput("claim_time_out", "Time Out", value = "11:00:00", seconds = FALSE, minute.steps = 15))
        ),
        textInput("claim_task", "Task"),
        textInput("claim_rate_ph", "Rate per Hour", value = "40"),
        actionButton("add_claim", "Add Claim"),
        actionButton("delete_selected_claims", "Delete Claims"),
        actionButton("edit_selected_claims", "Edit Claim"),
        hr(),
        fluidRow(
          column(3,
                 wellPanel(
                   strong("Max Hours"),
                   p(calculated_values$max_working_hours)
                 )
          ),
          column(3,
                 wellPanel(
                   strong("Claimed Hours (All Courses)"),
                   p(calculated_values$current_working_hours_all_courses)
                 )
          ),
          column(3,
                 wellPanel(
                   strong("Claimed Hours (Current Course)"),
                   p(calculated_values$current_working_hours_selected_course)
                 )
          ),
          column(3,
                 wellPanel(
                   strong("Total Earnings (Current Course)"),
                   p(calculated_values$total_earnings_selected_course)
                 )
          )
        )
      )
    })
    
    # Get the claims data for the selected course
    mod_claims_data <- reactive({
      claims_data$data %>%
        filter(course_id == cur_selected_course_id()) %>%
        arrange(date) %>%
        select("Date" = date, "Time In" = time_in, "Time Out" = time_out, "Task" = task, "Rate per Hour" = rate_ph)
    })
    
    # Render the DT table for claims
    output$claims_table <- renderDT({
      datatable(mod_claims_data(), options = list(pageLength = 10, width = "100%", scrollX = TRUE))
    })
    
    observeEvent(input$add_claim, {
      new_claim <- data.frame(
        course_id = cur_selected_course_id(),
        date = input$claim_date,
        time_in = format(as.POSIXlt(input$claim_time_in), format = "%H:%M"),
        time_out = format(as.POSIXlt(input$claim_time_out), format = "%H:%M"),
        task = input$claim_task,
        rate_ph = input$claim_rate_ph
      )
      claims_data$data <- rbind(claims_data$data, new_claim)
      # Reset inputs to empty
      updateDateInput(session, "claim_date", value = Sys.Date())
      updateTimeInput(session, "claim_time_in", value = as.POSIXct("10:00:00", format = "%T"))
      updateTimeInput(session, "claim_time_out", value = as.POSIXct("11:00:00", format = "%T"))
      updateTextInput(session, "claim_task", value = "")
      updateTextInput(session, "claim_rate_ph", value = "40")
    })
    observeEvent(input$delete_selected_claims, {
      selected_rows <- input$claims_table_rows_selected
      if (!is.null(selected_rows) && length(selected_rows) > 0) {
        claims_data$data <- claims_data$data[-selected_rows, ]
      }
    })
    # Observer for editing a selected claim
    # Define a reactive conductor to store the selected row ID
    selected_row_id_claim <- reactiveVal(NULL)
    # Observer to handle editing a selected course
    observeEvent(input$edit_selected_claims, {
      # Check if a row is selected
      if (!is.null(input$claims_table_rows_selected) && length(input$claims_table_rows_selected) == 1) {
        # Get the selected row ID
        selected_row_id_claim(input$claims_table_rows_selected)
        # Open the modal dialog for editing
        showModal(edit_claim_modal)
        # Set the initial values in the modal
        cur_claim <- claims_data$data[selected_row_id_claim(), ]
        updateDateInput(session, "edit_claim_date", value = cur_claim$date)
        updateTimeInput(session, "edit_claim_time_in", value = as.POSIXlt(cur_claim$time_in, format = "%H:%M"))
        updateTimeInput(session, "edit_claim_time_out", value = as.POSIXlt(cur_claim$time_out, format = "%H:%M"))
        updateTextInput(session, "edit_claim_task", value = cur_claim$task)
        updateTextInput(session, "edit_claim_rate_ph", value = cur_claim$rate_ph)
      }
    })
    # Observer to handle saving changes in the modal
    observeEvent(input$save_changes_claim, {
      # Ensure a row is selected
      if (!is.null(selected_row_id_claim()) && length(selected_row_id_claim()) == 1) {
        # Get the selected row ID
        current_row_id <- selected_row_id_claim()
        print(data.frame(
          date = input$edit_claim_date,
          time_in = format(input$edit_claim_time_in, format = "%H:%M"),
          time_out = format(input$edit_claim_time_out, format = "%H:%M"),
          task = input$edit_claim_task,
          rate_ph = input$edit_claim_rate_ph
        ))
        # Update the course data with edited values
        claims_data$data[current_row_id, ] <- data.frame(
          course_id = cur_selected_course_id(),
          date = input$edit_claim_date,
          time_in = format(input$edit_claim_time_in, format = "%H:%M"),
          time_out = format(input$edit_claim_time_out, format = "%H:%M"),
          task = input$edit_claim_task,
          rate_ph = input$edit_claim_rate_ph
        )
        # Close the modal
        removeModal()
        # Reset the selected row ID
        selected_row_id_claim(NULL)
      }
    })
    
    observe({
      # Calculate current working hours across all courses
      calculated_values$current_working_hours_all_courses <- sum(as.numeric(difftime(
        as.POSIXlt(claims_data$data$time_out, format = "%H:%M"), as.POSIXlt(claims_data$data$time_in, format = "%H:%M"), 
        units = "hours")))
      
      # Calculate current working hours for the selected course
      calculated_values$current_working_hours_selected_course <- sum(as.numeric(difftime(
        as.POSIXlt(mod_claims_data()$`Time Out`, format = "%H:%M"),
        as.POSIXlt(mod_claims_data()$`Time In`, format = "%H:%M"),
        units = "hours"
      )))
      
      # Calculate total earnings for the selected course
      calculated_values$total_earnings_selected_course <- sum(
        as.numeric(difftime(
          as.POSIXlt(mod_claims_data()$`Time Out`, format = "%H:%M"),
          as.POSIXlt(mod_claims_data()$`Time In`, format = "%H:%M"),
          units = "hours"
        )) * as.numeric(mod_claims_data()$`Rate per Hour`)
      )
    })
    
    
  })
  
  # Analytics:
  observeEvent(input$analytics_button, {
    # Render the UI with analytics for each course
    output$course_tab <- renderUI({
      list(
      h3("Attendance Analytics"),
      plotOutput("attendance_plot"),
      h3("Claims Analytics"),
      plotOutput("claims_plot")
      )
    })
    
    # Analytics for attendance
    output$attendance_plot <- renderPlot({
      ggplot(student_data$data, aes(x = factor(week_no), fill = factor(res))) +
        geom_bar(position = "fill", stat = "count") +
        labs(title = "Attendance Analytics",
             x = "Week Number",
             y = "Percentage",
             fill = "Attendance Status")
    })
    
    # Analytics for claims (modify as needed)
    output$claims_plot <- renderPlot({
      temp_df <- claims_data$data
      # Calculate the difference in hours and create a new column 'hours'
      temp_df$hours <- as.numeric(difftime(as.POSIXlt(temp_df$time_out, format = "%H:%M"), as.POSIXlt(temp_df$time_in, format = "%H:%M"), units = "hours"))
      # Calculate the week number based on the date
      temp_df$iso_week <- week(temp_df$date)
      temp_df$iso_week <- as.integer(temp_df$iso_week)
      ggplot(temp_df, aes(x = factor(iso_week), y = hours)) +
        geom_bar(stat = "identity") +
        labs(title = "Claims Analytics",
             x = "Week Number",
             y = "Number of Hours")
    })
    
    
    # File upload
    # Define shinyFiles button
    
    observeEvent(input$upload_file, {
      req(input$upload_file$datapath)
      uploaded_data <- read.csv(input$upload_file$datapath)
      
      # Assuming columns in uploaded_data are 'Student Name', 'Student No', 'Student Email', 'Student NUSNET ID'
      col_names <- c("Student Name", "Student No", "Student Email", "Student NUSNET ID")
      
      # Ensure that the uploaded data has the required columns
      if (all(col_names %in% colnames(uploaded_data))) {
        student_data$data <- rbind(student_data$data, uploaded_data)
        for (j in 1:nrow(uploaded_data)){
          new_id <- length(unique(student_data$data$stu_internal_id)) + 1
          for (i in 1:13){
            new_stu <- data.frame(
              course_id = cur_selected_course_id(),
              stu_name = uploaded_data[j, 1],
              stu_no = uploaded_data[j, 2],
              stu_nusnet_id = uploaded_data[j, 4], 
              stu_email = uploaded_data[j, 3],
              week_no = i, res = 0,
              stu_internal_id = new_id
            )
            student_data$data <- rbind(student_data$data, new_stu)
          }
        }
      } else {
        # Handle case where required columns are missing
        showModal(modalDialog(
          title = "Error",
          "The uploaded data should have columns: 'Student Name', 'Student No', 'Student Email', 'Student NUSNET ID'.",
          easyClose = TRUE
        ))
      }
    })
    
  })
  
  
  # Saves:
  # Observer for exporting to CSV
  observeEvent(input$export_button, {
    # Specify the directory and file name for saving the CSV file
    if (!dir.exists("data")) {
      dir.create("data")
    }
    write.csv(courses_data$data, file = "data/courses_df.csv", row.names = FALSE)
    write.csv(todo_data$data, file = "data/todo_df.csv", row.names = FALSE)
    write.csv(student_data$data, file = "data/attendance_df.csv", row.names = FALSE)
    write.csv(claims_data$data, file = "data/claims_df.csv", row.names = FALSE)
    
    # Optionally, display a confirmation message
    showModal(
      modalDialog(
        title = "Export Successful",
        "All data has been successfully exported to CSV.",
        easyClose = TRUE
      )
    )
  })
  
  
  
}