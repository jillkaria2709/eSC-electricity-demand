# Load the shiny package
library(shiny)
library(tidyverse)
transformed_data <- read_csv('transformed_data.csv')

# Define UI components
ui <- fluidPage(
    titlePanel("Energy Consumption Prediction App"),
    sidebarLayout(
        sidebarPanel(
            
            selectInput("column", "Select Column:", choices = colnames(transformed_data)),
            
            h3("Linear Regression Model Generation:"),
            actionButton("train", "Generate Model"),
            
            br(),
            # 1 hour
            sliderInput("hour", "Select an hour:", min = 0, max = 23, value = 12),
            # 2 Dry.Bulb.Temperature...C.
            numericInput("Dry.Bulb.Temperature...C.", "Enter Dry Bulb Temperature(C) Value:", value = 0),
            # 3 Relative.Humidity....
            numericInput("Relative.Humidity...", "Enter Relative Humidity Value:", value = 0),
            # 4 Wind.Speed..m.s.
            numericInput("Wind.Speed..m.s.", "Enter Wind Speed (m.s,) Value:", value = 0),
            # 5 Wind.Direction..Deg.
            numericInput("Wind.Direction..Deg.", "Enter Wind.Direction (Deg.) Value:", value = 0),
            # 6 Global.Horizontal.Radiation..W.m2.
            numericInput("Global.Horizontal.Radiation..W.m2.", "Enter Global.Horizontal.Radiation (W.m2.) Value:", value = 0),
            # 7 Direct.Normal.Radiation..W.m2.
            numericInput("Direct.Normal.Radiation..W.m2.", "Direct Normal Radiation (W.m2.) Value:", value = 0),
            # 8 Diffuse.Horizontal.Radiation..W.m2.
            numericInput("Diffuse.Horizontal.Radiation..W.m2.", "Diffuse Horizontal Radiation (W.m2.) Value:", value = 0),
            # 9 in.puma
            selectInput("in_puma", "Select an in.puma:", choices = unique(sort(transformed_data$in.puma)), multiple = FALSE),
            # 10 in.reeds_balancing_area
            numericInput("in.reeds_balancing_area", "In Reeds Balancing Area Value:", value = 0),
            # 11 in.weather_file_longitude
            numericInput("in.weather_file_longitude", "In Weather File Longitude Value:", value = 0),
            br(),
      
            h4('Future Energy Prediction'),
      
            # 12 Change in temperature
            sliderInput("temperature", "Increase in Temperature (C):", min = -10, max = 10, value = 0),
            br(),
            actionButton("predict", "Predict")
        ),
        mainPanel(
            h3("Histogram:"),
            plotOutput("histogram"),
            hr(),
            h3("Linear Regression Model Summary:"),
            verbatimTextOutput("model_summary"),
            hr(),
            h3("Predicted Outcome:"),
            htmlOutput("predicted_outcome")
        )
    )
)
# Define server logic
server <- function(input, output) {
    
    # reactive function for filter data
    selected_data <- reactive({
        transformed_data %>% select(hour, input$column, mean_total_energy_consumed)
  })
  
    # output histogram
    output$histogram <- renderPlot({
        ggplot(selected_data(), aes(x = hour, y = get(input$column), fill = as.factor(hour))) + geom_bar(stat = "identity", position = "dodge", color = "white", alpha = 0.7) + labs(title = paste("Histogram of", input$column, "with respect to hours"), x = "Hour", y = input$column) + theme_minimal()
    })
  
    model <- reactiveValues(lm_model = NULL)
    predicted_output <- reactiveVal(NULL)
  
    observeEvent(input$train, {
    # Generating linear regression model
        row.number <- sample(1:nrow(transformed_data), 0.95 * nrow(transformed_data))
        train_Data = transformed_data[row.number, ]
        test_Data = transformed_data[-row.number, ]
        model$lm_model <- lm(mean_total_energy_consumed ~ ., data = train_Data)
    })
  
  # Show summary of the model
    output$model_summary <- renderPrint({
        req(input$train)
        summary(model$lm_model)
    })
  
    observeEvent(input$predict, {
        if (!is.null(model$lm_model)) {
        # Prepare input data for prediction
            predict_data <- data.frame(
                hour = input$hour,
                Dry.Bulb.Temperature...C. = input$`Dry.Bulb.Temperature...C.`,
                Relative.Humidity.... = input$`Relative.Humidity...`,
                Wind.Speed..m.s. = input$`Wind.Speed..m.s.`,
                Wind.Direction..Deg. = input$`Wind.Direction..Deg.`,
                Global.Horizontal.Radiation..W.m2. = input$`Global.Horizontal.Radiation..W.m2.`,
                Direct.Normal.Radiation..W.m2. = input$`Direct.Normal.Radiation..W.m2.`,
                Diffuse.Horizontal.Radiation..W.m2. = input$`Diffuse.Horizontal.Radiation..W.m2.`,
                in.puma = input$in_puma,
                in.reeds_balancing_area = input$`in.reeds_balancing_area`,
                in.weather_file_longitude = input$`in.weather_file_longitude`
            )
      
            change_in_temp <- input$`temperature`
            # Check for missing values in input data
            if (any(sapply(predict_data, function(x) {any(is.na(x))}))){
                predicted_output(NULL)
                showModal(modalDialog(title = "Warning","Please fill in all the input fields before prediction."))
            } else {
                # Predict outcome using the trained model
                predicted <- c()
                predicted <- c(predicted, predict(model$lm_model, newdata = predict_data))
                predict_data$Dry.Bulb.Temperature...C. <- predict_data$Dry.Bulb.Temperature...C. + change_in_temp
                predicted <- c(predicted, predict(model$lm_model, newdata = predict_data))
                predicted_output(predicted)
            }
        }
    })
  
    output$predicted_outcome <- renderText({
        if (!is.null(predicted_output())) {
            # Display both current and future predicted energy consumption
            result <- predicted_output()
            HTML(paste("<h3>","Predicted Energy Consumption:", round(result[1], 2), "kWh","</h3>",'<br><h3>',"Future Predicted Energy Consumption:", round(result[2], 2), "kWh",'</h3>'))
        }
    })
}
#Visualizations
# main_app.R


# Run the application
shinyApp(ui, server)


