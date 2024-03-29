# TA-Course-Management-Shiny-HNR

This Shiny app is designed to provide a platform for managing student attendance, claims, and analytics for courses, specifically designed for TAs at NUS. It allows easy tracking of student data, attendance records, and claims information.

## Project Structure

- `HackNRoll.Rproj`: RStudio project file.
- `app.R`: Main file containing the Shiny app code.
- `helper.R`: Helper functions for data manipulation or other utility functions.
- `ui.R`: User interface definition.
- `server.R`: Server logic for the Shiny app.
- `README.md`: Documentation file.
- `data.R`: File for data preprocessing and generation.
- `dummy_data.R`: File for dummy data preprocessing and generation.
- `images/`: Directory for storing images for this RMD.
- `dir/` Directory for storing data containing 4 csv files (Data section) which gets updated with the platform.

## Getting Started

To run the Shiny app locally, make sure you have R and RStudio installed. Open the `HackNRoll.Rproj` file in RStudio, and run the `app.R` file.

```R
# Install required packages
install.packages(c("shiny", "shinythemes", "shinyWidgets", "shinyTime", "DT", "tidyverse", "stringr", "lubridate", "shinydashboard", "shinyjs", "plotly", "ggplot2", "shinyFiles"))

# Run data.R script to create empty data frames (otherwise will be filled with dummy data)

# Run the app
shiny::runApp()
```

## Features

### 1. Task Management
Effortlessly stay on top of your course workload by tracking tasks and deadlines. Dive into the Home Page for a sleek overview of all your courses.
![Task Management](images/home_page.png)

### 2. Course Management
Take control of your teaching assistant role with the power to add, delete, and finesse the details of the courses you're TA-ing.
![Task Management](images/courses.png)

### 3. Student Management
Craft an organized academic realm by seamlessly adding, deleting, and refining student information for each course.
![Student Management](images/student_list.png)

### 4. Attendance Tracking
Take attendance for different weeks and mark students as present, absent, or other.
![Attendance Tracking](images/attendance.png)

### 5. Claims Management
Harness the potential of a structured workflow by managing claims for various tasks, complete with date, time, and task details.
![Claims Management](images/claims.png)

### 6. Analytics
Elevate your insights game with analytics that not only unravel attendance patterns and claims but also present them in captivating visualizations powered by ggplot for specfic courses as well as across all courses.
![Analytics (Course)](images/analytics.png)
![Analytics (Overall)](images/analytics_page.png)


## Required Packages

- `shiny`: Main package for building Shiny web applications.
- `shinythemes`: Additional themes for Shiny apps.
- `shinyWidgets`: Custom widgets and components for Shiny apps.
- `shinyTime`: Time input widgets for Shiny apps.
- `DT`: Interactive tables for Shiny apps.
- `tidyverse`: Collection of packages for data manipulation and visualization.
- `stringr`: String manipulation functions.
- `lubridate`: Date and time manipulation functions.
- `shinydashboard`: Dashboard framework for Shiny apps.
- `shinyjs`: JavaScript functions for Shiny apps.
- `plotly`: Interactive plots for Shiny apps.
- `ggplot2`: Grammar of Graphics for creating static plots.
- `shinyFiles`: File input and output widgets for Shiny apps.

## Data

All data is maintained locally in the data folder. It s importnt to click on save data button to svae all changes made to the data.
- `courses_df`: Dataframe containing information about different courses.
- `attendance_df`: Dataframe for storing attendance records.
- `claims_df`: Dataframe for managing claims information.
- `todo_df`: Dataframe with tasks and deadlines.

## License
This project is licensed under the MIT License - see the LICENSE file for details.






