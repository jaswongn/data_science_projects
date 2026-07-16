#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)
library(gridExtra)
library(ggcorrplot)
library(dplyr)

ui <- fluidPage(
  titlePanel("CITS 4009 Project"),
  # ChatGPT(2025) helped me understand how to use tabsPanel and tabPanel function. the code within is developed independently by me.
  tabsetPanel(
    tabPanel("Single EDA",
             sidebarLayout(
               sidebarPanel(
                 
                 selectInput("dataset_single", "Choose dataset:", 
                             choices = c("Box Office", "GDP", "Population")),
                 
                 selectInput("plot_type_single", "Select plot type:", 
                             choices = c("Histogram", "Density Plot", "Bar Plot")),
                 
                 # conditional panel to add conditions on the choices from select Input
                 conditionalPanel(
                   condition = "input.plot_type_single == 'Histogram' || input.plot_type_single == 'Density Plot' || input.plot_type_single == 'Bar Plot'",
                   selectInput("x_attr_single", "Select x-axis", choices = NULL)
                 ),
                 conditionalPanel(
                   condition = "input.plot_type_single == 'Histogram'",
                   sliderInput("bins", "Number of bins:", min = 5, max = 100, value = 30)
                 ),
                 helpText("Select a dataset and a variable")
               ),
               
               mainPanel(
                 plotOutput("plot_single",height = "400px", width = "600px")
               )
             )
    ),
    
    tabPanel("Multi EDA",
             sidebarLayout(
               sidebarPanel(
                 
                 selectInput("dataset_multi", "Choose dataset:", 
                             choices = c("Box Office", "GDP Population", "Population", "Time Data")),
                 
                 selectInput("plot_type_multi", "Select plot type:", 
                             choices = c("Scatterplot", "Box Plot", "Line Plot", "Correlation Plot")),
                 
                 # conditional panel to add conditions on the choices from select Input
                 conditionalPanel(
                   condition = "input.plot_type_multi == 'Scatterplot' || input.plot_type_multi == 'Line Plot' || input.plot_type_multi == 'Box Plot'",
                   selectInput("x_attr_multi", "Select x-axis", choices = NULL),
                   selectInput("y_attr_multi", "Select y-axis", choices = NULL)
                 ),
                 
                 conditionalPanel(
                   condition = "input.plot_type_multi == 'Correlation Plot'",
                   helpText("Correlation Plot uses all numeric columns.")
                 )
               ),
               
               mainPanel(
                 plotOutput("plot_multi",height = "400px", width = "600px")
               )
             )
    ),
    
    tabPanel("Single Variable Model",
             sidebarLayout(
               sidebarPanel(
                 
                 # dropdown to choose what type of plot we want
                 selectInput("singlemodel_display", "Seelct output:", 
                             choices = c("AUC Scores", "Cross Validation", "Deviance Reduction", "ROC Curves")),
                 helpText("Display results from single-variable model selection.")
               ),
               
               mainPanel(
                 conditionalPanel(
                   condition = "input.singlemodel_display == 'AUC Scores'",
                   tableOutput("auc_table")
                 ),
                 conditionalPanel(
                   condition = "input.singlemodel_display == 'Cross Validation'",
                   tableOutput("kfold_table")
                 ),
                 conditionalPanel(
                   condition = "input.singlemodel_display == 'ROC Curves'",
                   plotOutput("roc_plot")
                 ),
                 conditionalPanel(
                   condition = "input.singlemodel_display == 'Deviance Reduction'",
                   tableOutput("deviance_table")
                 )
               )
             )
    ),
    
    tabPanel("Multi Variable Models",
             sidebarLayout(
               sidebarPanel(
                 
                 # dropdown to choose what type of plot we want
                 selectInput("multimodel_display", "Seelct output:", 
                             choices = c("All Features Decision Tree", "All Features Naive Bayes", "Selected Features Decision Tree", "Selected Features Naive Bayes")),
                 helpText("Display results from multi-variable model selection.")
               ),
               
               mainPanel(
                 conditionalPanel(
                   condition = "input.multimodel_display == 'All Features Decision Tree'",
                   plotOutput("tree_plot"),
                   tableOutput("tree_all_table"),
                   verbatimTextOutput("tree_all_auc"),
                   plotOutput("roc_tree_plot")
                 ),
                 conditionalPanel(
                   condition = "input.multimodel_display == 'All Features Naive Bayes'",
                   tableOutput("nb_all_table"),
                   verbatimTextOutput("nb_all_auc"),
                   plotOutput("nb_roc_plot"),
                   plotOutput("roc_all_plot")
                 ),
                 conditionalPanel(
                   condition = "input.multimodel_display == 'Selected Features Decision Tree'",
                   plotOutput("tree_selected_plot"),
                   tableOutput("tree_selected_table"),
                   verbatimTextOutput("tree_selected_auc"),
                   plotOutput("roc_tree_select_plot"),
                 ),
                 conditionalPanel(
                   condition = "input.multimodel_display == 'Selected Features Naive Bayes'",
                   tableOutput("nb_selected_table"),
                   verbatimTextOutput("nb_selected_auc"),
                   plotOutput("roc_nb_select_plot"),
                   plotOutput("roc_selected_plot")
                 )
               )
             )
    ),
    
    tabPanel("LIME",
             sidebarLayout(
               sidebarPanel(
                 selectInput("lime_display", "Select output:", 
                             choices = c("Decision Tree", "Naive Bayes")),
                 helpText("View Lime feature explanations")
               ),
               
               mainPanel(
                 conditionalPanel(
                   condition = "input.lime_display == 'Decision Tree'",
                   plotOutput("lime_tree_plot", height = "500px")
                 ),
                 conditionalPanel(
                   condition = "input.lime_display == 'Naive Bayes'",
                   plotOutput("lime_nb_plot", height = "500px")
                 )
               )
             )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  datasets <- list(
    "Box Office" = box_office_v2,
    "GDP" = gdp_v4,
    "Population" = population_v4,
    "GDP Population" = gdp_population,
    "Time Data" = time_data
  )
  
  # ChatGPT(2025) helped me understand how to use observe function. the code within is developed independently by me.
  observe({
    d <- datasets[[input$dataset_single]]
    vars <- names(d)
    catVars <- vars[sapply(d[, vars], class) %in% c('factor', 'character')]
    numericVars <- vars[sapply(d[, vars], class) %in% c('numeric', 'integer')]
    
    if(input$plot_type_single %in% c("Histogram", "Density Plot")){
       updateSelectInput(session, "x_attr_single",
                         choices = numericVars
                         )
    } else if(input$plot_type_single %in% c("Bar Plot")){
      updateSelectInput(session, "x_attr_single",
                        choices = catVars
      )
    }
    
  })
  
  output$plot_single <- renderPlot({
    dataset <- datasets[[input$dataset_single]]
    x_attr_single <- input$x_attr_single
    vars <- names(dataset)
    catVars <- vars[sapply(dataset[, vars], class) %in% c('factor', 'character')]
    numericVars <- vars[sapply(dataset[, vars], class) %in% c('numeric', 'integer')]
    
    if(x_attr_single %in% numericVars){
      if(input$plot_type_single == "Histogram"){
        bins <-  ifelse(is.null(input$bins), 30, input$bins)
        ggplot(dataset, aes_string(x = x_attr_single)) +
          geom_histogram(fill = "#99ccff", color = "#3366cc", bins = bins) +
          labs(x = x_attr_single)
      } else if(input$plot_type_single == "Density Plot"){
        ggplot(dataset, aes_string(x = x_attr_single)) +
          geom_histogram(aes(y = ..density..),fill = "#99ccff", color = "#3366cc") +
          geom_density(color = "#3366cc", linewidth = 1) + 
          scale_x_log10() +
          labs(x = x_attr_single)
      }} else if(x_attr_single %in% catVars){
        count <- table(dataset[[x_attr_single]]) %>% sort(decreasing = TRUE) %>% head(10)
        top_10 <- names(count[1:10])
        top_10_x <- subset(dataset, dataset[[x_attr_single]] %in% top_10)
        count_x <- as.data.frame(count)
        colnames(count_x) <- c("X", "Y")
        count_x <- transform(count_x, X=reorder(X,Y))
        
        ggplot(count_x, aes(x = X, y = Y)) +
          geom_bar(stat = "identity", fill = "gray") +
          labs(x = x_attr_single, y ="Count") +
          coord_flip()
    }
  })
  
  observe({
    d <- datasets[[input$dataset_multi]]
    vars <- names(d)
    catVars <- vars[sapply(d[, vars], class) %in% c('factor', 'character')]
    numericVars <- vars[sapply(d[, vars], class) %in% c('numeric', 'integer')]
    
    if(input$plot_type_multi %in% c("Scatterplot", "Line Plot")){
      updateSelectInput(session, "x_attr_multi", choices = numericVars)
      updateSelectInput(session, "y_attr_multi", choices = numericVars)
    } else if(input$plot_type_multi == "Box Plot"){
      updateSelectInput(session, "x_attr_multi", choices = catVars)
      updateSelectInput(session, "y_attr_multi", choices = numericVars)
    } 
  })
  
  output$plot_multi <- renderPlot({
    dataset <- datasets[[input$dataset_multi]]
    x_attr_multi <- input$x_attr_multi
    y_attr_multi <- input$y_attr_multi
    vars <- names(dataset)
    catVars <- vars[sapply(dataset[, vars], class) %in% c('factor', 'character')]
    numericVars <- vars[sapply(dataset[, vars], class) %in% c('numeric', 'integer')]
    
    if (input$plot_type_multi == "Correlation Plot"){
      corr_data <- cor(dataset[,sapply(dataset, is.numeric)])
      ggcorrplot(corr_data, lab = TRUE, hc.order = TRUE, type = "lower")
      
    } else if(x_attr_multi %in% numericVars & y_attr_multi %in% numericVars) {
        if(input$plot_type_multi == "Scatterplot"){
          ggplot(dataset, aes_string(x = x_attr_multi, y = y_attr_multi)) +
            geom_point(color = "#3366cc") +
            scale_x_log10() +
            scale_y_log10() +
            geom_smooth(method = "lm", se = FALSE, color = "red", formula = y ~ x) +
            labs(x = x_attr_multi, y = y_attr_multi)
      } else if(input$plot_type_multi == "Line Plot"){
          ggplot(dataset, aes_string(x = x_attr_multi, y = y_attr_multi)) +
            geom_line(color = "#3366cc") +
          labs(x = x_attr_multi, y = y_attr_multi)
      }
      } else if(x_attr_multi %in% catVars & y_attr_multi %in% numericVars) {
          if(input$plot_type_multi == "Box Plot"){
            count <- table(dataset[[x_attr_multi]]) %>% sort(decreasing = TRUE) %>% head(10)
            top_10 <- names(count[1:10])
            top_10_x <- subset(dataset, dataset[[x_attr_multi]] %in% top_10)
            ggplot(top_10_x, aes_string(x = x_attr_multi, y = y_attr_multi)) +
              geom_boxplot() + 
              scale_y_log10() + 
              coord_flip() +
              labs(x = x_attr_multi, y = y_attr_multi)
        }
      }
  })
  
  auc_results <- data.frame(
    Variable = c("Adventure", "American_Movie", "English_Movie", "Rating", "Vote_Count", "MV_per_capita"),
    TrainAUC = c(0.685, 0.666, 0.651, 0.674, 0.900, 0.981),
    CalAUC = c(0.732, 0.695, 0.704, 0.670, 0.915, 0.989)
  )
  
  output$auc_table <- renderTable({
    auc_results
  }, digits = 3)
  
  kfold_results <- data.frame(
    Variable = c("Adventure", "American_Movie", "English_Movie", "Rating", "Vote_Count", "MV_per_capita"),
    MeanAUC = c(0.690, 0.673, 0.654, 0.667, 0.895, 0.980),
    SDAUC = c(0.039, 0.021, 0.021, 0.039, 0.024, 0.010)
  )
  
  output$kfold_table <- renderTable({
    kfold_results
  }, digits = 3)
  
  dev_results <- data.frame(
    Variable = c("predAdventure", "predAmerican_Movie", "predEnglish_Movie", "predRating", "predVote_Count", "predMV_per_capita"),
    Deviance_Reduction = c(37.6927, 31.5993, 32.0585, 14.088, 121.181, 218.656)
  )
  
  output$deviance_table <- renderTable({
    dev_results
  }, digits = 3)
  
  output$roc_plot <- renderPlot({
    plot_roc <- function(predcol, outcol, colour_id=2, overlaid=F) {
      ROCit_obj <- rocit(score=predcol, class=outcol==pos)
      par(new=overlaid)
      plot(ROCit_obj, col = c(colour_id, 1),
           legend = FALSE, YIndex = FALSE, values = FALSE)
    }
    plot_roc(dCal$predMV_per_capita, dCal[,outcome]) #red
    plot_roc(dCal$predVote_Count, dCal[,outcome], colour_id=3, overlaid=T) # green
    plot_roc(dCal$predRating, dCal[,outcome], colour_id=4, overlaid=T)
    plot_roc(dCal$predAdventure, dCal[,outcome], colour_id=5, overlaid=T)
    plot_roc(dCal$predAmerican_Movie, dCal[,outcome], colour_id=6, overlaid=T)
    plot_roc(dCal$predEnglish_Movie, dCal[,outcome], colour_id=7, overlaid=T)
  })
  
  tree_all_auc <- c(train = 0.920, cal = 0.959, test = 0.918)
  tree_all_perf <- data.frame(
    dataset = c("training", "test"),
    precision = c(0.841, 0.816),
    recall = c(0.858, 0.857),
    f1 = c(0.849, 0.836),
    dev_norm = c(0.232, 0.250)
  )
  
  output$tree_plot <- renderPlot({
    rpart.plot(tree_model)
  })
  
  
  output$roc_tree_plot <- renderPlot({
    plot_roc2 <- function(predcol1, outcol1, predcol2, outcol2){
      roc_1 <- rocit(score=predcol1, class=outcol1==pos)
      roc_2 <- rocit(score=predcol2, class=outcol2==pos)
      plot(roc_1, col = c("blue","green"), lwd = 3,
           legend = FALSE,YIndex = FALSE, values = TRUE, asp=1)
      lines(roc_2$TPR ~ roc_2$FPR, lwd = 3,
            col = c("red","green"), asp=1)
      legend("bottomright", col = c("blue","red", "green"),
             c("Test Data", "Training Data", "Null Model"), lwd = 2)
    }
    pred_test_roc <- predict(tmodel, newdata=dTest)[,"1"]
    pred_train_roc <- predict(tmodel, newdata=dTrain)[,"1"]
    
    plot_roc2(pred_test_roc, dTest[[outcome]], pred_train_roc, dTrain[[outcome]])
  })
  
  output$tree_all_auc <- renderPrint({
    print(tree_all_auc)
  })
  
  output$tree_all_table <- renderTable({
    tree_all_perf
  }, digits = 3)
  
  nb_all_auc <- c(train = 0.974, cal = 0.986, test = 0.958)
  nb_all_perf <- data.frame(
    dataset = c("training", "test"),
    precision = c(0.637, 0.647),
    recall = c(0.883, 0.898),
    f1 = c(0.740, 0.752),
    dev_norm = c(0.722, 0.863)
  )
  
  output$nb_roc_plot <- renderPlot({
    plot_roc2(pred_nb_test_roc, dTest[[outcome]], pred_nb_train_roc, dTrain[[outcome]])
  })
  
  output$nb_all_auc <- renderPrint({
    print(nb_all_auc)
  })
  
  output$nb_all_table <- renderTable({
    nb_all_perf
  }, digits = 3)
  
  output$roc_all_plot <- renderPlot({
    plot(roc_tree, col = "blue", lwd = 2, main = "ROC Curve for Decision Tree and Naive Bayes")
    plot(roc_nb, col = "red", lwd = 2, add = TRUE)
    legend("bottomright", legend = c("Decision Tree", "Naives Bayes"), col=c("blue","red"), lwd = 2)
  })
  
  tree_selected_auc <- c(train = 0.910, cal = 0.959, test = 0.911)
  tree_selected_perf <- data.frame(
    dataset = c("training", "test"),
    precision = c(0.879, 0.863),
    recall = c(0.832, 0.837),
    f1 = c(0.855, 0.850),
    dev_norm = c(0.233,0.244)
  )
  
  output$roc_tree_select_plot <- renderPlot({
    pred_tree_select_test_roc <- predict(tree_select_model, newdata=dTest)[,"1"]
    pred_tree_select_train_roc <- predict(tree_select_model, newdata=dTrain)[,"1"]
    
    plot_roc2(pred_tree_select_test_roc, dTest[[outcome]], pred_tree_select_train_roc, dTrain[[outcome]])
    })
  
  output$tree_selected_plot <- renderPlot({
    rpart.plot(tree_select_model)
  })
  output$tree_selected_auc <- renderPrint({
    print(tree_selected_auc)
  })
  
  output$tree_selected_table <- renderTable({
    tree_selected_perf
  }, digits = 3)
  
  nb_selected_auc <- c(train = 0.981, cal = 0.989, test = 0.971)
  nb_selected_perf <- data.frame(
    dataset = c("training", "test"),
    precision = c(0.705, 0.698),
    recall = c(0.902, 0.898),
    f1 = c(0.792, 0.786),
    dev_norm = c(0.436, 0.641)
  )
  
  output$roc_nb_select_plot <- renderPlot({
    plot_roc2(pred_nb_select_test_roc, dTest[[outcome]], pred_nb_select_train_roc, dTrain[[outcome]])
  })
  
  output$nb_selected_auc <- renderPrint({
    print(nb_selected_auc)
  })
  
  output$nb_selected_table <- renderTable({
    nb_selected_perf
  }, digits = 4)
  
  output$roc_selected_plot <- renderPlot({
    plot(roc_select_tree, col = "blue", lwd = 2, main = "ROC Curve for Decision Tree and Naive Bayes")
    plot(roc_select_nb, col = "red", lwd = 2, add = TRUE)
    legend("bottomright", legend = c("Decision Tree", "Naives Bayes"), col=c("blue","red"), lwd = 2)
  })
  
  output$lime_tree_plot <- renderPlot({
    plot_features(explanation_tree)
  })
  
  output$lime_nb_plot <- renderPlot({
    plot_features(explanation_nb)
  })
  
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
