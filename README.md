# eSC-electricity-demand

This repository contains the work done for the Peak Energy Demand Management project, where we address the energy company eSC's concerns about increased electricity demand during peak summer months. The primary goal is to predict energy usage and explore methods to reduce consumption during peak periods to avoid infrastructure expansion.

## Project Overview
The project focuses on:
- Analyzing energy consumption patterns.
- Predicting future energy demand using multiple machine learning models.
- Identifying strategies to reduce peak energy consumption through data analysis and forecasting.
- Developing a Shiny web application to visualize and interact with energy usage data and predictions.

## Project Scope
The project is divided into the following tasks:
1. **Data Preparation**: Merge and clean static house data, energy usage data, and weather data.
2. **Exploratory Data Analysis (EDA)**: Analyze energy consumption patterns across different attributes such as house size, number of rooms, and weather conditions.
3. **Modeling**: Build predictive models to forecast future energy usage based on environmental factors.
4. **Peak Demand Estimation**: Evaluate peak energy demand during the hottest summer months, particularly focusing on July.
5. **Shiny App**: Develop an interactive Shiny app for the CEO to explore the data, predictions, and potential strategies to reduce peak demand.

## Data Sources
We used four datasets for this project:
1. **Static House Data**: Information on house attributes.
2. **Energy Usage Data**: Hourly energy consumption records for residential properties.
3. **Weather Data**: Hourly weather data for various counties in South Carolina.
4. **Meta Data**: Data dictionary explaining the various fields in the datasets.

## Exploratory Data Analysis
We performed a detailed analysis of energy consumption patterns, examining:
- The relationship between energy usage and weather conditions (temperature, humidity).
- Household attributes affecting energy consumption.
- Hourly patterns showing peak usage times during the day.

## Modelling
Three models were explored for predicting energy usage:
1. **Linear Regression**: Achieved a prediction accuracy of 91% after adjusting key variables.
2. **Decision Tree**: Provided an accuracy of 95%, though prone to overfitting.
3. **Random Forest**: Achieved 99% accuracy but showed signs of overfitting, so not used in final predictions.

The Linear Regression model was selected for its balance between accuracy and generalizability.

## Shiny Application
We developed an interactive Shiny web app that allows users to:
- Select variables for energy analysis.
- Visualize energy consumption patterns using histograms and line charts.
- Predict future energy demand based on user-defined environmental inputs.

You can access the Shiny app [here](https://2fkohm-advait-narvekar.shinyapps.io/Project/)&#8203;:contentReference[oaicite:0]{index=0}.

## Installation and Setup
### Requirements
- R version 4.0 or above.
- Shiny package: Install it by running `install.packages('shiny')`.
- Tidyverse package: Install it by running `install.packages('tidyverse')`.

### Running the App Locally
1. Clone this repository.
2. Ensure the `app.R` file is in your working directory.
3. Open RStudio and run the app using the following command:
   ```R
   shiny::runApp('app.R')
